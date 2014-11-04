#!/bin/sh
vimdir=$(dirname "$(readlink -f "$0")")
VIMRUNTIME="$vimdir/runtime"
export VIMRUNTIME
exec "$vimdir/vim" "$@"
