#!/bin/sh

function showHelp() {
    echo "Usage: ./rebuild.sh [-hncjetxaR]"
    echo ' where'
    echo '   -h  show help'
    echo '   -n  dry run'
    echo '   -c  clean'
    echo '   -j  build emscripten targets as well'
    echo '   -e  rebuild thorcc-external'
    echo '   -t  rebuild thorcc'
    echo '   -x  rebuild thorcc-examples'
    echo '   -a  rebuild all (default)'
    echo '   -R  build for release (warning: may require clean)'
}

CLEAN=false
DRY_RUN=false
EMSCRIPTEN=false
EXTERNAL=false
THOR=false
EXAMPLES=false
RELEASE=Debug

args=`getopt hncjetxaR $*`
if [ $? != 0 ]; then
    showHelp
    exit 2
fi
set -- $args
for i; do
       case "$i"
       in
            -h)
                showHelp
                exit 2
                break;;
            -n)
                DRY_RUN=true
                shift;;
            -c)
                CLEAN=true
                shift;;
            -j)
                EMSCRIPTEN=true
                shift;;
            -e)
                EXTERNAL=true
                shift;;
            -t)
                THOR=true
                shift;;
            -x)
                EXAMPLES=true
                shift;;
            -a)
                EXTERNAL=true
                THOR=true
                EXAMPLES=true
                shift;;
            -R)
                RELEASE=Release
                shift;;
            --)
                shift; break;;
       esac
done

# handle default of build-all
$EXTERNAL || $THOR || $EXAMPLES || {
    EXTERNAL=true
    THOR=true
    EXAMPLES=true
}

if [ ! -d $T ] || [ ! -d $TE ] || [ ! -d $TX ]; then
    echo Environment variables T, TE, and TX must be defined and point to git clone folders:
    echo ' TE : ThorCC-External'
    echo ' T  : ThorCC'
    echo ' TX : ThorCC-Examples'
    exit 1
fi

if [ ! -x ~/install/tools/bin/ThorTouch ]; then
    echo ThorCC tools not installed. Expected ~/install/tools to contain pre-built tools from Jenkins.
    exit 2
fi

if [ $HELP ]; then
    echo Usage $0 '[clean]'
    echo '- builds external, thorcc, and thorcc-examples'
    echo '- if 'clean' is specified, build directories are trashed before'
    echo '  rebuilding, otherwise existing cmake is retained'
    exit 0
fi

function cleanExternal() {
    echo Cleaning $TE...
    $DRY_RUN && return
    rm -rf $TE/build
    rm -rf $TE/build-js
}

function buildExternal() {
    echo Building $TE...
    $DRY_RUN && return
    pushd $TE
        mkdir -p build
        pushd build
            cmake .. -DCMAKE_INSTALL_PREFIX=~/install/external -DCMAKE_BUILD_TYPE=$RELEASE
            make && make install
        popd

        if $EMSCRIPTEN; then
            echo Building $TE emscripten...
            mkdir -p build-js
            pushd build-js
                cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/external -DCMAKE_BUILD_TYPE=$RELEASE -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake
                make && make install
            popd
        fi
    popd
}

function cleanThor() {
    echo Cleaning $T...
    $DRY_RUN && return
    rm -rf $T/build
    rm -rf $T/build-js
}

function buildThor() {
    echo Building $T...
    $DRY_RUN && return
    pushd $T
        mkdir -p build
        pushd build
            cmake .. -DCMAKE_INSTALL_PREFIX=~/install/thorcc -DCMAKE_PREFIX_PATH="~/install/external/cmake;~/install/tools/cmake" -DCMAKE_BUILD_TYPE=$RELEASE
            make && make install
        popd

        if $EMSCRIPTEN; then
            echo Building $T emscripten...
            mkdir -p build-js
            pushd build-js
                cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/thorcc -DCMAKE_PREFIX_PATH="~/install-js/external/cmake;~/install/tools/cmake" -DCMAKE_BUILD_TYPE=$RELEASE -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake
                make && make install
            popd
        fi
    popd
}

function cleanExamples() {
    echo Cleaning $TX...
    $DRY_RUN && return
    rm -rf $TX/build
    rm -rf $TX/build-js
}

function buildExamples() {
    echo Building $TX...
    $DRY_RUN && return
    pushd $TX
        mkdir -p build
        pushd build
            cmake .. -DCMAKE_INSTALL_PREFIX=~/install/examples -DCMAKE_PREFIX_PATH="~/install/external/cmake;~/install/thorcc/cmake;~/install/tools/cmake" -DCMAKE_MODULE_PATH=~/install/thorcc/cmake -DCMAKE_BUILD_TYPE=$RELEASE
            make && make install
        popd

        if $EMSCRIPTEN; then
            echo Building $TX emscripten...
            mkdir -p build-js
            pushd build-js
                cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/examples -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake -DCMAKE_PREFIX_PATH="~/install-js/external/cmake;~/install-js/thorcc/cmake;~/install/tools/cmake" -DCMAKE_MODULE_PATH=~/install-js/thorcc/cmake -DCMAKE_BUILD_TYPE=$RELEASE
                make
            popd
        fi
    popd
}

if $CLEAN; then 
    $EXTERNAL && cleanExternal
    $THOR && cleanThor
    $EXAMPLES && cleanExamples
fi

$EXTERNAL && buildExternal
$THOR && buildThor
$EXAMPLES && buildExamples

