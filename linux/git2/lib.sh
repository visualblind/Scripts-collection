
move_files() {
	basefile="$1"
	targetfile="$2"

	if test -f "${basefile}" || test -d "${basefile}"
	then
		mv "${basefile}" "${targetfile}"
	fi
}

# exchange files
exchange_files() {
	basefile="$1"
	append_old="$2"
	append_new="$3"
	move_files "${basefile}" "${basefile}_${append_old}"
	move_files "${basefile}_${append_new}" "${basefile}"
}


# move git dependent files
move_git_files() {
	gitfile="$1"
	append=`echo "${GITTWO_DIRNAME}" | sed -e 's/\.//g'`
	exchange_files "${gitfile}" "git1" "${append}"
}
# move back the git dependent files:
move_git_files_back() {
	gitfile="$1"
	append=`echo "${GITTWO_DIRNAME}" | sed -e 's/\.//g'`
	exchange_files "${gitfile}" "${append}" "git1"
}

create_exclude() {
	gitcmd="$1"
	gitdir="$2"
	append="$3"

	# exclude git files in git two:
	echo "/${GITTWO_DIRNAME}" >${gitdir}/info/exclude
	echo "/.git2_is_active" >>${gitdir}/info/exclude
	if test -f "${gitdir}/info/exclude-extra"
	then
		cat "${gitdir}/info/exclude-extra" \
			>>${gitdir}/info/exclude
	fi
	"${gitcmd}" ls-files 2>/dev/null | \
		sed -e "s/.gitignore/.gitignore_${append}/g" | \
		sed -e "s/.gitattributes/.gitattributes_${append}/g" | \
		sed -e 's|^|/|' \
		>>${gitdir}/info/exclude
}

git2_setup() {
	if test "x${GITTWO_ACTIVE}" = "x0"
	then
		if test -d "${GITTWO_DIR}"
		then
			# block for other git2 instances:
			touch -- "${GITTWO_BASE}.git2_is_active"

			create_exclude git "${GITTWO_DIR}" "git1"

			# move git dependent files
			move_git_files "${GITTWO_BASE}.gitignore"
			move_git_files "${GITTWO_BASE}.gitattributes"
		else
			GITTWO_ACTIVE=1
		fi
	fi
}

git2_cleanup() {
	if test "x${GITTWO_ACTIVE}" = "x0"
	then
		GITTWO_ACTIVE=1
		# move back the git dependent files:
		move_git_files_back "${GITTWO_BASE}.gitignore"
		move_git_files_back "${GITTWO_BASE}.gitattributes"
		rm -- "${GITTWO_BASE}.git2_is_active"
	fi
}

git2_search_base_dir() {
	# find gittwo base dir:
	GITTWO_BASE=""
	ldir=
	while test \! -d "${ldir}${GITTWO_DIRNAME}"
	do
		ldir="${ldir}../"
		cd "${ldir}" >/dev/null
		GITTWO_BASE="`pwd`"
		cd - >/dev/null
		if test "x${GITTWO_BASE}" = "x/" && \
				test \! -d "/${GITTWO_DIRNAME}"
		then
			#echo "warning: Not a git repository (or any of 
			# the parent directories): ${GITTWO_DIRNAME}"
			GITTWO_BASE=""
			break
		else
			GITTWO_BASE="${GITTWO_BASE}/"
		fi
	done
	export GITTWO_BASE
	export GITTWO_DIRNAME
	export GITTWO_DIR="${GITTWO_BASE}${GITTWO_DIRNAME}"
}


if test -z "${GITTWO_DIRNAME}"
then
	GITTWO_DIRNAME=.git2
fi

