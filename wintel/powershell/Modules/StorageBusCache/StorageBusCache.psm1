$DiskControls = @"
using System;
using System.Collections;
using System.Runtime.InteropServices;
using System.ComponentModel;

namespace Microsoft.SFS.StorageBusCache
{
    public enum StorageBusType
    {
        Unknown = 0,
        Scsi = 1,
        Atapi = 2,
        Ata = 3,
        IEEE1394 = 4,
        Ssa = 5,
        Fibre = 6,
        Usb = 7,
        RAID = 8,
        iScsi = 9,
        Sas = 10,
        Sata = 11,
        Sd = 12,
        Mmc = 13,
        Virtual = 14,
        FileBackedVirtual = 15,
        Spaces = 16,
        Nvme = 17,
        SCM = 18,
        Ufs = 19,
        Max = 20
    }

    namespace ClusBFlt
    {
        public enum DeviceType
        {
            Disk = 0,
            Enclosure = 1,
            SSU = 2
        }

        [Flags]
        public enum CacheStoreBindingAttribute
        {
            Default = 0x00000000,
            Enabled = 0x00000001,
            Disable_Read_Cache = 0x00000002,
            Disable_Read_Ahead_Cache = 0x00000004,
            Disable_Write_Cache = 0x00000008
        }

        public enum PathType
        {
            Read_Write = 0,
            Read_Only = 1,
            Engaged = 2,
            Maintenance = 3
        }

        [Flags]
        public enum PathInfoAttribute
        {
            Default = 0x00000000,
            Virtual = 0x00000001,
            Orphan = 0x00000002,
            Hybrid = 0x00000004,
            Solid = 0x00000008,
            Incomplete = 0x00000010,
            Fairness_Layer = 0x00000020,
            Missing_Layer = 0x00000040,
            Hidden = 0x00000080,
            Resilient = 0x00000100,
            Paused = 0x00000200,
            Block_RW = 0x00000400,
            Attention = 0x00000800,
            Has_Cache_Partition = 0x00001000,
            Fairness_Enabled = 0x00002000,
            Partition = 0x00004000,
            Block_Write = 0x00008000,
            All = 0x0000FFFF
        }

        [Flags]
        public enum DiskAttribute
        {
            Default = 0x00,
            Enabled = 0x01,
            Disabled = 0x02,
            Maintenance = 0x04,
            No_Virtual_Enclosure = 0x08,
            Block_ReadWrite = 0x10,
            Block_Write = 0x20,
            All = 0xFF
        }

        [Flags]
        public enum SystemFlags
        {
            Default_System                   = 0x0000,
            Azure_System                     = 0x0001,
            Dont_Set_FastFail                = 0x0010,
            Allow_Other_Partitions           = 0x0020,
            Claim_Sbl_Cache_HDD_Guid_Disk    = 0x0040,
            Claim_Sbl_Cache_SSD_Guid_Part    = 0x0080,
            Dont_Claim_SSD                   = 0x0100,
            Create_Bus_PDO                   = 0x0200,
            Disable_Cache_On_Error           = 0x0400
        }
    }

    public class StorageBusDisk
    {
        public string Guid { get; set; }
        public uint Number { get; set; }
        public bool IsClaimed { get; set; }
        public bool IsCache { get; set; }
        public StorageBusType BusType { get; set; }
    }

    public class StorageBusBinding
    {
        public string Guid { get; set; }
        public uint Number { get; set; }
        public bool IsCache { get; set; }
        public bool IsCacheSuspended { get; set; }
        public UInt64 DirtyByteCount { get; set; }
    }

    public static class DeviceMgmt
    {
        #region PInvoke structs

        [StructLayout(LayoutKind.Sequential)]
        public struct CBFLT_IS_SUPPORTED_DISK_IN
        {
            public IntPtr Handle;
            public UInt32 BusTypesOverride;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct CBFLT_SET_PROFILE_IN
        {
            public UInt32 SystemFlags;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct STORAGE_DEVICE_NUMBER
        {
            public UInt32 DeviceType;
            public UInt32 DeviceNumber;
            public UInt32 PartitionNumber;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct STORAGE_DEVICE_NUMBER_EX
        {
            public UInt32 Version;
            public UInt32 Size;
            public UInt32 Flags;
            public UInt32 DeviceType;
            public UInt32 DeviceNumber;
            public Guid DeviceGuid;
            public UInt32 PartitionNumber;
        }

        public enum PARTITION_STYLE : int
        {
            PARTITION_STYLE_MBR = 0,
            PARTITION_STYLE_GPT = 1,
            PARTITION_STYLE_RAW = 2
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct DRIVE_LAYOUT_INFORMATION_MBR
        {
            public UInt32 DiskSignature;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct DRIVE_LAYOUT_INFORMATION_GPT
        {
            public Guid DiskId;
            public UInt64 StartingUsableOffset;
            public UInt64 UsableLength;
            public UInt32 MaxPartitionCount;
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct PARTITION_INFORMATION_MBR
        {
            [FieldOffset(0)]
            public Byte PartitionType;
            [FieldOffset(1)]
            public Boolean BootIndicator;
            [FieldOffset(2)]
            public Boolean RecognizedPartition;
            [FieldOffset(4)]
            public UInt32 HiddenSectors;
        }

        [StructLayout(LayoutKind.Explicit, CharSet=CharSet.Unicode)]
        public struct PARTITION_INFORMATION_GPT
        {
            [FieldOffset(0)]
            public Guid PartitionType;
            [FieldOffset(16)]
            public Guid PartitionId;
            [FieldOffset(32)]
            public UInt64 Attributes;
            [FieldOffset(40)]
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 36)]
            public string PartitionName;
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct PARTITION_INFORMATION_EX
        {
            [FieldOffset(0)]
            public PARTITION_STYLE PartitionStyle;
            [FieldOffset(8)]
            public UInt64 StartingOffset;
            [FieldOffset(16)]
            public UInt64 PartitionLength;
            [FieldOffset(24)]
            public UInt32 PartitionNumber;
            [FieldOffset(28)]
            public Boolean RewritePartition;
            [FieldOffset(32)]
            public PARTITION_INFORMATION_MBR Mbr;
            [FieldOffset(32)]
            public PARTITION_INFORMATION_GPT Gpt;
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct DRIVE_LAYOUT_INFORMATION_EX
        {
            [FieldOffset(0)]
            public PARTITION_STYLE PartitionStyle;
            [FieldOffset(4)]
            public UInt32 PartitionCount;
            [FieldOffset(8)]
            public DRIVE_LAYOUT_INFORMATION_MBR Mbr;
            [FieldOffset(8)]
            public DRIVE_LAYOUT_INFORMATION_GPT Gpt;
            [FieldOffset(48)]
            public PARTITION_INFORMATION_EX[] PartitionEntry;
        }

        #endregion

        #region PInvoke Definitions

        //File Handle
        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr CreateFile(string lpFileName, uint dwDesiredAccess, uint dwShareMode, IntPtr lpSecurityAttributes, uint dwCreationDisposition, uint dwFlagsAndAttributes, IntPtr hTemplateFile);

        [DllImport("kernel32.dll")]
        static extern int CloseHandle(IntPtr hObject);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern bool DeviceIoControl(IntPtr hDevice, uint dwIoControlCode, IntPtr lpInBuffer, uint nInBufferSize, IntPtr lpOutBuffer,
                                            uint nOutBufferSize, ref uint lpBytesReturned, IntPtr lpOverlapped);

        #endregion

        #region constants

        // IoControlCode values for disk devices
        const uint FILE_ANY_ACCESS = 0;
        const uint FILE_READ_ACCESS = 0x0001;
        const uint FILE_WRITE_ACCESS = 0x0002;
        const uint FILE_BOTH_ACCESS = FILE_READ_ACCESS | FILE_WRITE_ACCESS;

        const uint METHOD_BUFFERED = 0;
        const uint METHOD_IN_DIRECT = 1;
        const uint METHOD_OUT_DIRECT = 2;
        const uint METHOD_NEITHER = 3;

        // createFile access
        const uint GENERIC_READ = (0x80000000);
        const uint GENERIC_WRITE = (0x40000000);
        const uint FILE_SHARE_READ = 0x00000001;
        const uint FILE_SHARE_WRITE = 0x00000002;
        const uint OPEN_EXISTING = 3;

        // file attribute values
        const uint FILE_ATTRIBUTE_NORMAL = 0x00000080;

        //errors
        const uint ERROR_CLASS_MISMATCH = 0xE0000203;
        const uint ERROR_NO_MORE_ITEMS = 259;
        const uint ERROR_INSUFFICIENT_BUFFER = 122;
        const uint ERROR_MORE_DATA = 234;

        //random consts
        const uint SpDeviceInterfaceDetailSize = 5;

        //device classes
        const int DIGCF_DEFAULT = 0x00000001;
        const int DIGCF_PRESENT = 0x00000002;
        const int DIGCF_ALLCLASSES = 0x00000004;
        const int DIGCF_PROFILE = 0x00000008;
        const int DIGCF_DEVICEINTERFACE = 0x00000010;

        //disk and hidden disk interface GUIDs
        public static Guid GUID_DEVINTERFACE_HIDDEN_DISK = new Guid(0x7fccc86c, 0x228a, 0x40ad, 0x8a, 0x58, 0xf5, 0x90, 0xaf, 0x7b, 0xfd, 0xce);
        public static Guid GUID_DEVINTERFACE_DISK = new Guid(0x53f56307, 0xb6bf, 0x11d0, 0x94, 0xf2, 0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b);
        public static Guid GUID_DEVINTERFACE_STORAGEPORT = new Guid(0x2ACCFE60, 0xC130, 0x11D2, 0xb0, 0x82, 0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b); //{2ACCFE60-C130-11D2-B082-00A0C91EFB8B}

        // SBL cache partition type GUIDs
        public static Guid PARTITION_SBL_CACHE_SSD_GUID = new Guid(0xeeff8352, 0xdd2a, 0x44db, 0xae, 0x83, 0xbe, 0xe1, 0xcf, 0x74, 0x81, 0xdc);
        public static Guid PARTITION_SBL_CACHE_SSD_RESERVED_GUID = new Guid(0xdcc0c7c1, 0x55ad, 0x4f17, 0x9d, 0x43, 0x4b, 0xc7, 0x76, 0xe0, 0x11, 0x7e);
        public static Guid PARTITION_SBL_CACHE_HDD_GUID = new Guid(0x03aaa829, 0xebfc, 0x4e7e, 0xaa, 0xc9, 0xc4, 0xd7, 0x6c, 0x63, 0xb2, 0x4b);

        //ioctl code
        public const uint IOCTL_PARTMGR_BASE = 0x00000070;
        public const uint IOCTL_CBFLT_BASE   = 0x791;
        public const uint IOCTL_STORAGE_BASE = 0x0000002d;
        public const uint FILE_DEVICE_DISK   = 0x00000007;
        public const uint IOCTL_DISK_BASE    = FILE_DEVICE_DISK;

        private static uint IOCTL_DISK_REAUCTION_DISK          = CTL_CODE(IOCTL_PARTMGR_BASE, 7, METHOD_BUFFERED, FILE_READ_ACCESS | FILE_WRITE_ACCESS);
        private static uint IOCTL_CBFLT_IS_SUPPORTED_DISK      = CTL_CODE(IOCTL_CBFLT_BASE, 0x09, METHOD_BUFFERED, FILE_READ_ACCESS);
        private static uint IOCTL_CBFLT_SET_PROFILE            = CTL_CODE(IOCTL_CBFLT_BASE, 0x1b, METHOD_BUFFERED, FILE_WRITE_ACCESS);
        private static uint IOCTL_STORAGE_GET_DEVICE_NUMBER_EX = CTL_CODE(IOCTL_STORAGE_BASE, 0x0421, METHOD_BUFFERED, FILE_ANY_ACCESS);
        private static uint IOCTL_STORAGE_GET_DEVICE_NUMBER    = CTL_CODE(IOCTL_STORAGE_BASE, 0x0420, METHOD_BUFFERED, FILE_ANY_ACCESS);
        private static uint IOCTL_DISK_GET_DRIVE_LAYOUT_EX     = CTL_CODE(IOCTL_DISK_BASE, 0x0014, METHOD_BUFFERED, FILE_ANY_ACCESS);
        private static uint IOCTL_DISK_SET_DRIVE_LAYOUT_EX     = CTL_CODE(IOCTL_DISK_BASE, 0x0015, METHOD_BUFFERED, FILE_READ_ACCESS | FILE_WRITE_ACCESS);

        // clusbflt
        const string CLUSBFLT_PR_MANAGER = "\\\\?\\GLOBALROOT\\Device\\CLUSBFLT\\PrMgr$";
        const string CLUSBFLT_BLOCK_TARGETFILE = "\\\\?\\GLOBALROOT\\Device\\CLUSBFLT\\BlockTarget$";

        public static UInt32 Standalone_Profile_Default     = 0x000101F0;
        public static UInt32 Standalone_Profile_Claim_Flash = 0x000000F0;

        public static UInt32 Standalone_Cache_Binding_Attributes = 0x00000007;

        #endregion

        #region Ioctl code

        static private uint CTL_CODE(uint DeviceType, uint Function, uint Method, uint Access)
        {
            return ((DeviceType) << 16) | ((Access) << 14) | ((Function) << 2) | (Method);
        }

        static private IntPtr OpenDevice(string devicePath)
        {
            IntPtr hDevice = IntPtr.Zero;

            hDevice = CreateFile(devicePath,
                                 GENERIC_READ | GENERIC_WRITE,
                                 FILE_SHARE_WRITE | FILE_SHARE_READ,
                                 IntPtr.Zero,
                                 OPEN_EXISTING,
                                 0,
                                 IntPtr.Zero);

            if ((int)hDevice == -1)
            {
                throw new Win32Exception("CreateFile failed, status " + Marshal.GetLastWin32Error().ToString());
            }
            if (hDevice == IntPtr.Zero)
            {
                throw new Win32Exception("Device handle to '" + devicePath + "'is NULL");
            }
            return (hDevice);
        }

        static private void CloseDevice(IntPtr hDevice)
        {
            if ((int)CloseHandle(hDevice) == -1)
            {
                throw new Win32Exception("CloseHandle() failed, status " + Marshal.GetLastWin32Error().ToString());
            }
            return;
        }

        static public bool ReauctionDevice(string devicePath)
        {
            bool boolResult = false;
            IntPtr hDevice = IntPtr.Zero;

            try
            {
                hDevice = OpenDevice(devicePath);
                uint bytesReturned = 0;

                boolResult = DeviceIoControl(hDevice,
                                                IOCTL_DISK_REAUCTION_DISK,
                                                IntPtr.Zero,
                                                0,
                                                IntPtr.Zero,
                                                0,
                                                ref bytesReturned,
                                                IntPtr.Zero);
                if (!boolResult)
                {
                    throw new Win32Exception("Device '" + devicePath + "' failed IOCTL_DISK_REAUCTION_DISK, status " + Marshal.GetLastWin32Error().ToString());
                }
            }
            catch
            {
                throw;
            }
            finally
            {
                if (hDevice != IntPtr.Zero)
                    CloseDevice(hDevice);
            }

            return boolResult;
        }

        static public StorageBusDisk GetStorageBusDisk(string devicePath)
        {
            bool boolResult = false;
            IntPtr hDevice = IntPtr.Zero;
            IntPtr outputPtr = IntPtr.Zero;

            StorageBusDisk disk = new StorageBusDisk();
            disk.Guid = Guid.Empty.ToString();
            disk.Number = 0;

            try
            {
                try
                {
                    hDevice = OpenDevice(devicePath);
                }
                catch
                {
                    return disk;
                }

                uint bytesReturned = 0;

                int outputSize = Marshal.SizeOf(typeof(STORAGE_DEVICE_NUMBER_EX));
                outputPtr = Marshal.AllocHGlobal(outputSize);

                boolResult = DeviceIoControl(hDevice,
                                             IOCTL_STORAGE_GET_DEVICE_NUMBER_EX,
                                             IntPtr.Zero,
                                             0,
                                             outputPtr,
                                             (UInt32)outputSize,
                                             ref bytesReturned,
                                             IntPtr.Zero);
                if (!boolResult)
                {
                    throw new Win32Exception("Device '" + devicePath + "' failed IOCTL_STORAGE_GET_DEVICE_NUMBER_EX, status " + Marshal.GetLastWin32Error().ToString());
                }

                STORAGE_DEVICE_NUMBER_EX output = (STORAGE_DEVICE_NUMBER_EX) Marshal.PtrToStructure(outputPtr, typeof(STORAGE_DEVICE_NUMBER_EX));
                disk.Guid = "{" + output.DeviceGuid + "}";
                disk.Number = output.DeviceNumber;
            }
            catch
            {
                throw;
            }
            finally
            {
                if (outputPtr != IntPtr.Zero)
                    Marshal.FreeHGlobal(outputPtr);

                if (hDevice != IntPtr.Zero)
                    CloseDevice(hDevice);
            }

            return disk;
        }

        static public Guid GetDeviceGuid(string devicePath)
        {
            bool boolResult = false;
            IntPtr hDevice = IntPtr.Zero;
            IntPtr outputPtr = IntPtr.Zero;
            Guid deviceGuid = new Guid();

            try
            {
                try
                {
                    hDevice = OpenDevice(devicePath);
                }
                catch
                {
                    return deviceGuid;
                }

                uint bytesReturned = 0;

                int outputSize = Marshal.SizeOf(typeof(STORAGE_DEVICE_NUMBER_EX));
                outputPtr = Marshal.AllocHGlobal(outputSize);

                boolResult = DeviceIoControl(hDevice,
                                             IOCTL_STORAGE_GET_DEVICE_NUMBER_EX,
                                             IntPtr.Zero,
                                             0,
                                             outputPtr,
                                             (UInt32)outputSize,
                                             ref bytesReturned,
                                             IntPtr.Zero);
                if (!boolResult)
                {
                    throw new Win32Exception("Device '" + devicePath + "' failed IOCTL_STORAGE_GET_DEVICE_NUMBER_EX, status " + Marshal.GetLastWin32Error().ToString());
                }

                STORAGE_DEVICE_NUMBER_EX output = (STORAGE_DEVICE_NUMBER_EX) Marshal.PtrToStructure(outputPtr, typeof(STORAGE_DEVICE_NUMBER_EX));
                deviceGuid = output.DeviceGuid;
            }
            catch
            {
                throw;
            }
            finally
            {
                if (outputPtr != IntPtr.Zero)
                    Marshal.FreeHGlobal(outputPtr);

                if (hDevice != IntPtr.Zero)
                    CloseDevice(hDevice);
            }

            return deviceGuid;
        }

        static public bool IsClusBFltCandidate(string devicePath, UInt32 busTypes)
        {
            bool boolResult = false;
            IntPtr hPrMgrDevice = IntPtr.Zero;
            IntPtr hDevice = IntPtr.Zero;
            IntPtr inputPtr = IntPtr.Zero;
            IntPtr outputPtr = IntPtr.Zero;

            try
            {
                hPrMgrDevice = OpenDevice(CLUSBFLT_PR_MANAGER);
                hDevice = OpenDevice(devicePath);

                UInt32 bytesReturned = 0;

                CBFLT_IS_SUPPORTED_DISK_IN input = new CBFLT_IS_SUPPORTED_DISK_IN();
                input.Handle = hDevice;
                input.BusTypesOverride = busTypes;
                int inputSize = Marshal.SizeOf(typeof(CBFLT_IS_SUPPORTED_DISK_IN));
                inputPtr = Marshal.AllocHGlobal(inputSize);
                Marshal.StructureToPtr(input, inputPtr, false);

                int outputSize = Marshal.SizeOf(typeof(uint));
                outputPtr = Marshal.AllocHGlobal(outputSize);

                boolResult = DeviceIoControl(hPrMgrDevice,
                                             IOCTL_CBFLT_IS_SUPPORTED_DISK,
                                             inputPtr,
                                             (UInt32)inputSize,
                                             outputPtr,
                                             (UInt32)outputSize,
                                             ref bytesReturned,
                                             IntPtr.Zero);

                if (!boolResult)
                {
                    throw new Win32Exception("Device '" + devicePath + "' failed IOCTL_CBFLT_IS_SUPPORTED_DISK, status " + Marshal.GetLastWin32Error().ToString());
                }

                uint supportStatus = (uint)Marshal.PtrToStructure(outputPtr, typeof(uint));
                boolResult = (supportStatus == 0);
            }
            catch
            {
                throw;
            }
            finally
            {
                if (inputPtr != IntPtr.Zero)
                    Marshal.FreeHGlobal(inputPtr);

                if (outputPtr != IntPtr.Zero)
                    Marshal.FreeHGlobal(outputPtr);

                if (hDevice != IntPtr.Zero)
                    CloseDevice(hDevice);

                if (hPrMgrDevice != IntPtr.Zero)
                    CloseDevice(hPrMgrDevice);
            }

            return boolResult;
        }

        static public bool SetClusBFltSystemFlags(UInt32 systemFlags)
        {
            bool boolResult = false;
            IntPtr hTargetMgrFile = IntPtr.Zero;
            IntPtr inputPtr = IntPtr.Zero;

            try
            {
                hTargetMgrFile = OpenDevice(CLUSBFLT_BLOCK_TARGETFILE);

                UInt32 bytesReturned = 0;
                CBFLT_SET_PROFILE_IN input = new CBFLT_SET_PROFILE_IN();
                input.SystemFlags = systemFlags;
                int inputSize = Marshal.SizeOf(typeof(CBFLT_SET_PROFILE_IN));
                inputPtr = Marshal.AllocHGlobal(inputSize);
                Marshal.StructureToPtr(input, inputPtr, false);

                boolResult = DeviceIoControl(hTargetMgrFile,
                                             IOCTL_CBFLT_SET_PROFILE,
                                             inputPtr,
                                             (UInt32)inputSize,
                                             IntPtr.Zero,
                                             0,
                                             ref bytesReturned,
                                             IntPtr.Zero);

                if (!boolResult)
                {
                    throw new Win32Exception("ClusBFlt driver failed IOCTL_CBFLT_SET_PROFILE, status " + Marshal.GetLastWin32Error().ToString());
                }
            }
            catch
            {
                throw;
            }
            finally
            {
                if (inputPtr != IntPtr.Zero)
                    Marshal.FreeHGlobal(inputPtr);

                if (hTargetMgrFile != IntPtr.Zero)
                    CloseDevice(hTargetMgrFile);
            }

            return boolResult;
        }

        private static IntPtr ComputeFieldOffset(IntPtr buffer, Type parentStructure, string fieldName)
        {
            long offset = (long)Marshal.OffsetOf(parentStructure, fieldName);
            return (IntPtr)((long)buffer + offset);
        }

        private static IntPtr ComputeFieldOffsetAtIndex(IntPtr buffer, Type parentStructure, string fieldName, UInt32 index)
        {
            Type fieldType = parentStructure.GetField(fieldName).FieldType.GetElementType();
            long elementSize = Marshal.SizeOf(fieldType);
            long offset = (long)Marshal.OffsetOf(parentStructure, fieldName) + elementSize * index;
            return (IntPtr)((long)buffer + offset);
        }

        private static PARTITION_INFORMATION_EX Unmarshal_PARTITION_INFORMATION_EX(IntPtr buffer, UInt32 size)
        {
            if (size < (UInt32)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX)))
                throw new ArgumentException("Insufficient buffer size to unmarshal PARTITION_INFORMATION_EX.", "buffer");
            PARTITION_INFORMATION_EX info = (PARTITION_INFORMATION_EX)Marshal.PtrToStructure(
                buffer, typeof(PARTITION_INFORMATION_EX));
            if (info.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_MBR)
                info.Mbr = (PARTITION_INFORMATION_MBR)Marshal.PtrToStructure(
                    ComputeFieldOffset(buffer, typeof(PARTITION_INFORMATION_EX), "Mbr"),
                    typeof(PARTITION_INFORMATION_MBR));
            if (info.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_GPT)
                info.Gpt = (PARTITION_INFORMATION_GPT)Marshal.PtrToStructure(
                    ComputeFieldOffset(buffer, typeof(PARTITION_INFORMATION_EX), "Gpt"),
                    typeof(PARTITION_INFORMATION_GPT));
            return info;
        }

        private static DRIVE_LAYOUT_INFORMATION_EX Unmarshal_DRIVE_LAYOUT_INFORMATION_EX(IntPtr buffer, UInt32 size)
        {
            DRIVE_LAYOUT_INFORMATION_EX info = new DRIVE_LAYOUT_INFORMATION_EX();
            info.PartitionStyle = (PARTITION_STYLE)Marshal.ReadInt32(buffer);
            info.PartitionCount = (UInt32)Marshal.ReadInt32(ComputeFieldOffset(buffer,
                typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionCount"));
            if (size < checked(((UInt32)Marshal.OffsetOf(typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry") +
                info.PartitionCount * (UInt32)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX)))))
                throw new ArgumentException("Insufficient buffer size to unmarshal DRIVE_LAYOUT_INFORMATION_EX.", "buffer");
            if (info.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_MBR)
                info.Mbr = (DRIVE_LAYOUT_INFORMATION_MBR)Marshal.PtrToStructure(
                    ComputeFieldOffset(buffer, typeof(DRIVE_LAYOUT_INFORMATION_EX), "Mbr"),
                    typeof(DRIVE_LAYOUT_INFORMATION_MBR));
            if (info.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_GPT)
                info.Gpt = (DRIVE_LAYOUT_INFORMATION_GPT)Marshal.PtrToStructure(
                    ComputeFieldOffset(buffer, typeof(DRIVE_LAYOUT_INFORMATION_EX), "Gpt"),
                    typeof(DRIVE_LAYOUT_INFORMATION_GPT));
            info.PartitionEntry = new PARTITION_INFORMATION_EX[info.PartitionCount];
            size -= (UInt32)Marshal.OffsetOf(typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry");
            for (UInt32 partNumber = 0; partNumber < info.PartitionCount; partNumber++)
            {
                info.PartitionEntry[partNumber] = Unmarshal_PARTITION_INFORMATION_EX(ComputeFieldOffsetAtIndex(buffer,
                    typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry", partNumber), size);
                size -= (UInt32)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX));
            }
            return info;
        }

        private static void Marshal_DRIVE_LAYOUT_INFORMATION_EX(DRIVE_LAYOUT_INFORMATION_EX layout, IntPtr buffer, UInt32 size)
        {
            if (size < checked(((UInt32)Marshal.OffsetOf(typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry") +
                layout.PartitionCount * (UInt32)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX)))))
                throw new ArgumentException("Insufficient buffer size to marshal layout.", "buffer");
            Marshal.WriteInt32(buffer, (int)layout.PartitionStyle);
            Marshal.WriteInt32(ComputeFieldOffset(buffer, typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionCount"),
                (int)layout.PartitionCount);
            if (layout.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_GPT)
                Marshal.StructureToPtr(layout.Gpt, ComputeFieldOffset(buffer, typeof(PARTITION_INFORMATION_EX),
                    "Gpt"), false);
            else if (layout.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_MBR)
                Marshal.StructureToPtr(layout.Mbr, ComputeFieldOffset(buffer, typeof(PARTITION_INFORMATION_EX),
                    "Mbr"), false);
            size -= (UInt32)Marshal.OffsetOf(typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry");
            for (UInt32 partNumber = 0; partNumber < layout.PartitionCount; partNumber++)
            {
                PARTITION_INFORMATION_EX newPart = layout.PartitionEntry[partNumber];
                newPart.RewritePartition = true;
                Marshal_PARTITION_INFORMATION_EX(newPart, ComputeFieldOffsetAtIndex(buffer,
                    typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry", partNumber), size);
                size -= (UInt32)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX));
            }
        }

        private static void Marshal_PARTITION_INFORMATION_EX(PARTITION_INFORMATION_EX info, IntPtr buffer, UInt32 size)
        {
            if (size < (UInt32)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX)))
                throw new ArgumentException("Insufficient buffer to marshal info.", "buffer");
            Marshal.StructureToPtr(info, buffer, false);
            if (info.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_GPT)
                Marshal.StructureToPtr(info.Gpt, ComputeFieldOffset(buffer,
                    typeof(PARTITION_INFORMATION_EX), "Gpt"), false);
            if (info.PartitionStyle == PARTITION_STYLE.PARTITION_STYLE_MBR)
                Marshal.StructureToPtr(info.Mbr, ComputeFieldOffset(buffer,
                    typeof(PARTITION_INFORMATION_EX), "Mbr"), false);
        }

        static public DRIVE_LAYOUT_INFORMATION_EX GetDriveLayout(string devicePath)
        {
            bool boolResult = false;
            IntPtr hDevice = IntPtr.Zero;
            uint status = 0;

            DRIVE_LAYOUT_INFORMATION_EX layout = new DRIVE_LAYOUT_INFORMATION_EX();
            uint bufferSize = 0;
            IntPtr buffer = IntPtr.Zero;

            try
            {
                hDevice = OpenDevice(devicePath);
                bool done = false;
                uint bytesReturned = 0;
                uint partitionCount = 0;

                while (!done)
                {
                    bufferSize = (UInt32)Marshal.OffsetOf(typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry") +
                                 partitionCount * (uint)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX));
                    buffer = Marshal.AllocHGlobal((int) bufferSize);

                    boolResult = DeviceIoControl(hDevice,
                                                IOCTL_DISK_GET_DRIVE_LAYOUT_EX,
                                                IntPtr.Zero,
                                                0,
                                                buffer,
                                                (UInt32)bufferSize,
                                                ref bytesReturned,
                                                IntPtr.Zero);
                    if (!boolResult)
                    {
                        status = (uint)Marshal.GetLastWin32Error();
                        Console.WriteLine("IOCTL_DISK_GET_DRIVE_LAYOUT_EX failed, status = " + status + " bytes returned = " + bytesReturned);
                        if (status == ERROR_MORE_DATA || status == ERROR_INSUFFICIENT_BUFFER)
                        {
                            partitionCount = (UInt32)Marshal.ReadInt32(ComputeFieldOffset(buffer, typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionCount"));
                        }
                        else
                        {
                            throw new Win32Exception("Device '" + devicePath + "' failed IOCTL_DISK_GET_DRIVE_LAYOUT_EX, status " + status.ToString());
                        }
                    }
                    else
                    {
                        Console.WriteLine("IOCTL_DISK_GET_DRIVE_LAYOUT_EX passed");
                        layout = Unmarshal_DRIVE_LAYOUT_INFORMATION_EX(buffer, bufferSize);
                        done = true;
                    }

                    Marshal.FreeHGlobal(buffer);
                    buffer = IntPtr.Zero;
                }
            }
            catch
            {
                throw;
            }
            finally
            {
                if (buffer != IntPtr.Zero)
                    Marshal.FreeHGlobal(buffer);

                if (hDevice != IntPtr.Zero)
                    CloseDevice(hDevice);
            }

            return layout;
        }

        static public void SetDriveLayout(string devicePath, DRIVE_LAYOUT_INFORMATION_EX layout)
        {
            bool boolResult = false;
            IntPtr hDevice = IntPtr.Zero;
            IntPtr buffer = IntPtr.Zero;

            try
            {
                hDevice = OpenDevice(devicePath);
                uint bytesReturned = 0;

                uint bufferSize = checked((uint)Marshal.OffsetOf(typeof(DRIVE_LAYOUT_INFORMATION_EX), "PartitionEntry") +
                                  (uint)Marshal.SizeOf(typeof(PARTITION_INFORMATION_EX)) * (uint)layout.PartitionEntry.Length);
                buffer = Marshal.AllocHGlobal((int) bufferSize);

                Marshal_DRIVE_LAYOUT_INFORMATION_EX(layout, buffer, bufferSize);

                boolResult = DeviceIoControl(hDevice,
                                            IOCTL_DISK_SET_DRIVE_LAYOUT_EX,
                                            buffer,
                                            (UInt32)bufferSize,
                                            IntPtr.Zero,
                                            0,
                                            ref bytesReturned,
                                            IntPtr.Zero);
                if (!boolResult)
                {
                    throw new Win32Exception("Device '" + devicePath + "' failed IOCTL_DISK_SET_DRIVE_LAYOUT_EX, status " + Marshal.GetLastWin32Error().ToString());
                }
            }
            catch
            {
                throw;
            }
            finally
            {
                if (buffer != IntPtr.Zero)
                    Marshal.FreeHGlobal(buffer);

                if (hDevice != IntPtr.Zero)
                    CloseDevice(hDevice);
            }
        }

        static public void CleanupSblCachePartitions(string devicePath)
        {
            // First, get drive layout
            DRIVE_LAYOUT_INFORMATION_EX layout = GetDriveLayout(devicePath);

            // Update layout by skipping SBL cache partitions
            uint partitionCount = layout.PartitionCount;
            uint partitionIndex = 0;

            for (uint idx = 0; idx < layout.PartitionCount; ++idx)
            {
                if ((layout.PartitionEntry[idx].Gpt.PartitionType == PARTITION_SBL_CACHE_SSD_GUID) ||
                    (layout.PartitionEntry[idx].Gpt.PartitionType == PARTITION_SBL_CACHE_HDD_GUID) ||
                    (layout.PartitionEntry[idx].Gpt.PartitionType == PARTITION_SBL_CACHE_SSD_RESERVED_GUID))
                {
                    --partitionCount;
                }
                else if (partitionIndex != idx)
                {
                    layout.PartitionEntry[partitionIndex] = layout.PartitionEntry[idx];
                    ++partitionIndex;
                }
            }

            // If layout has changed, set the new layout
            if (partitionCount < layout.PartitionCount)
            {
                layout.PartitionCount = partitionCount;
                SetDriveLayout(devicePath, layout);
            }
        }

        #endregion
    }
}
"@

Add-Type -TypeDefinition $DiskControls -Language CSharp

[Microsoft.SFS.StorageBusCache.StorageBusType[]]$Global:SupportedBusTypes = @([Microsoft.SFS.StorageBusCache.StorageBusType]::Sas, `
                                                                              [Microsoft.SFS.StorageBusCache.StorageBusType]::Sata, `
                                                                              [Microsoft.SFS.StorageBusCache.StorageBusType]::Nvme, `
                                                                              [Microsoft.SFS.StorageBusCache.StorageBusType]::SCM)

$Global:SupportedBusTypeFlags = 0
foreach ($busType in $Global:SupportedBusTypes)
{
    $Global:SupportedBusTypeFlags = $Global:SupportedBusTypeFlags -bor (1 -shl $busType)
}

function CreateErrorRecord
{
    Param
    (
        [String]
        $ErrorId,

        [String]
        $ErrorMessage,

        [System.Management.Automation.ErrorCategory]
        $ErrorCategory,

        [Exception]
        $Exception,

        [Object]
        $TargetObject
    )

    if($Exception -eq $null)
    {
        $Exception = New-Object System.Management.Automation.RuntimeException $ErrorMessage
    }

    $errorRecord = New-Object System.Management.Automation.ErrorRecord @($Exception, $ErrorId, $ErrorCategory, $TargetObject)
    return $errorRecord
}

function IsS2DEnabled
{
    $clusRegKeyPath = "HKLM:\Cluster"
    if (Test-Path $clusRegKeyPath)
    {
        $clusRegKey = Get-ItemProperty $clusRegKeyPath -Name S2DEnabled -ErrorAction SilentlyContinue
        if ($clusRegKey.S2DEnabled -eq 1)
        {
            return $true
        }
    }
    return $false
}

function GetAllDisks()
{
    Param ()

    $deviceTable = @{}
    # Get disk drives visible to PnP, skipping storage spaces virtual disks, if any
    $pnpDrives = Get-PnpDevice -Class DiskDrive | ? FriendlyName -ne "Microsoft Storage Space Device"
    $systemDisks = Get-Disk | ? { $_.IsSystem -eq $true -or $_.IsBoot -eq $true }
    $systemDisks = $systemDisks | Get-PhysicalDisk

    foreach ($drive in $pnpDrives)
    {
        # Obtain device guid
        $devicePathPrefix = "\\?\" + $($drive.DeviceID -replace "\\",'#')

        $devicePath = $devicePathPrefix + "#{" + [Microsoft.SFS.StorageBusCache.DeviceMgmt]::GUID_DEVINTERFACE_DISK + "}"
        $disk = [Microsoft.SFS.StorageBusCache.DeviceMgmt]::GetStorageBusDisk($devicePath)
        if ($disk.Guid -eq [GUID]::Empty.ToString())
        {
            $hiddenDevicePath = $devicePathPrefix + "#{" + [Microsoft.SFS.StorageBusCache.DeviceMgmt]::GUID_DEVINTERFACE_HIDDEN_DISK  + "}"
            $disk = [Microsoft.SFS.StorageBusCache.DeviceMgmt]::GetStorageBusDisk($hiddenDevicePath)
            if ($disk.Guid -eq [GUID]::Empty.ToString())
            {
                continue
            }
        }

        # Check if this is boot or system drive
        $sysDisk = $systemDisks | ? ObjectId -match $disk.Guid | Select-Object -First 1
        if ($sysDisk)
        {
            # Skipping
            continue
        }

        # Add to device table
        if ($disk.Guid -notin $deviceTable.Keys)
        {
            $deviceTable.Add($disk.Guid, $disk)
        }
    }

    return $deviceTable
}


function Set-StorageBusProfile
{
    [CmdletBinding(ConfirmImpact="High")]
    Param
    (
        [System.Boolean]
        [Parameter(
            Mandatory = $false)]
        $ClaimFlash = $false
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    # Disable before setting profile
    Disable-StorageBusCache -Force $true

    # Wait for reauction after disable
    Start-Sleep -Seconds 10

    # Set Profile
    try
    {
        $systemFlags = 0;
        if ($ClaimFlash)
        {
            $systemFlags = [Microsoft.SFS.StorageBusCache.DeviceMgmt]::Standalone_Profile_Claim_Flash
        }
        else
        {
            $systemFlags = [Microsoft.SFS.StorageBusCache.DeviceMgmt]::Standalone_Profile_Default
        }

        # Set profile in memory via clusbflt control
        [Microsoft.SFS.StorageBusCache.DeviceMgmt]::SetClusBFltSystemFlags($systemFlags) | Out-Null

        # Set the bus types registry key in clusbflt registry
        $clusbfltRegKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\clusbflt\Parameters"
        $systemFlagsKeyName = "SystemFlags"
        if (Test-Path $clusbfltRegKeyPath)
        {
            New-ItemProperty -Path $clusbfltRegKeyPath -Name $systemFlagsKeyName -Value $systemFlags -PropertyType DWord -Force | Out-Null
        }
        else
        {
            $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                             -ErrorMessage "ClusBFlt registry key not found" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                             -Exception $null `
                                             -TargetObject $null

            $psCmdlet.WriteError($errorObject)
            return
        }
    }
    catch
    {
        $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                            -ErrorMessage $null `
                                            -ErrorCategory $_.CategoryInfo.Category `
                                            -Exception $_.Exception `
                                            -TargetObject $_.TargetObject
        $psCmdlet.WriteError($errorObject)
        return
    }

    # Enable after Setting profile
    Enable-StorageBusCache
}

function Enable-StorageBusCache
{
    [CmdletBinding(ConfirmImpact="None")]
    Param ()

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    # Set the bus types registry key in clusbflt registry
    $clusbfltRegKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\clusbflt\Parameters"
    $busTypeKeyName = "SupportedBusTypes"
    if (Test-Path $clusbfltRegKeyPath)
    {
        New-ItemProperty -Path $clusbfltRegKeyPath -Name $busTypeKeyName -Value $Global:SupportedBusTypeFlags -Force | Out-Null
    }
    else
    {
        $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                         -ErrorMessage "ClusBFlt registry key not found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }

    # Enumerate all eligible disks
    $devices = Get-StorageBusDisk

    # Claim disks
    try
    {
        foreach ($device in $devices)
        {
            $devicePath = "\\?\Disk" + $device.Guid

            # Check if disk is clusbflt candidate
            if (-not [Microsoft.SFS.StorageBusCache.DeviceMgmt]::IsClusBFltCandidate($devicePath, $Global:SupportedBusTypeFlags))
            {
                continue
            }

            # Reauction the disk
            [Microsoft.SFS.StorageBusCache.DeviceMgmt]::ReauctionDevice($devicePath) | Out-Null
        }
    }
    catch
    {
        $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                            -ErrorMessage $null `
                                            -ErrorCategory $_.CategoryInfo.Category `
                                            -Exception $_.Exception `
                                            -TargetObject $_.TargetObject
        $psCmdlet.WriteError($errorObject)
        return
    }
}

function Disable-StorageBusCache
{
    [CmdletBinding(ConfirmImpact="High")]
    Param
    (
        [System.Boolean]
        [Parameter(
            Mandatory = $false)]
        $Force = $false
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods

    # We should not release any devices until all bindings are removed, unless -Force is specified
    if (-not $Force)
    {
        # Enumerate all eligible disks
        $devices = Get-StorageBusDisk

        # Ensure there are no active bindings
        foreach ($device in $devices)
        {
            $boundDevices = Get-StorageBusBinding -Guid $device.Guid
            if ($boundDevices)
            {
                $errorObject = CreateErrorRecord -ErrorId "InvalidOperation" `
                                                 -ErrorMessage "Found existing cache bindings" `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                                 -Exception $null `
                                                 -TargetObject $null
                $psCmdlet.WriteError($errorObject)
                return
            }
        }
    }

    # Enumerate all eligible disks
    $devices = Get-StorageBusDisk

    # Clear the bus types registry key in clusbflt registry
    $clusbfltRegKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\clusbflt\Parameters"
    $busTypeKeyName = "SupportedBusTypes"
    if (Test-Path $clusbfltRegKeyPath)
    {
        New-ItemProperty -Path $clusbfltRegKeyPath -Name $busTypeKeyName -Value 0 -Force | Out-Null
    }
    else
    {
        $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                         -ErrorMessage "ClusBFlt registry key not found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }

    # Now release all devices.
    try
    {
        foreach ($device in $devices)
        {
            $devicePath = "\\?\Disk" + $device.Guid
            # Check if disk is clusbflt candidate
            if (-not [Microsoft.SFS.StorageBusCache.DeviceMgmt]::IsClusBFltCandidate($devicePath, $Global:SupportedBusTypeFlags))
            {
                continue
            }

            # Reauction the disk
            [Microsoft.SFS.StorageBusCache.DeviceMgmt]::ReauctionDevice($devicePath) | Out-Null
        }
    }
    catch
    {
        $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                            -ErrorMessage $null `
                                            -ErrorCategory $_.CategoryInfo.Category `
                                            -Exception $_.Exception `
                                            -TargetObject $_.TargetObject
        $psCmdlet.WriteError($errorObject)
        return
    }
}

function Get-StorageBusDisk
{
    [CmdletBinding( DefaultParameterSetName = "ByGuid")]
    Param
    (
        #### -------------------- Parameter sets ------------------------------------- ####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $false)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $false)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk
    )

    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods
    $paths = $(gwmi -namespace "root\wmi" ClusBfltDeviceInformation).PathInfo

    # Get all disks on this system
    $devices = GetAllDisks
    $physicalDisks = Get-PhysicalDisk

    # If device is claimed, update its properties based on path properties
    foreach ($deviceGuid in $devices.Keys)
    {
        $phyDisk = $physicalDisks | ? ObjectId -Match $deviceGuid
        if ($phyDisk)
        {
            # Set properties based on physical disk information
            $devices[$deviceGuid].BusType = $phyDisk.BusType
            $devices[$deviceGuid].Number = $phyDisk.DeviceId
        }

        $path = $paths | ? DeviceGuid -Match $deviceGuid | Select-Object -First 1
        if (-not $path)
        {
            # Device is not claimed, but check if there is a claimed cache partition
            if ($phyDisk)
            {
                # If the partition is claimed, the device guid on the path
                $path = $paths | ? DeviceNumber -eq $phyDisk.DeviceId | Select-Object -First 1
            }
        }

        if ($path)
        {
            if (-not $phyDisk)
            {
                # Set properties based on SBL path information since
                # device is claimed but not exposed above SBL
                $devices[$deviceGuid].BusType = $path.BusType
                $devices[$deviceGuid].Number = $path.DeviceNumber
            }

            # The following properties are SBL specific
            if (($path.Attributes -band [Microsoft.SFS.StorageBusCache.ClusBflt.PathInfoAttribute]::Partition) -eq 0)
            {
                # Path does not correspond to cache partition from an unclaimed device
                $devices[$deviceGuid].IsClaimed = $true
            }

            if ((($path.Attributes -band [Microsoft.SFS.StorageBusCache.ClusBflt.PathInfoAttribute]::Solid) -ne 0) -or
                (($path.Attributes -band [Microsoft.SFS.StorageBusCache.ClusBflt.PathInfoAttribute]::Partition) -ne 0))
            {
                $devices[$deviceGuid].IsCache = $true
            }
            else
            {
                $devices[$deviceGuid].IsCache = $false
            }
        }
    }

    [Microsoft.SFS.StorageBusCache.StorageBusDisk[]]$disks = @()

    # Enumerate the paths based on input
    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"
        {
            $disks = $devices.Values | ? Guid -match $Guid
            break;
        }
        "ByNumber"
        {
            $disks = $devices.Values | ? Number -eq $Number
            break;
        }
        "ByPhysicalDisk"
        {
            $diskGuid = $PhysicalDisk.ObjectId -Replace '.*:' -Replace '"'
            $disks = $devices.Values | ? Guid -match $diskGuid
            break;
        }
    }

    return $disks
}

function Get-StorageBusBinding
{
    [CmdletBinding(ConfirmImpact="None")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk

    )

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"         { $devices = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"       { $devices = Get-StorageBusDisk -Number $Number; break; }
        "ByPhysicalDisk" { $devices = Get-StorageBusDisk -Number $PhysicalDisk.DeviceId; break; }
    }

    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods
    $paths = $(gwmi -namespace "root\wmi" ClusBfltDeviceInformation).PathInfo
    $cs = gwmi -namespace "root\wmi" ClusBfltCacheStoresInformation

    [Microsoft.SFS.StorageBusCache.StorageBusBinding[]]$boundDevices = @()

    try
    {
        foreach ($device in $devices)
        {
            if ($device.IsCache)
            {
                $pathid = $pm.GetPathIdByDeviceGuid($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Read_Write, 0, 0, 0)

                if ($pathid.PathId -eq 0)
                {
                    # This could be unclaimed cache device with claimed cache partition
                    $pathid.PathId = ($paths | ? DeviceNumber -eq $device.Number).Id
                }

                if ($pathid.PathId -ne 0)
                {
                    $cache = $cs.CacheStoreInfo | ? PathId -eq $pathid.PathId
                    if ($cache)
                    {
                        $ssdBindingRecords = $pm.QuerySsdBindingRecords($pathid.PathId, $cache.Id).BindingRecords.BindingRecords
                        foreach ($bindingRecord in $ssdBindingRecords)
                        {
                            if (($bindingRecord.Flags -band [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Enabled) -ne 0)
                            {
                                $capacityDevice = Get-StorageBusDisk -Guid $bindingRecord.DeviceGuid

                                [Microsoft.SFS.StorageBusCache.StorageBusBinding]$storageBusBinding = [Microsoft.SFS.StorageBusCache.StorageBusBinding]::new()
                                $storageBusBinding.Guid = $capacityDevice.Guid
                                $storageBusBinding.Number = $capacityDevice.Number
                                $storageBusBinding.IsCache = $capacityDevice.IsCache
                                $storageBusBinding.IsCacheSuspended = $false
                                $storageBusBinding.DirtyByteCount = 0

                                if (($bindingRecord.Flags -band [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Disable_Write_Cache) -ne 0)
                                {
                                    $storageBusBinding.IsCacheSuspended = $true
                                }
                                $storageBusBinding.DirtyByteCount = $bindingRecord.cDirtyPages * $cache.PageSize

                                $boundDevices += $storageBusBinding
                            }
                        }
                    }
                }
            }
            else
            {
                $egPath = $pm.GetPathIdByDeviceGuid($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Engaged, 0, 0, 0)
                if ($egPath.PathId -ne 0)
                {
                    $hddBinding = $pm.QueryHddBinding($egPath.PathId)
                    $cache = $cs.CacheStoreInfo | ? Id -eq $hddBinding.BindingInfo.CacheStoreId
                    $cachePath = $paths | ? Id -eq $cache.PathId
                    $cacheDevice = Get-StorageBusDisk -Guid $cachePath.DeviceGuid
                    if (-not $cacheDevice)
                    {
                        # This could be unclaimed cache device with claimed cache partition
                        $cacheDevice = Get-StorageBusDisk -Number $cachePath.DeviceNumber
                    }

                    [Microsoft.SFS.StorageBusCache.StorageBusBinding]$storageBusBinding = [Microsoft.SFS.StorageBusCache.StorageBusBinding]::new()
                    $storageBusBinding.Guid = $cacheDevice.Guid
                    $storageBusBinding.Number = $cacheDevice.Number
                    $storageBusBinding.IsCache = $cacheDevice.IsCache
                    $storageBusBinding.IsCacheSuspended = $false
                    $storageBusBinding.DirtyByteCount = 0

                    # Obtain binding record that matches binding Id
                    $bindingRecord = $pm.QuerySsdBindingRecords($cache.PathId, $cache.Id).BindingRecords.BindingRecords | ? BindingId -eq $hddBinding.BindingInfo.BindingId
                    if (($bindingRecord.Flags -band [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Disable_Write_Cache) -ne 0)
                    {
                        $storageBusBinding.IsCacheSuspended = $true
                    }
                    $storageBusBinding.DirtyByteCount = $bindingRecord.cDirtyPages * $cache.PageSize

                    $boundDevices += $storageBusBinding
                }
            }
        }
    }
    catch
    {
        $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                         -ErrorMessage $null `
                                         -ErrorCategory $_.CategoryInfo.Category `
                                         -Exception $_.Exception `
                                         -TargetObject $_.TargetObject
        $psCmdlet.WriteError($errorObject)
        return
    }

    $boundDevices
}

function Enable-StorageBusDisk
{
    [CmdletBinding(ConfirmImpact="None")]
    param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"         { $devices = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"       { $devices = Get-StorageBusDisk -Number $Number; break; }
        "ByPhysicalDisk" { $devices = Get-StorageBusDisk -Number $PhysicalDisk.DeviceId; break; }
    }

    # Filter out claimed devices
    $devices = $devices | ? IsClaimed -eq $false

    $dm = gwmi -namespace "root\wmi" ClusBfltDeviceMethods

    foreach ($device in $devices)
    {
        try
        {
            # Have clusbflt claim the drive
            $dm.SetDeviceAttributes($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::Default, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)

            # Reauction the disk
            $devicePath = "\\?\Disk" + $device.Guid
            [Microsoft.SFS.StorageBusCache.DeviceMgmt]::ReauctionDevice($devicePath) | Out-Null
        }
        catch
        {
            $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                             -ErrorMessage $null `
                                             -ErrorCategory $_.CategoryInfo.Category `
                                             -Exception $_.Exception `
                                             -TargetObject $_.TargetObject
            $psCmdlet.WriteError($errorObject)
            return
        }
    }
}

function Disable-StorageBusDisk
{
    [CmdletBinding(ConfirmImpact="High")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"         { $devices = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"       { $devices = Get-StorageBusDisk -Number $Number; break; }
        "ByPhysicalDisk" { $devices = Get-StorageBusDisk -Number $PhysicalDisk.DeviceId; break; }
    }

    # Filter out unclaimed devices
    $devices = $devices | ? IsClaimed -eq $true

    $dm = gwmi -namespace "root\wmi" ClusBfltDeviceMethods
    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods

    foreach ($device in $devices)
    {
        if ($device.IsCache)
        {
            # First unbind all bound capacity devices
            $boundDevices = Get-StorageBusBinding -Guid $device.Guid
            if ($boundDevices)
            {
                $errorObject = CreateErrorRecord -ErrorId "InvalidOperation" `
                                                 -ErrorMessage "Cache device is currently bound" `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                                 -Exception $null `
                                                 -TargetObject $null
                $psCmdlet.WriteError($errorObject)
                return
            }
        }
        else
        {
            # Remove bindings from cache and capacity dev
            Remove-StorageBusBinding -Guid $device.Guid
        }

        try
        {
            # Have clusbflt unclaim the drive
            $dm.SetDeviceAttributes($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::Disabled, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)

            # Reauction the disk
            $devicePath = "\\?\Disk" + $device.Guid
            [Microsoft.SFS.StorageBusCache.DeviceMgmt]::ReauctionDevice($devicePath) | Out-Null
        }
        catch
        {
            $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                             -ErrorMessage $null `
                                             -ErrorCategory $_.CategoryInfo.Category `
                                             -Exception $_.Exception `
                                             -TargetObject $_.TargetObject
            $psCmdlet.WriteError($errorObject)
            return
        }
    }
}

function Resume-StorageBusDisk
{
    [CmdletBinding(ConfirmImpact="Low")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"         { $devices = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"       { $devices = Get-StorageBusDisk -Number $Number; break; }
        "ByPhysicalDisk" { $devices = Get-StorageBusDisk -Number $PhysicalDisk.DeviceId; break; }
    }

    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods
    $paths = $(gwmi -namespace "root\wmi" ClusBfltDeviceInformation).PathInfo

    foreach ($device in $devices)
    {
        if ($device.IsCache)
        {
            # First resume all bound capacity devices
            $boundDevices = Get-StorageBusBinding -Guid $device.Guid
            foreach ($boundDevice in $boundDevices)
            {
                Resume-StorageBusDisk -Guid $boundDevice.Guid
            }
        }
        else
        {
            try
            {
                $egPath = $pm.GetPathIdByDeviceGuid($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Engaged, 0, 0, 0)
                if ($egPath.PathId -ne 0)
                {
                    # Obtain the capacity device binding info
                    $binding = $pm.QueryHddBinding($egPath.PathId).BindingInfo

                    # Obtain the cache store
                    $cs = gwmi -namespace "root\wmi" ClusBfltCacheStoresInformation
                    $cache = $cs.CacheStoreInfo | ? Id -Match $binding.CacheStoreId

                    # Obtain binding record that matches binding Id
                    $bindingRecord = $pm.QuerySsdBindingRecords($cache.PathId, $cache.Id).BindingRecords.BindingRecords | ? BindingId -Match $binding.BindingId

                    if ($bindingRecord -ne $null)
                    {
                        # Set cache binding attribute back to default
                        $pm.SetSsdBindingAttributes($cache.PathId, [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Default, [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Disable_Write_Cache, $cache.Id, $binding.BindingId)
                    }
                }
            }
            catch
            {
                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject
                $psCmdlet.WriteError($errorObject)
                return
            }
        }
    }
}

function Suspend-StorageBusDisk
{
    [CmdletBinding(ConfirmImpact="High")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"         { $devices = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"       { $devices = Get-StorageBusDisk -Number $Number; break; }
        "ByPhysicalDisk" { $devices = Get-StorageBusDisk -Number $PhysicalDisk.DeviceId; break; }
    }

    $dm = gwmi -namespace "root\wmi" ClusBfltDeviceMethods
    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods

    foreach ($device in $devices)
    {
        if ($device.IsCache)
        {
            # First suspend all bound capacity devices
            $boundDevices = Get-StorageBusBinding -Guid $device.Guid
            foreach ($boundDevice in $boundDevices)
            {
                Suspend-StorageBusDisk -Guid $boundDevice.Guid
            }
        }
        else
        {
            try
            {
                $egPath = $pm.GetPathIdByDeviceGuid($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Engaged, 0, 0, 0)
                if ($egPath.PathId -ne 0)
                {
                    # Obtain the capacity device binding info
                    $binding = $pm.QueryHddBinding($egPath.PathId).BindingInfo

                    # Obtain the cache store
                    $cs = gwmi -namespace "root\wmi" ClusBfltCacheStoresInformation
                    $cache = $cs.CacheStoreInfo | ? Id -Match $binding.CacheStoreId

                    # Obtain binding record that matches binding Id
                    $bindingRecord = $pm.QuerySsdBindingRecords($cache.PathId, $cache.Id).BindingRecords.BindingRecords | ? BindingId -Match $binding.BindingId

                    if ($bindingRecord -ne $null -and ($bindingRecord.Flags -band [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Enabled) -ne 0)
                    {
                        # Disable Write cache
                        $pm.SetSsdBindingAttributes($cache.PathId, [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Disable_Write_Cache, [Microsoft.SFS.StorageBusCache.ClusBflt.CacheStoreBindingAttribute]::Disable_Write_Cache, $cache.Id, $binding.BindingId)

                        # Wait for dirty page count to go down to 0 for this cache binding
                        while ($true)
                        {
                            if ($bindingRecord.cDirtyPages -eq 0 -and $bindingRecord.cDirtySlots -eq 0)
                            {
                                break
                            }

                            Start-Sleep -Seconds 10
                            $bindingRecord = $pm.QuerySsdBindingRecords($cache.PathId, $cache.Id).BindingRecords.BindingRecords | ? BindingId -Match $binding.BindingId
                        }
                    }
                }
            }
            catch
            {
                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject
                $psCmdlet.WriteError($errorObject)
                return
            }
        }
    }
}

function New-StorageBusCacheStore
{
    [CmdletBinding(ConfirmImpact="Low")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        #### -------------------- Common parameters -------------------------------------####

        [System.UInt32]
        [Parameter(
            ParameterSetName = 'ByGuid',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByNumber',
            Mandatory        = $false)]
        $PageSize = 8KB,

        [System.UInt64]
        [Parameter(
            ParameterSetName = 'ByGuid',
            Mandatory        = $false)]
        [Parameter(
            ParameterSetName = 'ByNumber',
            Mandatory        = $false)]
        $ReserveCapacity = 0
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"        { $cacheDevice = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"      { $cacheDevice = Get-StorageBusDisk -Number $Number; break; }
    }

    # Filter out unclaimed devices
    $cacheDevice = $cacheDevice | ? IsClaimed -eq $true

    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods
    $dm = gwmi -namespace "root\wmi" ClusBfltDeviceMethods

    # Ensure exactly one cache device is obtained
    if (-not $cacheDevice)
    {
        $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                         -ErrorMessage "Specified cache device not found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }
    if ($cacheDevice.Count -ne 1)
    {
        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                         -ErrorMessage "More than one matching cache device found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }
    if (-not $cacheDevice.IsCache)
    {
        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                         -ErrorMessage "Not a cache device" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }

    $deviceAttributes = $dm.GetDeviceAttributes($cacheDevice.Guid)

    try
    {
        # Create cache store
        $dm.SetDeviceAttributes($cacheDevice.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::Maintenance, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)

        $mmPath = $pm.GetPathIdByDeviceGuid($cacheDevice.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Maintenance, 0, 0, 0)
        if ($mmPath)
        {
            $pm.CreateSsdCacheStore($mmPath.PathId, 0, $ReserveCapacity, $PageSize)
        }
        else
        {
            $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                                -ErrorMessage "Device path not found after setting Maintenance mode" `
                                                -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                -Exception $null `
                                                -TargetObject $null
            $psCmdlet.WriteError($errorObject)
            return
        }
    }
    catch
    {
        $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                            -ErrorMessage $null `
                                            -ErrorCategory $_.CategoryInfo.Category `
                                            -Exception $_.Exception `
                                            -TargetObject $_.TargetObject
        $psCmdlet.WriteError($errorObject)
        return
    }
    finally
    {
        $dm.SetDeviceAttributes($cacheDevice.Guid, $deviceAttributes.Attributes, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)
    }
}

function New-StorageBusBinding
{
    [CmdletBinding(ConfirmImpact="Low")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("CacheId")]
        $CacheGuid,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("CapacityId")]
        $CapacityGuid,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $CacheNumber,

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $CapacityNumber
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"        { $cacheDevice = Get-StorageBusDisk -Guid $CacheGuid; $capacityDevice = Get-StorageBusDisk -Guid $CapacityGuid; break; }
        "ByNumber"      { $cacheDevice = Get-StorageBusDisk -Number $CacheNumber; $capacityDevice = Get-StorageBusDisk -Number $CapacityNumber; break; }
    }

    # Filter out unclaimed devices
    $capacityDevice = $capacityDevice | ? IsClaimed -eq $true

    # Ensure exactly one cache device is obtained
    if (-not $cacheDevice)
    {
        $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                         -ErrorMessage "Specified cache device not found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }
    if ($cacheDevice.Count -ne 1)
    {
        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                         -ErrorMessage "More than one matching cache device found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }
    if (-not $cacheDevice.IsCache)
    {
        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                         -ErrorMessage "Not a cache device" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }

    # Ensure exactly one capacity device is obtained
    if (-not $capacityDevice)
    {
        $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                         -ErrorMessage "Specified capacity device not found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }
    if ($capacityDevice.Count -ne 1)
    {
        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                         -ErrorMessage "More than one matching capacity device found" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }
    if ($capacityDevice.IsCache)
    {
        $errorObject = CreateErrorRecord -ErrorId "InvalidArgument" `
                                         -ErrorMessage "Not a capacity device" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidArgument) `
                                         -Exception $null `
                                         -TargetObject $null

        $psCmdlet.WriteError($errorObject)
        return
    }

    $dm = gwmi -namespace "root\wmi" ClusBfltDeviceMethods
    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods
    $cs = gwmi -namespace "root\wmi" ClusBfltCacheStoresInformation
    $paths = $(gwmi -namespace "root\wmi" ClusBfltDeviceInformation).PathInfo

    $deviceAttributes = $dm.GetDeviceAttributes($capacityDevice.Guid)

    try
    {
        # Obtain the cache store
        $cache = $cs.CacheStoreInfo | ? DeviceGuid -Match $cacheDevice.Guid

        if ($cache -eq $null)
        {
            # This could be unclaimed cache device with claimed cache partition
            $cachePath = $paths | ? DeviceNumber -eq $cacheDevice.Number
            if ($cachePath)
            {
                $cache = $cs.CacheStoreInfo | ? DeviceGuid -Match $cachePath.DeviceGuid
            }
        }

        if ($cache -eq $null)
        {
            # No cache store found so create cache store
            New-StorageBusCacheStore -Guid $cacheDevice.Guid -PageSize 8KB -ReserveCapacity 32GB

            # Obtain the cache store
            $cs = gwmi -namespace "root\wmi" ClusBfltCacheStoresInformation
            $cache = $cs.CacheStoreInfo | ? DeviceGuid -Match $cacheDevice.Guid

            if (-not $cache)
            {
                $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                                 -ErrorMessage "No cache store found on cache device " + $cacheDevice.Guid `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                 -Exception $null `
                                                 -TargetObject $null
                $psCmdlet.WriteError($errorObject)
                return
            }
        }

        # Check if the capacity device is already bound
        $egPath = $pm.GetPathIdByDeviceGuid($capacityDevice.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Engaged, 0, 0, 0)
        if ($egPath.PathId -eq 0)
        {
            # Bind Capacity device to cache store
            $dm.SetDeviceAttributes($capacityDevice.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::Maintenance, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)
            $mmPath = $pm.GetPathIdByDeviceGuid($capacityDevice.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Maintenance, 0, 0, 0)

            if ($mmPath.PathId -ne 0)
            {
                $pm.PrepareHddForCache($mmPath.PathId, 0)
                $pm.BindHddToCacheStore($mmPath.PathId, [Microsoft.SFS.StorageBusCache.DeviceMgmt]::Standalone_Cache_Binding_Attributes, $cache.Id)
            }
            else
            {
                $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                                 -ErrorMessage "Device path not found after setting Maintenance mode" `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                 -Exception $null `
                                                 -TargetObject $null
                $psCmdlet.WriteError($errorObject)
                return
            }
        }
        else
        {
            $errorObject = CreateErrorRecord -ErrorId "InvalidOperation" `
                                             -ErrorMessage "Capacity device is already bound" `
                                             -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                             -Exception $null `
                                             -TargetObject $null
            $psCmdlet.WriteError($errorObject)
            return
        }
    }
    catch
    {
        $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                         -ErrorMessage $null `
                                         -ErrorCategory $_.CategoryInfo.Category `
                                         -Exception $_.Exception `
                                         -TargetObject $_.TargetObject
        $psCmdlet.WriteError($errorObject)
        return
    }
    finally
    {
        $dm.SetDeviceAttributes($capacityDevice.Guid, $deviceAttributes.Attributes, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)
    }
}

function Remove-StorageBusBinding
{
    [CmdletBinding(ConfirmImpact="High")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"         { $devices = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"       { $devices = Get-StorageBusDisk -Number $Number; break; }
        "ByPhysicalDisk" { $devices = Get-StorageBusDisk -Number $PhysicalDisk.DeviceId; break; }
    }

    # Filter out unclaimed devices
    $devices = $devices | ? IsClaimed -eq $true

    $dm = gwmi -namespace "root\wmi" ClusBfltDeviceMethods
    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods

    foreach ($device in $devices)
    {
        if ($device.IsCache)
        {
            # First unbind all bound capacity devices
            $boundDevices = Get-StorageBusBinding -Guid $device.Guid
            foreach ($boundDevice in $boundDevices)
            {
                Remove-StorageBusBinding -Guid $boundDevice.Guid
            }
        }
        else
        {
            $deviceAttributes = $dm.GetDeviceAttributes($device.Guid)

            try
            {
                $egPath = $pm.GetPathIdByDeviceGuid($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Engaged, 0, 0, 0)
                if ($egPath.PathId -ne 0)
                {
                    # Disable write cache and drain IOs
                    Suspend-StorageBusDisk -Guid $device.Guid

                    # Unbind HDD
                    $dm.SetDeviceAttributes($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::Maintenance, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)
                    $mmPath = $pm.GetPathIdByDeviceGuid($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Maintenance, 0, 0, 0)
                    if ($mmPath.PathId -ne 0)
                    {
                        $pm.UnBindHdd($mmPath.PathId, 0)
                    }
                    else
                    {
                        $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                                         -ErrorMessage "Device path not found after setting Maintenance mode" `
                                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                         -Exception $null `
                                                         -TargetObject $null
                        $psCmdlet.WriteError($errorObject)
                        return
                    }
                }
            }
            catch
            {
                $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                                 -ErrorMessage $null `
                                                 -ErrorCategory $_.CategoryInfo.Category `
                                                 -Exception $_.Exception `
                                                 -TargetObject $_.TargetObject
                $psCmdlet.WriteError($errorObject)
                return
            }
            finally
            {
                $dm.SetDeviceAttributes($device.Guid, $deviceAttributes.Attributes, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)
            }

        }
    }
}

function Clear-StorageBusDisk
{
    [CmdletBinding(ConfirmImpact="High")]
    Param
    (
        #### -------------------- Parameter sets -------------------------------------####

        [System.String]
        [Parameter(
            ParameterSetName  = 'ByGuid',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        $Guid,

        [System.UInt16]
        [Parameter(
            ParameterSetName  = 'ByNumber',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $Number,

        [Microsoft.Management.Infrastructure.CimInstance]
        [PSTypeName("Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_PhysicalDisk")]
        [Parameter(
            ParameterSetName  = 'ByPhysicalDisk',
            ValueFromPipeline = $true,
            Mandatory         = $true)]
        [ValidateNotNullOrEmpty()]
        $PhysicalDisk
    )

    if (IsS2DEnabled)
    {
        $errorObject = CreateErrorRecord -ErrorId "Cluster S2D is enabled" `
                                         -ErrorMessage "StorageBusCache Cmdlets cannot be run on a cluster S2D setup" `
                                         -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                         -Exception $null `
                                         -TargetObject $null
        $psCmdlet.WriteError($errorObject)
        return
    }

    switch ($psCmdlet.ParameterSetName)
    {
        "ByGuid"         { $devices = Get-StorageBusDisk -Guid $Guid; break; }
        "ByNumber"       { $devices = Get-StorageBusDisk -Number $Number; break; }
        "ByPhysicalDisk" { $devices = Get-StorageBusDisk -Number $PhysicalDisk.DeviceId; break; }
    }

    # Filter out unclaimed devices
    $devices = $devices | ? IsClaimed -eq $true

    $dm = gwmi -namespace "root\wmi" ClusBfltDeviceMethods
    $pm = gwmi -namespace "root\wmi" ClusBfltPathMethods

    foreach ($device in $devices)
    {
        $deviceAttributes = $dm.GetDeviceAttributes($device.Guid)

        try
        {
            $dm.SetDeviceAttributes($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::Maintenance, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)
            $mmPath = $pm.GetPathIdByDeviceGuid($device.Guid, [Microsoft.SFS.StorageBusCache.ClusBflt.PathType]::Maintenance, 0, 0, 0)

            if ($mmPath.PathId -ne 0)
            {
                # Remove all cache partitions on the disk
                $devicePath = "\\?\Disk" + $device.Guid
                [Microsoft.SFS.StorageBusCache.DeviceMgmt]::CleanupSblCachePartitions($devicePath) | Out-Null
            }
            else
            {
                $errorObject = CreateErrorRecord -ErrorId "NotFound" `
                                                 -ErrorMessage "Device path not found after setting Maintenance mode" `
                                                 -ErrorCategory ([System.Management.Automation.ErrorCategory]::ObjectNotFound) `
                                                 -Exception $null `
                                                 -TargetObject $null
                $psCmdlet.WriteError($errorObject)
                return
            }
        }
        catch
        {
            $errorObject = CreateErrorRecord -ErrorId $_.FullyQualifiedErrorId `
                                             -ErrorMessage $null `
                                             -ErrorCategory $_.CategoryInfo.Category `
                                             -Exception $_.Exception `
                                             -TargetObject $_.TargetObject
            $psCmdlet.WriteError($errorObject)
            return
        }
        finally
        {
            $dm.SetDeviceAttributes($device.Guid, $deviceAttributes.Attributes, [Microsoft.SFS.StorageBusCache.ClusBflt.DiskAttribute]::All)
        }
    }
}
