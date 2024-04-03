#!/usr/bin/env bash
export LC_ALL=C

function web_get() {
  local URL="${1}"
  local FILE=""
  FILE="${URL##*/}"
  if [ ! -e "${VMDIR}/${FILE}" ]; then
    if ! wget -q -c "${URL}" -O "${VMDIR}/${FILE}"; then
      echo "ERROR! Failed to download ${URL}"
      exit 1
    fi
  fi
}

function disk_delete() {
  if [ -e "${disk_img}" ]; then
    rm "${disk_img}"
    echo "SUCCESS! Deleted ${disk_img}"
  else
    echo "NOTE! ${disk_img} not found. Doing nothing."
  fi
  local VMNAME=""
  VMNAME=$(basename "${VM}" .conf)
  local SHORTCUT_DIR="/home/${USER}/.local/share/applications/"
  if [ -e "${SHORTCUT_DIR}/${VMNAME}.desktop" ]; then
    rm -v "${SHORTCUT_DIR}/${VMNAME}.desktop"
    echo "Deleted ${VM} desktop shortcut"
  fi
}

function snapshot_apply() {
  local TAG="${1}"
  if [ -z "${TAG}" ]; then
    echo "ERROR! No snapshot tag provided."
    exit
  fi

  if [ -e "${disk_img}" ]; then
    if ${QEMU_IMG} snapshot -q -a "${TAG}" "${disk_img}"; then
      echo "SUCCESS! Applied snapshot ${TAG} to ${disk_img}"
    else
      echo "ERROR! Failed to apply snapshot ${TAG} to ${disk_img}"
    fi
  else
    echo "NOTE! ${disk_img} not found. Doing nothing."
  fi
}

function snapshot_create() {
  local TAG="${1}"
  if [ -z "${TAG}" ]; then
    echo "ERROR! No snapshot tag provided."
    exit
  fi

  if [ -e "${disk_img}" ]; then
    if ${QEMU_IMG} snapshot -q -c "${TAG}" "${disk_img}"; then
      echo "SUCCESS! Created snapshot ${TAG} of ${disk_img}"
    else
      echo "ERROR! Failed to create snapshot ${TAG} of ${disk_img}"
    fi
  else
    echo "NOTE! ${disk_img} not found. Doing nothing."
  fi
}

function snapshot_delete() {
  local TAG="${1}"
  if [ -z "${TAG}" ]; then
    echo "ERROR! No snapshot tag provided."
    exit
  fi

  if [ -e "${disk_img}" ]; then
    if ${QEMU_IMG} snapshot -q -d "${TAG}" "${disk_img}"; then
      echo "SUCCESS! Deleted snapshot ${TAG} of ${disk_img}"
    else
      echo "ERROR! Failed to delete snapshot ${TAG} of ${disk_img}"
    fi
  else
    echo "NOTE! ${disk_img} not found. Doing nothing."
  fi
}

function snapshot_info() {
  if [ -e "${disk_img}" ]; then
    ${QEMU_IMG} info "${disk_img}"
  fi
}

function get_port() {
    local PORT_START=$1
    local PORT_RANGE=$2
    while true; do
        local CANDIDATE=$((PORT_START + (RANDOM % PORT_RANGE)))
        (echo "" >/dev/tcp/127.0.0.1/${CANDIDATE}) >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "${CANDIDATE}"
            break
        fi
    done
}

function enable_usb_passthrough() {
  local DEVICE=""
  local USB_BUS=""
  local USB_DEV=""
  local USB_NAME=""
  local VENDOR_ID=""
  local PRODUCT_ID=""
  local TEMP_SCRIPT=""
  local EXEC_SCRIPT=0

  TEMP_SCRIPT=$(mktemp)
  # Have any USB devices been requested for pass-through?
  if (( ${#usb_devices[@]} )); then
    echo " - USB:      Device pass-through requested:"
    echo "#!/usr/bin/env bash" > "${TEMP_SCRIPT}"
    for DEVICE in "${usb_devices[@]}"; do
      VENDOR_ID=$(echo "${DEVICE}" | cut -d':' -f1)
      PRODUCT_ID=$(echo "${DEVICE}" | cut -d':' -f2)
      USB_BUS=$(lsusb -d "${VENDOR_ID}:${PRODUCT_ID}" | cut -d' ' -f2)
      USB_DEV=$(lsusb -d "${VENDOR_ID}:${PRODUCT_ID}" | cut -d' ' -f4 | cut -d':' -f1)
      USB_NAME=$(lsusb -d "${VENDOR_ID}:${PRODUCT_ID}" | cut -d' ' -f7-)
      echo "              - ${USB_NAME}"
      USB_PASSTHROUGH="${USB_PASSTHROUGH} -device usb-host,vendorid=0x${VENDOR_ID},productid=0x${PRODUCT_ID},bus=usb.0"
      if [ ! -w "/dev/bus/usb/${USB_BUS}/${USB_DEV}" ]; then
        local EXEC_SCRIPT=1
        echo "chown root:${USER} /dev/bus/usb/${USB_BUS}/${USB_DEV}" >> "${TEMP_SCRIPT}"
      fi
    done

    if [ ${EXEC_SCRIPT} -eq 1 ]; then
      chmod +x "${TEMP_SCRIPT}"
      echo "             Requested USB device(s) are NOT accessible."
      echo "             ${TEMP_SCRIPT} will be executed to enable access:"
      echo
      cat "${TEMP_SCRIPT}"
      echo
      if ! sudo "${TEMP_SCRIPT}"; then
        echo "            WARNING! Enabling USB device access failed."
      fi
    else
      echo "             Requested USB device(s) are accessible."
    fi
    rm -f "${TEMP_SCRIPT}"
  fi
}

function vm_boot() {
  local VMNAME=""
  VMNAME=$(basename "${VM}" .conf)
  local VMDIR=""
  VMDIR=$(dirname "${disk_img}")
  local CPU="-cpu host,kvm=on"
  local GUEST_TWEAKS=""
  local DISPLAY_DEVICE=""
  local VIDEO=""
  local GL="on"
  local VIRGL="on"
  local OUTPUT="sdl"
  local OUTPUT_EXTRA=""
  local QEMU_VER=""
  QEMU_VER=$(${QEMU} -version | head -n1 | cut -d' ' -f4 | cut -d'(' -f1)
  echo "Starting ${VM}"
  echo " - QEMU:     ${QEMU} v${QEMU_VER}"

  # Force to lowercase.
  boot=${boot,,}

  # Always Boot macOS using EFI
  if [ "${guest_os}" == "macos" ]; then
    boot="efi"
  fi

  if [ "${boot}" == "efi" ] || [ "${boot}" == "uefi" ]; then
    if [ -e "/usr/share/OVMF/OVMF_CODE_4M.fd" ] ; then
      if [ "${guest_os}" == "macos" ]; then
        web_get "https://github.com/foxlet/macOS-Simple-KVM/raw/master/ESP.qcow2"
        web_get "https://github.com/foxlet/macOS-Simple-KVM/raw/master/firmware/OVMF_CODE.fd"
        web_get "https://github.com/foxlet/macOS-Simple-KVM/raw/master/firmware/OVMF_VARS-1024x768.fd"
        local EFI_CODE="${VMDIR}/OVMF_CODE.fd"
        local EFI_VARS="${VMDIR}/OVMF_VARS-1024x768.fd"
      else
        local EFI_CODE="/usr/share/OVMF/OVMF_CODE_4M.fd"
        local EFI_VARS="${VMDIR}/${VMNAME}-vars.fd"
        if [ ! -e "${EFI_VARS}" ]; then
          cp "/usr/share/OVMF/OVMF_VARS_4M.fd" "${EFI_VARS}"
        fi
      fi
      echo " - BOOT:     EFI"
    else
      echo " - BOOT:     Legacy BIOS"
      echo " -           EFI Booting requested but no EFI firmware found."
    fi
  else
    echo " - BOOT:     Legacy BIOS"
  fi

  # Force to lowercase.
  guest_os=${guest_os,,}
  # Make any OS specific adjustments
  case ${guest_os} in
    linux)
      DISPLAY_DEVICE="virtio-vga"
      ;;
    macos)
      CPU="-cpu Penryn,vendor=GenuineIntel,kvm=on,+aes,+avx,+avx2,+bmi1,+bmi2,+fma,+invtsc,+movbe,+pcid,+smep,+sse3,+sse4.2,+xgetbv1,+xsave,+xsavec,+xsaveopt"
      OSK=""
      OSK=$(echo "bheuneqjbexolgurfrjbeqfthneqrqcyrnfrqbagfgrny(p)NccyrPbzchgreVap" | rot13)
      GUEST_TWEAKS="-device isa-applesmc,osk=${OSK}"
      DISPLAY_DEVICE="VGA"
      VIRGL="off"
      ;;
    windows)
      CPU="${CPU},hv_time"
      GUEST_TWEAKS="-no-hpet"
      DISPLAY_DEVICE="qxl-vga"
      ;;
    *)
      echo "WARNING! Unrecognised guest OS: ${guest_os}"
      DISPLAY_DEVICE="VGA"
      VIRGL="off"
      ;;
  esac
  echo " - Guest:    ${guest_os^} optimised"

  echo " - Disk:     ${disk_img} (${disk})"
  if [ ! -f "${disk_img}" ]; then
      # If there is no disk image, create a new image.
      mkdir -p "${VMDIR}" 2>/dev/null
      if ! ${QEMU_IMG} create -q -f qcow2 "${disk_img}" "${disk}"; then
        echo "ERROR! Failed to create ${disk_img}"
        exit 1
      fi
      if [ -z "${iso}" ] && [ -z "${img}" ]; then
        echo "ERROR! You haven't specified a .iso or .img image to boot from."
        exit 1
      fi
      echo "             Just created, booting from ${iso}${img}"
  elif [ -e "${disk_img}" ]; then
    # Check there isn't already a process attached to the disk image.
    if ! ${QEMU_IMG} info "${disk_img}" >/dev/null; then
      echo "             Failed to get \"write\" lock. Is another process using the disk?"
      exit 1
    else
      DISK_CURR_SIZE=$(stat -c%s "${disk_img}")
      if [ "${DISK_CURR_SIZE}" -le "${DISK_MIN_SIZE}" ]; then
        echo "             Looks unused, booting from ${iso}${img}"
        if [ -z "${iso}" ] && [ -z "${img}" ]; then
          echo "ERROR! You haven't specified a .iso or .img image to boot from."
          exit 1
        fi
      else
        # If there is a disk image, that appears to have an install
        # then do not boot from the iso/img
        iso=""
        img=""
      fi
    fi
  fi

  # Has the status quo been requested?
  if [ "${STATUS_QUO}" == "-snapshot" ] &&  [ -z "${iso}" ]; then
    echo "             Existing disk state will be preserved, no writes will be committed."
  fi

  if [ -n "${iso}" ] && [ -e "${iso}" ]; then
    echo " - Boot:     ${iso}"
  fi

  if [ -n "${driver_iso}" ] && [ -e "${driver_iso}" ]; then
    echo " - Drivers:  ${driver_iso}"
  fi

  local CORES_VM="1"
  if [ -z "$cpu_cores" ]; then
      local CORES_HOST=""
      CORES_HOST=$(nproc --all)
      if [ "${CORES_HOST}" -ge 32 ]; then
        CORES_VM="16"
      elif [ "${CORES_HOST}" -ge 16 ]; then
        CORES_VM="8"
      elif [ "${CORES_HOST}" -ge 8 ]; then
        CORES_VM="4"
      elif [ "${CORES_HOST}" -ge 4 ]; then
        CORES_VM="2"
      fi
  else
      CORES_VM="$cpu_cores"
  fi
  local SMP="-smp ${CORES_VM},sockets=1,cores=${CORES_VM},threads=1"
  echo " - CPU:      ${CORES_VM} Core(s)"

  local RAM_VM="2G"
  if [ -z "$ram" ]; then
      local RAM_HOST=""
      RAM_HOST=$(free --mega -h | grep Mem | cut -d':' -f2 | cut -d'G' -f1 | sed 's/ //g')
      #Round up - https://github.com/wimpysworld/quickemu/issues/11
      RAM_HOST=$(printf '%.*f\n' 0 "${RAM_HOST}")
      if [ "${RAM_HOST}" -ge 256 ]; then
        RAM_VM="32G"
      elif [ "${RAM_HOST}" -ge 128 ]; then
        RAM_VM="16G"
      elif [ "${RAM_HOST}" -ge 64 ]; then
        RAM_VM="8G"
      elif [ "${RAM_HOST}" -ge 32 ]; then
        RAM_VM="4G"
      elif [ "${RAM_HOST}" -ge 16 ]; then
        RAM_VM="3G"
      fi
  else
      RAM_VM="$ram"
  fi
  echo " - RAM:      ${RAM_VM}"

  local X_RES=1152
  local Y_RES=648
  if [ "${XDG_SESSION_TYPE}" == "x11" ]; then
    local LOWEST_WIDTH=""
    LOWEST_WIDTH=$(xrandr --listmonitors | grep -v Monitors | cut -d' ' -f4 | cut -d'/' -f1 | sort | head -n1)
    if [ "${FULLSCREEN}" ]; then
      X_RES=$(xrandr --listmonitors | grep -v Monitors | cut -d' ' -f4 | cut -d'/' -f1 | sort | head -n1)
      Y_RES=$(xrandr --listmonitors | grep -v Monitors | cut -d' ' -f4 | cut -d'/' -f2 | cut -d'x' -f2 | sort | head -n1)
    elif [ "${LOWEST_WIDTH}" -ge 3840 ]; then
      X_RES=3200
      Y_RES=1800
    elif [ "${LOWEST_WIDTH}" -ge 2560 ]; then
      X_RES=2048
      Y_RES=1152
    elif [ "${LOWEST_WIDTH}" -ge 1920 ]; then
      X_RES=1664
      Y_RES=936
    elif [ "${LOWEST_WIDTH}" -ge 1280 ]; then
      X_RES=1152
      Y_RES=648
    fi
  fi

  # GL is not working with GTK currently
  if [ "${OUTPUT}" == "gtk" ]; then
    GL="off"
    OUTPUT_EXTRA=",grab-on-hover=on,zoom-to-fit=off"
  else
    echo " - Screen:   ${X_RES}x${Y_RES}"
  fi

  if [ "${DISPLAY_DEVICE}" == "qxl-vga" ] || [ "${DISPLAY_DEVICE}" == "VGA" ]; then
    VIDEO="-device ${DISPLAY_DEVICE},vgamem_mb=128,xres=${X_RES},yres=${Y_RES},${FULLSCREEN}"
  else
    VIDEO="-device ${DISPLAY_DEVICE},xres=${X_RES},yres=${Y_RES},${FULLSCREEN}"
  fi

  echo " - Video:    ${DISPLAY_DEVICE}"
  echo " - GL:       ${GL^^}"
  echo " - Virgil3D: ${VIRGL^^}"
  echo " - Display:  ${OUTPUT^^}"

  # Set the hostname of the VM
  local NET="user,hostname=${VMNAME}"

  # If smbd is available, and --no-smb is not set, export $HOME to the guest via samba
  if [[ -e "/usr/sbin/smbd" && -z ${NO_SMB} ]]; then
      NET="${NET},smb=${HOME}"
  fi

  if [[ ${NET} == *"smb"* ]]; then
    echo " - smbd:     ${HOME} will be exported to the guest via smb://10.0.2.4/qemu"
  elif  [[ ${NO_SMB} -eq 1 ]]; then
    echo " - smbd:     ${HOME} will not be exported to the guest. '--no-smb' is set."
  else
    echo " - smbd:     ${HOME} will not be exported to the guest. 'smbd' not found."
  fi

  # Find a free port to expose ssh to the guest
  local PORT=""
  PORT=$(get_port 22220 9)
  if [ -n "${PORT}" ]; then
    NET="${NET},hostfwd=tcp::${PORT}-:22"
    echo " - ssh:      ${PORT}/tcp is connected. Login via 'ssh user@localhost -p ${PORT}'"
  else
    echo " - ssh:      All ports for exposing ssh have been exhausted."
  fi

  # Have any port forwards been requested?
  if (( ${#port_forwards[@]} )); then
    echo " - PORTS:    Port forwards requested:"
    for FORWARD in "${port_forwards[@]}"; do
      HOST_PORT=$(echo "${FORWARD}" | cut -d':' -f1)
      GUEST_PORT=$(echo "${FORWARD}" | cut -d':' -f2)
      echo "              - ${HOST_PORT} => ${GUEST_PORT}"
      NET="${NET},hostfwd=tcp::${HOST_PORT}-:${GUEST_PORT}"
    done
  fi

  # Find a free port for spice
  local SPICE_PORT=""
  SPICE_PORT=$(get_port 5930 9)
  if [ -z "${SPICE_PORT}" ]; then
    echo " - spice:      All spice ports have been exhausted."
  fi

  enable_usb_passthrough

  # Boot the iso image
  if [ "${boot}" == "efi" ] || [ "${boot}" == "uefi" ]; then
    if [ "${guest_os}" == "macos" ]; then
      if [ -z "${img}" ]; then
        ${QEMU} \
          -name ${VMNAME},process=${VMNAME} \
          -enable-kvm -machine q35 ${GUEST_TWEAKS} \
          ${CPU} ${SMP} \
          -m ${RAM_VM} -device virtio-balloon \
          -drive if=pflash,format=raw,readonly=on,file="${EFI_CODE}" \
          -drive if=pflash,format=raw,file="${EFI_VARS}" \
          -drive id=ESP,cache=directsync,aio=native,if=none,format=qcow2,file="${VMDIR}/ESP.qcow2" \
          -device virtio-blk-pci,drive=ESP,scsi=off \
          -drive id=SystemDisk,cache=directsync,aio=native,if=none,format=qcow2,file="${disk_img}" ${STATUS_QUO} \
          -device virtio-blk-pci,drive=SystemDisk,scsi=off \
          ${VIDEO} -display ${OUTPUT},gl=${GL}${OUTPUT_EXTRA} \
          -device usb-ehci,id=usb -device usb-kbd,bus=usb.0 -device usb-tablet,bus=usb.0 ${USB_PASSTHROUGH} \
          -device vmxnet3,netdev=nic -netdev ${NET},id=nic \
          -audiodev pa,id=pa,server=unix:${XDG_RUNTIME_DIR}/pulse/native,out.stream-name=${LAUNCHER}-${VMNAME},in.stream-name=${LAUNCHER}-${VMNAME} \
          -device intel-hda -device hda-duplex,audiodev=pa,mixer=off \
          -rtc base=localtime,clock=host \
          -serial mon:stdio
      else
        ${QEMU} \
          -name ${VMNAME},process=${VMNAME} \
          -enable-kvm -machine q35 ${GUEST_TWEAKS} \
          ${CPU} ${SMP} \
          -m ${RAM_VM} -device virtio-balloon \
          -drive if=pflash,format=raw,readonly=on,file="${EFI_CODE}" \
          -drive if=pflash,format=raw,file="${EFI_VARS}" \
          -drive id=ESP,cache=directsync,aio=native,if=none,format=qcow2,file="${VMDIR}/ESP.qcow2" \
          -device virtio-blk-pci,drive=ESP,scsi=off \
          -drive id=InstallMedia,cache=directsync,aio=native,if=none,format=raw,readonly=on,file="${img}" \
          -device virtio-blk-pci,drive=InstallMedia,scsi=off \
          -drive id=SystemDisk,cache=directsync,aio=native,if=none,format=qcow2,file="${disk_img}" ${STATUS_QUO} \
          -device virtio-blk-pci,drive=SystemDisk,scsi=off \
          ${VIDEO} -display ${OUTPUT},gl=${GL}${OUTPUT_EXTRA} \
          -device usb-ehci,id=usb -device usb-kbd,bus=usb.0 -device usb-tablet,bus=usb.0 ${USB_PASSTHROUGH} \
          -device vmxnet3,netdev=nic -netdev ${NET},id=nic \
          -audiodev pa,id=pa,server=unix:${XDG_RUNTIME_DIR}/pulse/native,out.stream-name=${LAUNCHER}-${VMNAME},in.stream-name=${LAUNCHER}-${VMNAME} \
          -device intel-hda -device hda-duplex,audiodev=pa,mixer=off \
          -rtc base=localtime,clock=host \
          -serial mon:stdio
      fi
    else
      ${QEMU} \
        -name ${VMNAME},process=${VMNAME} \
        -enable-kvm -machine q35 ${GUEST_TWEAKS} \
        ${CPU} ${SMP} \
        -m ${RAM_VM} -device virtio-balloon \
        -drive if=pflash,format=raw,readonly=on,file="${EFI_CODE}" \
        -drive if=pflash,format=raw,file="${EFI_VARS}" \
        -drive media=cdrom,index=0,file="${iso}" \
        -drive media=cdrom,index=1,file="${driver_iso}" \
        -drive if=none,id=drive0,cache=directsync,aio=native,format=qcow2,file="${disk_img}" \
        -device virtio-blk-pci,drive=drive0,scsi=off ${STATUS_QUO} \
        ${VIDEO} -display ${OUTPUT},gl=${GL}${OUTPUT_EXTRA} \
        -device qemu-xhci,id=usb,p2=8,p3=8 -device usb-kbd,bus=usb.0 -device usb-tablet,bus=usb.0 ${USB_PASSTHROUGH} \
        -device virtio-net,netdev=nic -netdev ${NET},id=nic \
        -audiodev pa,id=pa,server=unix:${XDG_RUNTIME_DIR}/pulse/native,out.stream-name=${LAUNCHER}-${VMNAME},in.stream-name=${LAUNCHER}-${VMNAME} \
        -device intel-hda -device hda-duplex,audiodev=pa,mixer=off \
        -rtc base=localtime,clock=host \
        -object rng-random,id=rng0,filename=/dev/urandom \
        -device virtio-rng-pci,rng=rng0 \
        -spice port=${SPICE_PORT},disable-ticketing=on \
        -device virtio-serial-pci \
        -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
        -chardev spicevmc,id=spicechannel0,name=vdagent \
        -serial mon:stdio
    fi
  else
    ${QEMU} \
      -name ${VMNAME},process=${VMNAME} \
      -enable-kvm -machine q35 ${GUEST_TWEAKS} \
      ${CPU} ${SMP} \
      -m ${RAM_VM} -device virtio-balloon \
      -drive media=cdrom,index=0,file="${iso}" \
      -drive media=cdrom,index=1,file="${driver_iso}" \
      -drive if=none,id=drive0,cache=directsync,aio=native,format=qcow2,file="${disk_img}" \
      -device virtio-blk-pci,drive=drive0,scsi=off ${STATUS_QUO} \
      ${VIDEO} -display ${OUTPUT},gl=${GL}${OUTPUT_EXTRA} \
      -device qemu-xhci,id=usb,p2=8,p3=8 -device usb-kbd,bus=usb.0 -device usb-tablet,bus=usb.0 ${USB_PASSTHROUGH} \
      -device virtio-net,netdev=nic -netdev ${NET},id=nic \
      -audiodev pa,id=pa,server=unix:${XDG_RUNTIME_DIR}/pulse/native,out.stream-name=${LAUNCHER}-${VMNAME},in.stream-name=${LAUNCHER}-${VMNAME} \
      -device intel-hda -device hda-duplex,audiodev=pa,mixer=off \
      -rtc base=localtime,clock=host \
      -object rng-random,id=rng0,filename=/dev/urandom \
      -device virtio-rng-pci,rng=rng0 \
      -spice port=${SPICE_PORT},disable-ticketing=on \
      -device virtio-serial-pci \
      -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
      -chardev spicevmc,id=spicechannel0,name=vdagent \
      -serial mon:stdio
  fi
}

function shortcut_create {
  local VMNAME=""
  VMNAME=$(basename "${VM}" .conf)
  local LAUNCHER_DIR=""
  LAUNCHER_DIR="$(dirname "$(realpath "$0")")"
  local filename="/home/${USER}/.local/share/applications/${VMNAME}.desktop"
  cat << EOF > "${filename}"
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=${LAUNCHER_DIR}/${LAUNCHER} --vm ${VM}
Name=${VMNAME}
Icon=/usr/share/icons/hicolor/scalable/apps/qemu.svg
EOF
  echo "Created ${VMNAME}.desktop file"
}

function usage() {
  echo
  echo "Usage"
  echo "  ${LAUNCHER} --vm ubuntu.conf"
  echo
  echo "You can also pass optional parameters"
  echo "  --delete                : Delete the disk image."
  echo "  --shortcut              : Create a desktop shortcut"
  echo "  --snapshot apply <tag>  : Apply/restore a snapshot."
  echo "  --snapshot create <tag> : Create a snapshot."
  echo "  --snapshot delete <tag> : Delete a snapshot."
  echo "  --snapshot info         : Show disk/snapshot info."
  echo "  --status-quo            : Do not commit any changes to disk/snapshot."
  echo "  --fullscreen            : Starts VM in full screen mode"
  echo "  --no-smb                : Do not expose the home directory via SMB."
  exit 1
}

# Lowercase variables are used in the VM config file only
boot="legacy"
guest_os="linux"
img=""
iso=""
driver_iso=""
disk_img=""
disk="64G"
usb_devices=()
ram=""
cpu_cores=""

FULLSCREEN=""
DELETE=0
SNAPSHOT_ACTION=""
SNAPSHOT_TAG=""
STATUS_QUO=""
USB_PASSTHROUGH=""
VM=""
SHORTCUT=0

readonly LAUNCHER=$(basename "${0}")
readonly DISK_MIN_SIZE=$((197632 * 8))

# TODO: Make this run the native architecture binary
QEMU=$(which qemu-system-x86_64)
QEMU_IMG=$(which qemu-img)
if [ ! -e "${QEMU}" ] && [ ! -e "${QEMU_IMG}" ]; then
  echo "ERROR! qemu not found. Please install qemu."
  exit 1
fi

QEMU_VER=$(${QEMU} -version | head -n1 | cut -d' ' -f4 | cut -d'(' -f1 | sed 's/\.//g')
if [ "${QEMU_VER}" -lt 600 ]; then
  echo "ERROR! Qemu 6.0.0 is newer is required, detected $(${QEMU} -version | head -n1 | cut -d' ' -f4 | cut -d'(' -f1)."
  exit 1
fi

# Take command line arguments
if [ $# -lt 1 ]; then
    usage
    exit 0
else
    while [ $# -gt 0 ]; do
        case "${1}" in
          -delete|--delete)
            DELETE=1
            shift;;
          -snapshot|--snapshot)
            SNAPSHOT_ACTION="${2}"
            if [ -z "${SNAPSHOT_ACTION}" ]; then
              echo "ERROR! No snapshot action provided."
              exit 1
            fi
            shift
            SNAPSHOT_TAG="${2}"
            if [ -z "${SNAPSHOT_TAG}" ] && [ "${SNAPSHOT_ACTION}" != "info" ]; then
              echo "ERROR! No snapshot tag provided."
              exit 1
            fi
            shift
            shift;;
          -status-quo|--status-quo)
            STATUS_QUO="-snapshot"
            shift;;
          -fullscreen|--fullscreen)
            FULLSCREEN="--full-screen"
            shift;;
          -vm|--vm)
            VM="${2}"
            shift
            shift;;
          -shortcut|--shortcut)
            SHORTCUT=1
            shift;;
          -no-smb|--no-smb)
            NO_SMB=1
            shift;;
          -h|--h|-help|--help)
            usage;;
          *)
            echo "ERROR! \"${1}\" is not a supported parameter."
            usage;;
        esac
    done
fi

if [ -n "${VM}" ] && [ -e "${VM}" ]; then
  # shellcheck source=/dev/null
  source "${VM}"
  if [ -z "${disk_img}" ]; then
    echo "ERROR! No disk_img defined."
    exit 1
  fi
else
  echo "ERROR! Virtual machine configuration not found."
  usage
fi

if [ ${DELETE} -eq 1 ]; then
  disk_delete
  exit
fi

if [ -n "${SNAPSHOT_ACTION}" ]; then
  case ${SNAPSHOT_ACTION} in
    apply)
      snapshot_apply "${SNAPSHOT_TAG}"
      snapshot_info
      exit;;
    create)
      snapshot_create "${SNAPSHOT_TAG}"
      snapshot_info
      exit;;
    delete)
      snapshot_delete "${SNAPSHOT_TAG}"
      snapshot_info
      exit;;
    info)
      snapshot_info
      exit;;
    *)
      echo "ERROR! \"${SNAPSHOT_ACTION}\" is not a supported snapshot action."
      usage;;
  esac
fi

if [ ${SHORTCUT} -eq 1 ]; then
  shortcut_create
  exit
fi

vm_boot
