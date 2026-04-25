#!/usr/bin/env bash
# helper.sh - common functions for DSV A15 framework patcher
# Usage: source ./helper.sh
# Exposes: init_env, ensure_tools, decompile_jar, recompile_jar, backup_original_jar,
#          add_static_return_patch, patch_return_void_method,
#          modify_invoke_custom_methods, create_magisk_module, find_smali_method_file
#
# Designed for use in CI / GitHub workflow. Functions accept explicit decompile_dir
# where appropriate so scripts can be called against multiple jars.

# Uncomment to make the script fail fast during development
# set -o errexit -o nounset -o pipefail

# Source modular scripts
work_dir=$(pwd)
source "$work_dir/bin/shPlugin/COREPATCH/core/logging.sh"
source "$work_dir/bin/shPlugin/COREPATCH/core/tools.sh"
source "$work_dir/bin/shPlugin/COREPATCH/core/apk_ops.sh"
source "$work_dir/bin/shPlugin/COREPATCH/core/patching.sh"