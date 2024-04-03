#
# Windows Cab Package Provider - Microsoft 2016
# This resource manages the packages for a live image.
#

data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData @'
SourcePathDoesNotExist=Source does not exist: {0}
ConfigurationStarted=The configuration of WindowsPackageCab resource is starting
ConfigurationFinished=The configuration of WindowsPackageCab resource has completed
FailedToAddPackage=Failed to add package from {0}
FailedToRemovePackage=Failed to remove package {0}
SourcePathInvalid=Source path is null or empty
'@
}

Import-LocalizedData LocalizedData -FileName WindowsPackageCab.Strings.psd1

[DscResource()]
class WindowsPackageCab {
    
    # Property: Holds the product name of the package.
    [DscProperty(Key)]
    [String] $Name;

    # Property: Makes sure a package is installed/not installed on the image.
    [DscProperty(Mandatory)]
    [ValidateSet("Absent","Present")]
    [String] $Ensure;
    
    # Property: Points to the location of a .cab file.
    [DscProperty(Mandatory)]
    [String] $SourcePath;
    
    # Property: Points the desired location for a log file
    [DscProperty()]
    [String] $LogPath;

    WindowsPackageCab()
    {
        Import-DscNativeDISMMethods
    }
    
    [void] Set()
    {
        Write-Verbose $script:LocalizedData.ConfigurationStarted

        if ([string]::IsNullOrEmpty($this.SourcePath))
        {
            Throw-TerminatingError ($script:LocalizedData.SourcePathInvalid)
        }

        $SourcePathExists = Test-Path -Path $this.SourcePath
        if (-not $SourcePathExists)
        {
            Throw-TerminatingError ($script:LocalizedData.SourcePathDoesNotExist -f $this.SourcePath)
        }
        
        if ($this.Ensure -match 'Present')
        {
            Add-CabPackage -PackagePath $this.SourcePath
        }
        else
        {
            Remove-CabPackage -PackagePath $this.SourcePath
        }

        Write-Verbose $script:LocalizedData.ConfigurationFinished
    }

    [bool] Test()
    {
        $details = Get-DISMDetailedInstalledPackageInfo -PackageName $this.Name

        $isPackagePresent = Test-PackagePresence -packageInfoDetails $details

        if ($this.Ensure -match 'Present')
        {
            return $isPackagePresent
        }
        else
        {
            return -not $isPackagePresent
        }
    }

    [WindowsPackageCab] Get()
    {
        $details = Get-DISMDetailedInstalledPackageInfo -PackageName $this.Name

        if ($details -eq $null)
        {
            $this.Ensure = 'Absent'
        }
        else
        {
            $this.Ensure = 'Present'
        }

        $this.SourcePath = $null
        $this.LogPath = $null

        return $this
    }
}

Function Trace-Message
{
    param
    (
        [string] $Message
    )

    Write-Verbose $Message

    if ($this.LogPath)
    {
        New-Item -Path $this.LogPath -ErrorAction SilentlyContinue
        Add-Content -Path $this.LogPath -Value $message
    }
}

Function Throw-TerminatingError
{
    param
    (
        [string] $Message,
        [System.Management.Automation.ErrorRecord] $ErrorRecord,
        [string] $ExceptionType
    )
    
    $exception = new-object "System.InvalidOperationException" $Message,$ErrorRecord.Exception
    $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception,"MachineStateIncorrect","InvalidOperation",$null
    throw $errorRecord
}

Function Test-PackagePresence
{
    Param 
    (
        [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.DismDetailedPackageInfo] $packageInfoDetails
    )

    if (-not $packageInfoDetails)
    {
        return $false;
    }

    if ($packageInfoDetails.PackageState -eq [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.DismPackageFeatureState]::DismStateInstalled -or
        $packageInfoDetails.PackageState -eq [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.DismPackageFeatureState]::DismStateInstallPending)
    {
        return $true;
    }

    return $false;
}

Function Get-DISMDetailedInstalledPackageInfo
{
    Param
    (
        [string] $PackageName
    )

    try
    {
        $detailedPacketInfo = [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.Dism]::new().GetDetailedPackageInfo($PackageName, $this.LogPath)
    }
    catch
    {
        $detailedPacketInfo = $null
    }

    return $detailedPacketInfo
}

Function Get-DISMDetailedCabFileInfo
{
    Param
    (
        [string] $PackagePath
    )
    
    return [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.Dism]::new().GetDetailedCabFileInfo($PackagePath, $this.LogPath)
}

Function Add-CabPackage
{
    Param
    (
        [string] $PackagePath
    )

    try
    {
        $dismStatus = [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.Dism]::new().AddPackage($PackagePath, $this.LogPath)
        if ($dismStatus -eq [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.DismStatus]::DismStatusRebootRequired)
        {
            $global:DSCMachineStatus = 1;
        }
        Trace-Message ("-CabPackage successful. PackagePath = $PackagePath")
    }
    catch [System.Exception]
    {
        Throw-TerminatingError ($script:LocalizedData.FailedToAddPackage -f $this.SourcePath)
    }

}

Function Remove-CabPackage
{
    Param
    (
        [string] $PackagePath
    )

    try
    {
        $dismStatus = [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.Dism]::new().RemovePackage($PackagePath, $this.LogPath)
        if ($dismStatus -eq [Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.DismStatus]::DismStatusRebootRequired)
        {
            $global:DSCMachineStatus = 1;
        }
        Trace-Message ("Remove-CabPackage successful. PackagePath = $PackagePath")
    }
    catch [System.Exception]
    {
        Throw-TerminatingError ($script:LocalizedData.FailedToRemovePackage -f $this.SourcePath)
    }
}

Function Import-DscNativeDISMMethods
{
    if (-not ([System.Management.Automation.PSTypeName]'Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab.Dism').Type)
    {
        $source = @"
using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;

#if CORECLR
    using Environment = System.Management.Automation.Environment;
#else
using Environment = System.Environment;
#endif

namespace Microsoft.PowerShell.DesiredStateConfiguration.WindowsPackageCab
{
    #region Native Handlers

    internal enum DismPackageIdentifier
    {
        DismPackageNone = 0,
        DismPackageName = 1,
        DismPackagePath = 2
    };

    internal enum DismLogLevel
    {
        DismLogErrors = 0,
        DismLogErrorsWarnings,
        DismLogErrorsWarningsInfo
    };

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    internal class SystemTime
    {
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wYear;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wMonth;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wDayOfWeek;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wDay;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wHour;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wMinute;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wSecond;
        [MarshalAs(UnmanagedType.U2)]
        public UInt16 wMillisecond;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    internal class DismPackage
    {
        [MarshalAs(UnmanagedType.LPWStr)]
        internal string PackageName;
        internal DismPackageFeatureState PackageState;
        internal DismReleaseType ReleaseType;
        internal SystemTime InstalledOn;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    internal class DismPackageDetails
    {
        [MarshalAs(UnmanagedType.LPWStr)]
        public string PackageName;
        public DismPackageFeatureState PackageState;
        public DismReleaseType ReleaseType;
        public SystemTime InstalledOn;
        public bool Applicable;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string Copyright;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string Company;
        public SystemTime CreationTime;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string DisplayName;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string Description;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string InstallClient;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string InstallPackageName;
        public SystemTime LastUpdateTime;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string ProductName;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string ProductVersion;
        public DismRestartType RestartRequired;
        public DismFullyOfflineInstallable FullyOffline;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string SupportInformation;
        public IntPtr CustomPropertyBuffer;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 CustomPropertyCount;
        public IntPtr FeatureBuffer;
        [MarshalAs(UnmanagedType.U4)]
        public UInt32 FeatureCount;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    internal class DismPackageCustomProperty
    {
        [MarshalAs(UnmanagedType.LPWStr)]
        public string Name;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string Value;
        [MarshalAs(UnmanagedType.LPWStr)]
        public string Path;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public class DismPackageFeature
    {
        [MarshalAs(UnmanagedType.LPWStr)]
        public string FeatureName;
        public DismPackageFeatureState State;
    }

    internal class DismNativeMethods
    {
        internal static string DismOnlineImage = "DISM_{53BFAE52-B167-4E2F-A258-0A37B57FF845}";

        [DllImport("DismApi.dll")]
        public static extern int DismCloseSession(uint session);

        [DllImport("DismApi.dll")]
        public static extern int DismOpenSession(
            [MarshalAs(UnmanagedType.LPWStr)] string imagePath,
            [MarshalAs(UnmanagedType.LPWStr)] string windowsDirectory,
            [MarshalAs(UnmanagedType.LPWStr)] string systemDrive,
            out uint session
            );

        [DllImport("DismApi.dll")]
        public static extern int DismInitialize(
            DismLogLevel logLevel,
            [MarshalAs(UnmanagedType.LPWStr)] string logFilePath,
            [MarshalAs(UnmanagedType.LPWStr)] string scratchDirectory
            );

        [DllImport("DismApi.dll")]
        public static extern int DismShutdown();

        [DllImport("DismApi.dll")]
        public static extern int DismDelete(IntPtr dismStructure);

        [DllImport("DismApi.dll")]
        public static extern int DismGetPackages(
            uint session,
            out IntPtr packageBufPtr,
            out uint packageCount
            );

        [DllImport("DismApi.dll")]
        public static extern int DismGetPackageInfo(
            uint session,
            [MarshalAs(UnmanagedType.LPWStr)] string identifier,
            DismPackageIdentifier packageIdentifier,
            out IntPtr packageInfo
            );

        [DllImport("DismApi.dll")]
        public static extern int DismAddPackage(
            uint session,
            [MarshalAs(UnmanagedType.LPWStr)] string packagePath,
            [MarshalAs(UnmanagedType.Bool)] bool ignoreCheck,
            [MarshalAs(UnmanagedType.Bool)] bool preventPending,
            IntPtr cancelEvent,
            DismProgressCallback progress,
            IntPtr userData
            );

        [DllImport("DismApi.dll")]
        public static extern int DismRemovePackage(
            uint session,
            [MarshalAs(UnmanagedType.LPWStr)] string identifier,
            DismPackageIdentifier packageIdentifier,
            IntPtr cancelEvent,
            DismProgressCallback progress,
            IntPtr userData
            );

        public delegate void DismProgressCallback(
            uint current,
            uint total,
            IntPtr userData
            );

        internal static DateTime GetDateTimeFromSystemTime(SystemTime time)
        {
            try
            {
                return new DateTime(time.wYear, time.wMonth, time.wDay,
                    time.wHour, time.wMinute, time.wSecond, DateTimeKind.Local);
            }
            catch (ArgumentOutOfRangeException)
            {
                return new DateTime(0, DateTimeKind.Local);
            }
        }
    }

    #endregion Native Handlers

    #region Helper Classes

    internal class DismHandler : IDisposable
    {
        #region Private Members

        private readonly string _logPath;
        private uint _sessionToken;
        private readonly DismLogLevel _logLevel;
        private bool _sessionOpened;

        #endregion Private Members

        #region Constructors
        internal DismHandler(string logPath, DismLogLevel logLevel)
        {
            _logPath = logPath;
            _logLevel = logLevel;
        }

        internal DismHandler() : this(string.Format("{0}\\dism.log", Path.GetPathRoot(Environment.GetFolderPath(Environment.SpecialFolder.System))), DismLogLevel.DismLogErrorsWarnings) { }

        internal DismHandler(string logPath)
        {
            if (!String.IsNullOrEmpty(logPath))
                _logPath = logPath;
            else
                _logPath = string.Format("{0}\\dism.log", Path.GetPathRoot(Environment.GetFolderPath(Environment.SpecialFolder.System)));

            _logLevel = DismLogLevel.DismLogErrorsWarnings;
        }
        #endregion Constructors

        #region Private Methods
        private const int CbsInvalidPackage = unchecked((int)0x800f0805);
        private const int FileNotFound = unchecked((int)0x80070002);
        private const int CorruptedFile = unchecked((int)0x80070570);
        private const int InvalidArgument = unchecked((int)0x80070057);
        private const int SessionReloadRequired = 0x1;
        private const int MachineRebootRequired = 0xbc2;

        private static void ValidateResult(int hr)
        {
            if (hr == 0) return;
            if (IsSpecialErrorCode(hr)) return;

            switch (hr)
            {
                case CbsInvalidPackage: // 0x800f0805
                    {
                        // 0x800f0805 -2146498555 : CBS_E_INVALID_PACKAGE the update package was not a valid CSI update
                        // when package is queried by name and is not installed
                        throw new DismInvalidPackageException(string.Format("Dism error code = {0}", hr));
                    }
                case FileNotFound: // 0x80070002
                    {
                        // 0x80070002 : -2147024894 E_FILE_NOT_FOUND The system cannot find the file specified.
                        // when package is queried by path and the file does not exist
                        throw new FileNotFoundException();
                    }
                case CorruptedFile: // 0x80070570
                    {
                        // 0x80070570 : 1392 ERROR_FILE_CORRUPT The file or directory is corrupted and unreadable
                        // when package file iscorrupted and unreadable
                        throw new DismInvalidPackageException(string.Format("Dism error code = {0}", hr));
                    }
                case InvalidArgument: // 0x80070057
                    {
                        // 0x80070057 -2147024809 : E_INVALIDARG One or more arguments are invalid 
                        // when package is queried by name and is not installed
                        throw new DismInvalidPackageException(string.Format("Dism error code = {0}", hr));
                    }
                default:
                    {
                        throw new DismException(string.Format("Dism error code = {0}", hr));
                    }
            }
        }

        /// <summary>
        /// Special Error codes are not failures. They are positive values and often indicate an expected followup operation.
        /// </summary>
        /// <param name="errorCode"></param>
        /// <returns></returns>
        private static bool IsSpecialErrorCode(int errorCode)
        {
            switch (errorCode)
            {
                case SessionReloadRequired:
                    {
                        return true;
                    }
                case MachineRebootRequired:
                    {
                        return true;
                    }
            }

            return false;
        }

        private static DismStatus GetStatusFromErrorCode(int errorCode)
        {
            switch (errorCode)
            {
                case SessionReloadRequired:
                    {
                        return DismStatus.DismStatusSuccess;
                    }
                case MachineRebootRequired:
                    {
                        return DismStatus.DismStatusRebootRequired;
                    }
            }

            return DismStatus.DismStatusSuccess;
        }

        private void OpenSession()
        {
            if (_sessionOpened) return;

            var hr = DismNativeMethods.DismInitialize(_logLevel, _logPath, null);
            ValidateResult(hr);

            hr = DismNativeMethods.DismOpenSession(DismNativeMethods.DismOnlineImage, null, null, out _sessionToken);
            ValidateResult(hr);

            _sessionOpened = true;
        }

        private void CloseSession()
        {
            if (!_sessionOpened) return;

            var hr = DismNativeMethods.DismCloseSession(_sessionToken);
            ValidateResult(hr);

            DismNativeMethods.DismShutdown();

            _sessionOpened = false;
        }

        private void DeleteDismBuffer(IntPtr buffer)
        {
            if (buffer != IntPtr.Zero) DismNativeMethods.DismDelete(buffer);
            buffer = IntPtr.Zero;
        }

        #endregion Private Methods

        #region Dispose

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected void Dispose(bool isDisposing)
        {
            CloseSession();
        }

        #endregion Dispose

        #region Core Logic

        internal List<DismPackageInfo> GetInstalledPackages()
        {
            OpenSession();

            List<DismPackageInfo> packages = new List<DismPackageInfo>();

            IntPtr pPackagesBuffer;
            uint numOfPackages = 0;

            var hr = DismNativeMethods.DismGetPackages(_sessionToken, out pPackagesBuffer, out numOfPackages);
            ValidateResult(hr);

            try
            {
                var pBuffer = pPackagesBuffer;
                var originalPackageSize = Marshal.SizeOf(typeof(DismPackage));
                for (uint i = 0; i < numOfPackages; i++)
                {
                    try
                    {
                        var dismPackage = (DismPackage)Marshal.PtrToStructure(pBuffer, typeof(DismPackage));
                        if (dismPackage != null)
                        {
                            packages.Add(new DismPackageInfo(dismPackage));
                        }
                    }
                    finally
                    {
                        pBuffer = new IntPtr(pBuffer.ToInt64() + originalPackageSize);
                    }
                }
            }
            finally
            {
                if (pPackagesBuffer != IntPtr.Zero)
                {
                    DismNativeMethods.DismDelete(pPackagesBuffer);
                }
            }
            return packages;
        }

        internal DismDetailedPackageInfo GetPackageInfo(string identifier, DismPackageIdentifier packageIdentifier)
        {
            OpenSession();

            IntPtr packageInfo;

            var hr = 0;

            hr = DismNativeMethods.DismGetPackageInfo(_sessionToken, identifier, packageIdentifier, out packageInfo);
            ValidateResult(hr);

            try
            {
                var details = (DismPackageDetails)Marshal.PtrToStructure(packageInfo, typeof(DismPackageDetails));
                return extractDismDetailedPackageInfo(details);
            }
            finally
            {
                DeleteDismBuffer(packageInfo);
            }
        }

        internal DismDetailedPackageInfo extractDismDetailedPackageInfo(DismPackageDetails details)
        {
            string PackageName = details.PackageName;
            DismPackageFeatureState PackageState = details.PackageState;
            DismReleaseType ReleaseType = details.ReleaseType;
            DateTime InstalledOn = DismNativeMethods.GetDateTimeFromSystemTime(details.InstalledOn);
            bool Applicable = details.Applicable;
            string Copyright = details.Copyright;
            string Company = details.Company;
            DateTime CreationTime = DismNativeMethods.GetDateTimeFromSystemTime(details.CreationTime);
            string DisplayName = details.DisplayName;
            string Description = details.Description;
            string InstallClient = details.InstallClient;
            string InstallPackageName = details.InstallPackageName;
            DateTime LastUpdateTime = DismNativeMethods.GetDateTimeFromSystemTime(details.LastUpdateTime);
            string ProductName = details.ProductName;
            string ProductVersion = details.ProductVersion;
            DismRestartType RestartRequired = details.RestartRequired;
            DismFullyOfflineInstallable FullyOffline = details.FullyOffline;
            string SupportInformation = details.SupportInformation;

            List<DismCustomProperty> CustomProperty = new List<DismCustomProperty>();

            IntPtr currentCustomPropertyPtr = details.CustomPropertyBuffer;
            for (int i = 0; i < details.CustomPropertyCount; ++i)
            {
                DismCustomProperty customPropertyInstance = new DismCustomProperty(currentCustomPropertyPtr);
                CustomProperty.Add(customPropertyInstance);
                currentCustomPropertyPtr = new IntPtr(currentCustomPropertyPtr.ToInt64() + Marshal.SizeOf(typeof(DismCustomProperty)));
            }

            List<DismFeature> Feature = new List<DismFeature>();
            IntPtr currentFeaturePtr = details.FeatureBuffer;
            for (int i = 0; i < details.FeatureCount; ++i)
            {
                DismFeature basicFeature = new DismFeature(currentFeaturePtr);
                Feature.Add(basicFeature);
                currentFeaturePtr = new IntPtr(currentFeaturePtr.ToInt64() + Marshal.SizeOf(typeof(DismPackageFeature)));
            }

            return new DismDetailedPackageInfo(
                PackageName,
                PackageState,
                ReleaseType,
                InstalledOn,
                Applicable,
                Copyright,
                Company,
                CreationTime,
                DisplayName,
                Description,
                InstallClient,
                InstallPackageName,
                LastUpdateTime,
                ProductName,
                ProductVersion,
                RestartRequired,
                FullyOffline,
                SupportInformation,
                CustomProperty,
                Feature
                );
        }

        internal DismStatus AddPackage(string packagePath)
        {
            OpenSession();

            // Add the package
            var hr = DismNativeMethods.DismAddPackage(_sessionToken, packagePath, false, false, IntPtr.Zero, null, IntPtr.Zero);
            ValidateResult(hr);
            return GetStatusFromErrorCode(hr);
        }

        internal DismStatus RemoveInstalledPackage(string packagePath)
        {
            OpenSession();

            // Remove the package
            var hr = DismNativeMethods.DismRemovePackage(_sessionToken, packagePath, DismPackageIdentifier.DismPackagePath, IntPtr.Zero, null, IntPtr.Zero);
            ValidateResult(hr);
            return GetStatusFromErrorCode(hr);
        }

        #endregion Core Logic
    }

    #endregion Helper Classes

    #region Core Logic

    public class DismException : Exception
    {
        public DismException(string message) : base(message)
        {
        }
    }

    public class DismInvalidPackageException : Exception
    {
        public DismInvalidPackageException(string message)
        {
        }
    }

    public class DismSessionException : Exception
    {
        public DismSessionException(string message)
        {
        }
    }

    /// <summary>
    /// Core Dism class is used directly by the resource and provides a managed interface
    /// </summary>
    public class Dism
    {
        /// <summary>
        /// Get a list of installed packages
        /// </summary>
        /// <returns>list containining installed packages</returns>
        public List<DismPackageInfo> GetInstalledPackages(string logPath = null)
        {
            using (var dismHandler = new DismHandler(logPath))
            {
                return dismHandler.GetInstalledPackages();
            }
        }

        /// <summary>
        /// Get detailed package info based on unique package name
        /// </summary>
        /// <param name="packageName"></param>
        /// <returns></returns>
        public DismDetailedPackageInfo GetDetailedPackageInfo(string packageName, string logPath = null)
        {
            using (var dismHandler = new DismHandler(logPath))
            {
                return dismHandler.GetPackageInfo(packageName, DismPackageIdentifier.DismPackageName);
            }
        }

        /// <summary>
        /// Get detailed package info based on path to a .cab file
        /// </summary>
        public DismDetailedPackageInfo GetDetailedCabFileInfo(string packagePath, string logPath = null)
        {
            using (var dismHandler = new DismHandler(logPath))
            {
                return dismHandler.GetPackageInfo(packagePath, DismPackageIdentifier.DismPackagePath);
            }
        }

        /// <summary>
        /// Install windows package from .cab file
        /// </summary>
        /// <param name="packagePath"></param>
        /// <returns></returns>
        public DismStatus AddPackage(string packagePath, string logPath = null)
        {
            using (var dismHandler = new DismHandler(logPath))
            {
                return dismHandler.AddPackage(packagePath);
            }
        }

        /// <summary>
        /// Remove the installed windows package pointed to by the .cab file
        /// </summary>
        /// <param name="packagePath"></param>
        /// <returns></returns>
        public DismStatus RemovePackage(string packagePath, string logPath = null)
        {
            using (var dismHandler = new DismHandler(logPath))
            {
                return dismHandler.RemoveInstalledPackage(packagePath);
            }
        }

        private static readonly object SyncObject = new object();
        private static Dism _instance;
        public static Dism Instance
        {
            get
            {
                if (_instance == null)
                {
                    lock (SyncObject)
                    {
                        if (_instance == null)
                        {
                            _instance = new Dism();
                        }
                    }
                }

                return _instance;
            }
        }
    }

    public class DismDetailedPackageInfo
    {
        public string PackageName;
        public DismPackageFeatureState PackageState;
        public DismReleaseType ReleaseType;
        public DateTime InstalledOn;
        public bool Applicable;
        public string Copyright;
        public string Company;
        public DateTime CreationTime;
        public string DisplayName;
        public string Description;
        public string InstallClient;
        public string InstallPackageName;
        public DateTime LastUpdateTime;
        public string ProductName;
        public string ProductVersion;
        public DismRestartType RestartRequired;
        public DismFullyOfflineInstallable FullyOffline;
        public string SupportInformation;
        public List<DismCustomProperty> CustomProperty;
        public List<DismFeature> Feature;

        internal DismDetailedPackageInfo(
                string aPackageName,
                DismPackageFeatureState aPackageState,
                DismReleaseType aReleaseType,
                DateTime aInstalledOn,
                bool aApplicable,
                string aCopyright,
                string aCompany,
                DateTime aCreationTime,
                string aDisplayName,
                string aDescription,
                string aInstallClient,
                string aInstallPackageName,
                DateTime aLastUpdateTime,
                string aProductName,
                string aProductVersion,
                DismRestartType aRestartRequired,
                DismFullyOfflineInstallable aFullyOffline,
                string aSupportInformation,
                List<DismCustomProperty> aCustomProperty,
                List<DismFeature> aFeature
            )
        {
            PackageName = aPackageName;
            PackageState = aPackageState;
            ReleaseType = aReleaseType;
            InstalledOn = aInstalledOn;
            Applicable = aApplicable;
            Copyright = aCopyright;
            Company = aCompany;
            CreationTime = aCreationTime;
            DisplayName = aDisplayName;
            Description = aDescription;
            InstallClient = aInstallClient;
            InstallPackageName = aInstallPackageName;
            LastUpdateTime = aLastUpdateTime;
            ProductName = aProductName;
            ProductVersion = aProductVersion;
            RestartRequired = aRestartRequired;
            FullyOffline = aFullyOffline;
            SupportInformation = aSupportInformation;
            CustomProperty = aCustomProperty;
            Feature = aFeature;
        }
    }

    public class DismCustomProperty
    {
        public string Name;
        public string Value;
        public string Path;

        public DismCustomProperty(
            string Name,
            string Value,
            string Path
            )
        {
            this.Name = Name;
            this.Value = Value;
            this.Path = Path;
        }

        public DismCustomProperty(IntPtr DismPackageCustomPropertyPtr)
        {
            DismPackageCustomProperty customProperty = (DismPackageCustomProperty)Marshal.PtrToStructure(DismPackageCustomPropertyPtr, typeof(DismPackageCustomProperty));

            Name = customProperty.Name;
            Value = customProperty.Value;
            Path = customProperty.Path;
        }
    }

    public class DismFeature
    {
        public string FeatureName;
        public DismFeatureState FeatureState;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        public DismFeature(IntPtr FeatureBuf)
        {
            DismPackageFeature Feature = (DismPackageFeature)Marshal.PtrToStructure(FeatureBuf, typeof(DismPackageFeature));

            SetFeatureState(Feature.State);
            FeatureName = Feature.FeatureName;
        }

        public void SetFeatureState(DismPackageFeatureState state)
        {
            switch (state)
            {
                case DismPackageFeatureState.DismStateNotPresent:
                case DismPackageFeatureState.DismStateStaged:
                    FeatureState = DismFeatureState.Disabled;
                    break;
                case DismPackageFeatureState.DismStateUninstallPending:
                    FeatureState = DismFeatureState.DisablePending;
                    break;
                case DismPackageFeatureState.DismStateResolved:
                    FeatureState = DismFeatureState.DisabledWithPayloadRemoved;
                    break;
                case DismPackageFeatureState.DismStateInstalled:
                    FeatureState = DismFeatureState.Enabled;
                    break;
                case DismPackageFeatureState.DismStateInstallPending:
                    FeatureState = DismFeatureState.EnablePending;
                    break;
                case DismPackageFeatureState.DismStateSuperseded:
                    FeatureState = DismFeatureState.Superseded;
                    break;
                case DismPackageFeatureState.DismStatePartiallyInstalled:
                    FeatureState = DismFeatureState.PartiallyInstalled;
                    break;
                default:
                    FeatureState = DismFeatureState.Disabled;
                    break;
            }
        }
    }

    public enum DismPackageFeatureState
    {
        DismStateNotPresent = 0,
        DismStateUninstallPending,
        DismStateStaged,
        DismStateResolved,
        DismStateRemoved = DismStateResolved,
        DismStateInstalled,
        DismStateInstallPending,
        DismStateSuperseded,
        DismStatePartiallyInstalled
    };

    public enum DismFeatureState
    {
        Disabled = 0,
        DisablePending,
        Enabled,
        EnablePending,
        Superseded,
        PartiallyInstalled,
        DisabledWithPayloadRemoved
    }

    public enum DismReleaseType
    {
        DismReleaseTypeCriticalUpdate = 0,
        DismReleaseTypeDriver,
        DismReleaseTypeFeaturePack,
        DismReleaseTypeHotfix,
        DismReleaseTypeSecurityUpdate,
        DismReleaseTypeSoftwareUpdate,
        DismReleaseTypeUpdate,
        DismReleaseTypeUpdateRollup,
        DismReleaseTypeLanguagePack,
        DismReleaseTypeFoundation,
        DismReleaseTypeServicePack,
        DismReleaseTypeProduct,
        DismReleaseTypeLocalPack,
        DismReleaseTypeOther
    };

    public class DismPackageInfo
    {
        public string Name;
        public DismPackageFeatureState PackageState;
        public DismReleaseType ReleaseType;
        public DateTime InstalledOn;

        internal DismPackageInfo(DismPackage package)
        {
            Name = package.PackageName;
            PackageState = package.PackageState;
            ReleaseType = package.ReleaseType;
            InstalledOn = DismNativeMethods.GetDateTimeFromSystemTime(package.InstalledOn);
        }
    }

    public enum DismRestartType
    {
        DismRestartNo = 0,
        DismRestartPossible = 1,
        DismRestartRequired = 2
    }

    public enum DismFullyOfflineInstallable
    {
        DismFullyOfflineInstallable = 0,
        DismFullyOfflineNotInstallable = 1,
        DismFullyOfflineInstallableUndetermined = 2
    }

    public enum DismStatus
    {
        DismStatusSuccess = 0,
        DismStatusRebootRequired = 1,
        DismStatusFailed = 2
    };

    #endregion Core logic

}


"@

        Add-Type -TypeDefinition $source
    }
}

Export-ModuleMember -Function ''