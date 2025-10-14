#!/bin/bash

ARG_JOBS=1
ARG_BUILDDIR=''
ARG_SKIP=0

read -rd '' CLANG_CONFIG_CONTENT << EOF
Checks: >
  -*,
  modernize-use-equals-default,
EOF

set -eu

log() {
	printf '%s\n' "$1"
}
err() {
	printf '%s\n' "$1" 1>&2
}

usage() {
	cat <<-EOF
	usage: fix_clang_tidy.sh [OPTION..] [build_dir]
	options:
	  -j[jobs]        number of threads (default: 1)
	EOF
}

parse_args() {
	while true
	do
		[[ "$#" -eq 0 ]] && break
		arg="$1"
		shift

		if [ "${arg::2}" = -j ]
		then
			ARG_JOBS="${arg:2}"
			if [[ ! "$ARG_JOBS" =~ ^[0-9]+$ ]]
			then
				err "error: jobs have to be numeric"
				exit 1
			fi
		elif [[ "${arg::1}" = - ]]
		then
			if [ "$arg" = "-h" ] && [ "$arg" == --help ]
			then
				usage
				exit 0
			elif [ "$arg" = --skip ]
			then
				ARG_SKIP="$1"
				shift
			else
				err "error: invalid argument '$arg'"
				exit 1
			fi
		elif [ "$ARG_BUILDDIR" = "" ]
		then
			ARG_BUILDDIR="$arg"
		else
			err "error: unexpected argument '$arg'"
			exit 1
		fi
	done
}

parse_args "$@"

build_dir="build-tidy-context"
if [ "$ARG_BUILDDIR" != "" ]
then
	build_dir="$ARG_BUILDDIR"
fi
if [ ! -d "$build_dir" ]
then
	mkdir "$build_dir"
	cd "$build_dir"
	cmake -DCMAKE_BUILD_TYPE=Debug -DDOWNLOAD_GTEST=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..
	make -j"$ARG_JOBS"
	cd ..
fi
# generated code hack
# https://github.com/ddnet/ddnet/issues/8152
mkdir -p src/game/generated
for generated_file in client_data.h client_data7.h
do
	cp "$build_dir/src/game/generated/$generated_file" src/game/generated/
done

if ! CLANG_CONFIG_FILE="$(mktemp /tmp/clang-tidy-XXXXX.yaml)"
then
	err "mktemp failed"
	exit 1
fi
printf '%s' "$CLANG_CONFIG_CONTENT" > "$CLANG_CONFIG_FILE"

restore() {
	log "cleaning up ..."
	rm "$CLANG_CONFIG_FILE"
}
trap restore EXIT

list_code_files() {
	find ./src/ \
		-type f \
		-not \( \
			-path './src/game/mapitems_ex_types.h' -o \
			-path './src/engine/shared/protocol_ex_msgs.h' -o \
			-path './src/engine/shared/teehistorian_ex_chunks.h' -o \
			-path './src/game/client/components/local_server.h' -o \
			-path './src/game/client/components/items.h' -o \
			-path './src/game/client/components/nameplates.h' -o \
			-path './src/game/mapbugs_list.h' -o \
			-path './src/game/tuning.h' -o \
			-path './src/engine/shared/config_variables.h' -o \
			-path './src/engine/shared/websockets.h' -o \
			-path './src/engine/client/keynames.h' -o \
			-path './src/rust-bridge/*' -o \
			-path './src/game/generated/*' -o \
			-path './src/test/*' -o \
			-path './src/android/*' -o \
			-path './src/base/*' -o \
			-path './src/engine/external/*' -o \
			-path './src/tools/*' \) \
		\( \
			-name '*.cpp' -o \
			-name '*.c' -o \
			-name '*.h' \
		\)
}

total="$(list_code_files | wc -l)"

check_file() {
	local source_file="$1"
	local build_dir="$2"
	if ! clang-tidy --fix --config-file="$CLANG_CONFIG_FILE" "$source_file" -p "$build_dir" 2>/dev/null
	then
		# show stderr on error
		clang-tidy --fix --config-file="$CLANG_CONFIG_FILE" "$source_file" -p "$build_dir" || true
	fi
}

export -f check_file

single_thread() {
	local current=0
	list_code_files | while read -r source_file
		do
			current="$((current+1))"
			[ "$current" -lt "$ARG_SKIP" ] && continue

			log "[$current/$total] $source_file"
			check_file "$source_file" "$build_dir"
		done
}

multi_thread_bash() {
	local current=0
	list_code_files | while read -r source_file
		do
			current="$((current+1))"
			[ "$current" -lt "$ARG_SKIP" ] && continue

			log "[$current/$total] $source_file"
			while [ "$(jobs | wc -l)" -ge "$ARG_JOBS" ]
			do
				sleep 0.5
			done
			check_file "$source_file" "$build_dir" &
		done
}

multi_thread_gnu_parallel() {
	if [ ! -x "$(command -v parallel)" ]
	then
		err "error: gnu parallel is not installed"
		exit 1
	fi
	list_code_files |
		parallel \
		--jobs "$ARG_JOBS" \
		--halt soon,fail=1 \
		--eta \
		"check_file {} $build_dir"
}

if [ "$ARG_JOBS" -gt 1 ]
then
	if parallel --version 2>/dev/null | grep -q 'GNU parallel'
	then
		multi_thread_gnu_parallel
	else
		multi_thread_bash
	fi
else
	single_thread
fi
