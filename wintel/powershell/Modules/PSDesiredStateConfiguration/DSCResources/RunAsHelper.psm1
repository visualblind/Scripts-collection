###########################################################################
# built-in DSCResources common functions for Credentials and RunAs support
###########################################################################

Set-StrictMode -version Latest

Import-Module "$PSScriptRoot\DSCResourceHelper.psm1"

data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData @'
ErrorInvalidUserName=UserName {0} is not valid.
UserCouldNotBeLoggedError=The user could not be logged on. Ensure that the user has an existing profile on the machine and that correct credentials are provided. Logon error #
OpenProcessTokenError=Open process token error #
PrivilegeLookingUpError=Error in looking up privilege of the process. This should not happen if DSC is running as LocalSystem Lookup privilege error #
TokenElevationError=Token elevation error #
DuplicateTokenError=Duplicate Token error #
CouldNotCreateProcessError=The process could not be created. Create process as user error #
WaitFailedError=Wait during create process failed user error #
RetriveStatusError=Retrieving status error #
'@
}

Import-LocalizedData LocalizedData -filename RunAsHelper.strings.psd1
$EscapedLocalizedData = @{}
foreach( $key in $LocalizedData.Keys )
{
    $EscapedLocalizedData.Add($key, $LocalizedData[$key].Replace('"','""'))
}
$LocalizedData = $EscapedLocalizedData

#
# The goal of this function is to get domain and username from PSCredential 
# without calling GetNetworkCredential() method. 
# Call to GetNetworkCredential() expose password as a plain text in memory.
#
function Get-DomainAndUserName([PSCredential]$Credential)
{
    #
    # Supported formats: DOMAIN\username, username@domain
    #
    $wrongFormat = $false
    if ($Credential.UserName.Contains('\')) 
    {
        $segments = $Credential.UserName.Split('\')
        if ($segments.Length -gt 2)
        {
            # i.e. domain\user\foo
            $wrongFormat = $true
        } else {
            $Domain = $segments[0]
            $UserName = $segments[1]
        }
    } 
    elseif ($Credential.UserName.Contains('@')) 
    {
        $segments = $Credential.UserName.Split('@')
        if ($segments.Length -gt 2)
        {
            # i.e. user@domain@foo
            $wrongFormat = $true
        } else {
            $UserName = $segments[0]
            $Domain = $segments[1]
        }
    }
    else 
    {
        # support for default domain (localhost)
        return @( $env:COMPUTERNAME, $Credential.UserName )
    }

    if ($wrongFormat) 
    {
        $message = $LocalizedData.ErrorInvalidUserName -f $Credential.UserName
        Write-Verbose $message
        $exception = New-Object System.ArgumentException $message
        throw New-Object System.Management.Automation.ErrorRecord $exception, "InvalidUserName", InvalidArgument, $null  
    }

    return @( $Domain, $UserName )
}

function Import-DscNativeMethods
{
$script:ProgramSource = @"

using System;
using System.Collections.Generic;
using System.Text;
using System.Security;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Security.Principal;
#if !CORECLR
using System.ComponentModel;
#endif
using System.IO;

namespace PSDesiredStateConfiguration
{
#if !CORECLR
    [SuppressUnmanagedCodeSecurity]
#endif
    public static class NativeMethods
    {
        //The following structs and enums are used by the various Win32 API's that are used in the code below

        [StructLayout(LayoutKind.Sequential)]
        public struct STARTUPINFO
        {
            public Int32 cb;
            public string lpReserved;
            public string lpDesktop;
            public string lpTitle;
            public Int32 dwX;
            public Int32 dwY;
            public Int32 dwXSize;
            public Int32 dwXCountChars;
            public Int32 dwYCountChars;
            public Int32 dwFillAttribute;
            public Int32 dwFlags;
            public Int16 wShowWindow;
            public Int16 cbReserved2;
            public IntPtr lpReserved2;
            public IntPtr hStdInput;
            public IntPtr hStdOutput;
            public IntPtr hStdError;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct PROCESS_INFORMATION
        {
            public IntPtr hProcess;
            public IntPtr hThread;
            public Int32 dwProcessID;
            public Int32 dwThreadID;
        }

        [Flags]
        public enum LogonType
        {
            LOGON32_LOGON_INTERACTIVE = 2,
            LOGON32_LOGON_NETWORK = 3,
            LOGON32_LOGON_BATCH = 4,
            LOGON32_LOGON_SERVICE = 5,
            LOGON32_LOGON_UNLOCK = 7,
            LOGON32_LOGON_NETWORK_CLEARTEXT = 8,
            LOGON32_LOGON_NEW_CREDENTIALS = 9
        }

        [Flags]
        public enum LogonProvider
        {
            LOGON32_PROVIDER_DEFAULT = 0,
            LOGON32_PROVIDER_WINNT35,
            LOGON32_PROVIDER_WINNT40,
            LOGON32_PROVIDER_WINNT50
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct SECURITY_ATTRIBUTES
        {
            public Int32 Length;
            public IntPtr lpSecurityDescriptor;
            public bool bInheritHandle;
        }

        public enum SECURITY_IMPERSONATION_LEVEL
        {
            SecurityAnonymous,
            SecurityIdentification,
            SecurityImpersonation,
            SecurityDelegation
        }

        public enum TOKEN_TYPE
        {
            TokenPrimary = 1,
            TokenImpersonation
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        internal struct TokPriv1Luid
        {
            public int Count;
            public long Luid;
            public int Attr;
        }

        public const int GENERIC_ALL_ACCESS = 0x10000000;
        public const int CREATE_NO_WINDOW = 0x08000000;
        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
        internal const string SE_INCRASE_QUOTA = "SeIncreaseQuotaPrivilege";

#if CORECLR
        [DllImport("api-ms-win-core-handle-l1-1-0.dll",
#else
        [DllImport("kernel32.dll",
#endif
              EntryPoint = "CloseHandle", SetLastError = true,
              CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        public static extern bool CloseHandle(IntPtr handle);

#if CORECLR
        [DllImport("api-ms-win-core-processthreads-l1-1-2.dll",
#else
        [DllImport("advapi32.dll",
#endif
              EntryPoint = "CreateProcessAsUser", SetLastError = true,
              CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        public static extern bool CreateProcessAsUser(
            IntPtr hToken,
            string lpApplicationName,
            string lpCommandLine,
            ref SECURITY_ATTRIBUTES lpProcessAttributes,
            ref SECURITY_ATTRIBUTES lpThreadAttributes,
            bool bInheritHandle,
            Int32 dwCreationFlags,
            IntPtr lpEnvrionment,
            string lpCurrentDirectory,
            ref STARTUPINFO lpStartupInfo,
            ref PROCESS_INFORMATION lpProcessInformation
            );

#if CORECLR
        [DllImport("api-ms-win-security-base-l1-1-0.dll", EntryPoint = "DuplicateTokenEx")]
#else
        [DllImport("advapi32.dll", EntryPoint = "DuplicateTokenEx")]
#endif
        public static extern bool DuplicateTokenEx(
            IntPtr hExistingToken,
            Int32 dwDesiredAccess,
            ref SECURITY_ATTRIBUTES lpThreadAttributes,
            Int32 ImpersonationLevel,
            Int32 dwTokenType,
            ref IntPtr phNewToken
            );

#if CORECLR
        [DllImport("api-ms-win-security-logon-l1-1-1.dll", CharSet = CharSet.Unicode, SetLastError = true)]
#else
        [DllImport("advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
#endif
        public static extern Boolean LogonUser(
            String lpszUserName,
            String lpszDomain,
            IntPtr lpszPassword,
            LogonType dwLogonType,
            LogonProvider dwLogonProvider,
            out IntPtr phToken
            );

#if CORECLR
        [DllImport("api-ms-win-security-base-l1-1-0.dll", ExactSpelling = true, SetLastError = true)]
#else
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
#endif
        internal static extern bool AdjustTokenPrivileges(
            IntPtr htok,
            bool disall,
            ref TokPriv1Luid newst,
            int len,
            IntPtr prev,
            IntPtr relen
            );

#if CORECLR
        [DllImport("api-ms-win-downlevel-kernel32-l1-1-0.dll", ExactSpelling = true)]
#else
        [DllImport("kernel32.dll", ExactSpelling = true)]
#endif
        internal static extern IntPtr GetCurrentProcess();

#if CORECLR
        [DllImport("api-ms-win-downlevel-advapi32-l1-1-1.dll", ExactSpelling = true, SetLastError = true)]
#else
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
#endif
        internal static extern bool OpenProcessToken(
            IntPtr h,
            int acc,
            ref IntPtr phtok
            );

#if CORECLR
        [DllImport("api-ms-win-downlevel-kernel32-l1-1-0.dll", ExactSpelling = true)]
#else
        [DllImport("kernel32.dll", ExactSpelling = true)]
#endif
        internal static extern int WaitForSingleObject(
            IntPtr h, 
            int milliseconds
            );

#if CORECLR
        [DllImport("api-ms-win-downlevel-kernel32-l1-1-0.dll", ExactSpelling = true)]
#else
        [DllImport("kernel32.dll", ExactSpelling = true)]
#endif
        internal static extern bool GetExitCodeProcess(
            IntPtr h, 
            out int exitcode
            );

#if CORECLR
        [DllImport("api-ms-win-downlevel-advapi32-l4-1-0.dll", SetLastError = true)]
#else
        [DllImport("advapi32.dll", SetLastError = true)]
#endif
        internal static extern bool LookupPrivilegeValue(
            string host,
            string name,
            ref long pluid
            );

        internal static void ThrowException(
            string message
            )
        {
#if CORECLR
            throw new Exception(message);
#else
            throw new Win32Exception(message);
#endif
        }

        public static void CreateProcessAsUser(string strCommand, string strDomain, string strName, SecureString secureStringPassword, bool waitForExit, ref int ExitCode)
        {
            var hToken = IntPtr.Zero;
            var hDupedToken = IntPtr.Zero;
            TokPriv1Luid tp;
            var pi = new PROCESS_INFORMATION();
            var sa = new SECURITY_ATTRIBUTES();
            sa.Length = Marshal.SizeOf(sa);
            Boolean bResult = false;
            try
            {
                IntPtr unmanagedPassword = IntPtr.Zero;
                try
                {
#if CORECLR
                    unmanagedPassword = SecureStringMarshal.SecureStringToCoTaskMemUnicode(secureStringPassword);
#else
                    unmanagedPassword = Marshal.SecureStringToGlobalAllocUnicode(secureStringPassword);
#endif
                    bResult = LogonUser(
                        strName,
                        strDomain,
                        unmanagedPassword,
                        LogonType.LOGON32_LOGON_NETWORK_CLEARTEXT,
                        LogonProvider.LOGON32_PROVIDER_DEFAULT,
                        out hToken
                        );
                }
                finally
                {
                    Marshal.ZeroFreeGlobalAllocUnicode(unmanagedPassword);
                }
                if (!bResult)
                {
                    ThrowException(@"$($LocalizedData.UserCouldNotBeLoggedError)" + Marshal.GetLastWin32Error().ToString());
                }
                IntPtr hproc = GetCurrentProcess();
                IntPtr htok = IntPtr.Zero;
                bResult = OpenProcessToken(
                        hproc,
                        TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,
                        ref htok
                    );
                if (!bResult)
                {
                    ThrowException(@"$($LocalizedData.OpenProcessTokenError)" + Marshal.GetLastWin32Error().ToString());
                }
                tp.Count = 1;
                tp.Luid = 0;
                tp.Attr = SE_PRIVILEGE_ENABLED;
                bResult = LookupPrivilegeValue(
                    null,
                    SE_INCRASE_QUOTA,
                    ref tp.Luid
                    );
                if (!bResult)
                {
                    ThrowException(@"$($LocalizedData.PrivilegeLookingUpError)" + Marshal.GetLastWin32Error().ToString());
                }
                bResult = AdjustTokenPrivileges(
                    htok,
                    false,
                    ref tp,
                    0,
                    IntPtr.Zero,
                    IntPtr.Zero
                    );
                if (!bResult)
                {
                    ThrowException(@"$($LocalizedData.TokenElevationError)" + Marshal.GetLastWin32Error().ToString());
                }

                bResult = DuplicateTokenEx(
                    hToken,
                    GENERIC_ALL_ACCESS,
                    ref sa,
                    (int)SECURITY_IMPERSONATION_LEVEL.SecurityIdentification,
                    (int)TOKEN_TYPE.TokenPrimary,
                    ref hDupedToken
                    );
                if (!bResult)
                {
                    ThrowException(@"$($LocalizedData.DuplicateTokenError)" + Marshal.GetLastWin32Error().ToString());
                }
                var si = new STARTUPINFO();
                si.cb = Marshal.SizeOf(si);
                si.lpDesktop = "";
                bResult = CreateProcessAsUser(
                    hDupedToken,
                    null,
                    strCommand,
                    ref sa,
                    ref sa,
                    false,
                    0,
                    IntPtr.Zero,
                    null,
                    ref si,
                    ref pi
                    );
                if (!bResult)
                {
                    ThrowException(@"$($LocalizedData.CouldNotCreateProcessError)" + Marshal.GetLastWin32Error().ToString());
                }
                if (waitForExit) {
                    int status = WaitForSingleObject(pi.hProcess, -1);
                    if(status == -1)
                    {
                        ThrowException(@"$($LocalizedData.WaitFailedError)" + Marshal.GetLastWin32Error().ToString());
                    }

                    bResult = GetExitCodeProcess(pi.hProcess, out ExitCode);
                    if(!bResult)
                    {
                        ThrowException(@"$($LocalizedData.RetriveStatusError)" + Marshal.GetLastWin32Error().ToString());
                    }
                }
            }
            finally
            {
                if (pi.hThread != IntPtr.Zero)
                {
                    CloseHandle(pi.hThread);
                }
                if (pi.hProcess != IntPtr.Zero)
                {
                    CloseHandle(pi.hProcess);
                }
                if (hDupedToken != IntPtr.Zero)
                {
                    CloseHandle(hDupedToken);
                }
            }
        }
    }
}

"@

    if(IsNanoServer)
    {
        $ProgramSource = "#define CORECLR`n" + $ProgramSource
        Add-Type -TypeDefinition $ProgramSource -ReferencedAssemblies System.Security.SecureString.dll
    }
    else
    {
        Add-Type -TypeDefinition $ProgramSource -ReferencedAssemblies "System.ServiceProcess"
    }
}

Export-ModuleMember -Function Get-DomainAndUserName,Import-DscNativeMethods,IsNanoServer