#!/bin/zsh

# Import all variables from _variables.zsh
source "$(dirname "$0")/_variables.zsh"

# Parse arguments
arg="$1"

# Determine build type
is_release=0
if [[ "$arg" == "rel" || "$arg" == "release" || "$arg" == "r" ]]; then
    is_release=1
fi

# Adjust project root path
TMP_PROJECT_ROOT="$PROJECT_ROOT_DIR_PATH"
TMP_PROJECT_ROOT="${TMP_PROJECT_ROOT//\/../}"
TMP_PROJECT_ROOT=$(dirname "$TMP_PROJECT_ROOT")
cwd=$(pwd)
t1="$TMP_PROJECT_ROOT/$BUILD_FOLDER_NAME"
InsideBin=0
if [[ "$t1" == "$cwd" ]]; then
    InsideBin=1
fi

# Build using CMake
echo "PROJECT_ROOT_DIR_PATH=$PROJECT_ROOT_DIR_PATH; BIN_DIR_PATH=$BIN_DIR_PATH"
# cd "$BIN_DIR_PATH" || exit 1
if [[ $is_release -eq 0 ]]; then
    cmake -DUSE_DEBUG=ON \
          -DCMAKE_BUILD_TYPE=Debug \
          -S "$PROJECT_ROOT_DIR_PATH" \
          -B "$BIN_DIR_PATH"
else
    cmake -DUSE_DEBUG=OFF \
          -DCMAKE_BUILD_TYPE=Release \
          -S "$PROJECT_ROOT_DIR_PATH" \
          -B "$BIN_DIR_PATH"
fi

cd "$BIN_DIR_PATH" || exit 1
# Build CMake files with Make
make

# Return to the previous directory if not inside the bin directory
if [[ $InsideBin -eq 0 ]]; then
    cd -
fi
