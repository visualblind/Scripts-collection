# Parse command-line options
TEMPDIR="/mnt/pool0/p0ds0smb/temp/ffmpeg"
WORKDIR="$TEMPDIR/working"

# Option strings
SHORT=d:w:
LONG=directory:,workdir:

# read the options
OPTS=$(getopt --options $SHORT --long $LONG --name "$0" -- "$@")

if [ $? != 0 ] ; then echo "Failed to parse options...exiting." >&2 ; exit 1 ; fi

eval set -- "$OPTS"

# set initial values
#TEMPDIR="/mnt/pool0/p0ds0smb/temp/ffmpeg"
#WORKDIR="$TEMPDIR/working"

# extract options and their arguments into variables.
#while true ; do
while [ "$1" != "" ]; do
  case "$1" in
    -d | --directory ) shift
      TEMPDIR="${1:-$TEMPDIR}"
      WORKDIR="$TEMPDIR/working"
      ;;
    -w | --workdir ) shift
      WORKDIR="$TEMPDIR/$1"
      ;;
    -- )
      break
      ;;
    * )
      echo "Internal error!"
      exit 1
      ;;
  esac
  shift
done

# Print the variables
echo "TEMPDIR = $TEMPDIR"
echo "WORKDIR = $WORKDIR"
