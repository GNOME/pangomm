#!/bin/sh -e

# External command, intended to be called with meson.add_dist_script() in meson.build.
# meson.add_dist_script() can't call a scripts that's not commited to git.
# This script shall be commited. It can be used for calling other non-commited scripts.

cmd="$1"
shift
"$cmd" "$@"
