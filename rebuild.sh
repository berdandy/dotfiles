#!/bin/sh

function showHelp() {
    echo "Usage: ./rebuild.sh [-hncjetxaRAV]"
    echo ' where'
    echo '   -h  show help'
    echo '   -n  dry run'
    echo '   -c  clean'
    echo '   -j  build emscripten targets as well'
    echo '   -J  build ONLY emscripten'
    echo '   -e  rebuild thorcc-external'
    echo '   -t  rebuild thorcc'
    echo '   -x  rebuild thorcc-examples'
    echo '   -a  rebuild all (default)'
    echo '   -X  rebuild nothing (if you only want to clean, or link assets)'
    echo '   -R  build for release (warning: may require clean)'
    echo '   -A  link assets to Examples build locations'
    echo '   -V  build verbose cmake output'
}

CLEAN=false
DRY_RUN=false
BUILDEMSCRIPTEN=false
ONLYEMSCRIPTEN=false
VERBOSE_CMAKE=false
EXTERNAL=false
THOR=false
EXAMPLES=false
NODEFAULTBUILD=false
ASSETS=false
RELEASE=Debug
MAKECMD="make -j4"

args=`getopt hncjJetxaXRAV $*`
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
                BUILDEMSCRIPTEN=true
                shift;;
            -J)
                ONLYEMSCRIPTEN=true
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
            -X)
                NODEFAULTBUILD=true
                shift;;
            -R)
                RELEASE=Release
                shift;;
            -A)
                ASSETS=true
                shift;;
            -V)
                VERBOSE_CMAKE=true
                shift;;
            --)
                shift; break;;
       esac
done

# only-emscripten implies emscripten
$ONLYEMSCRIPTEN && {
    BUILDEMSCRIPTEN=true
}

# if no options set, handle default of build-all
$EXTERNAL || $THOR || $EXAMPLES || $NODEFAULTBUILD || {
    EXTERNAL=true
    THOR=true
    EXAMPLES=true
}

EXEC=
if $DRY_RUN; then
    EXEC=echo 
fi

CMAKEOPTIONS=
if $VERBOSE_CMAKE; then
    CMAKEOPTIONS="$CMAKEOPTIONS -DCMAKE_VERBOSE_MAKEFILE=ON"
fi

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

function clean() {
    echo Cleaning $1...
    $ONLYEMSCRIPTEN || $EXEC rm -rf $1/build
    $BUILDEMSCRIPTEN && $EXEC rm -rf $1/build-js
}

function cleanInstall() {
    echo Cleaning $1...
    $ONLYEMSCRIPTEN || $EXEC rm -rf ~/install/$1
    $BUILDEMSCRIPTEN && $EXEC rm -rf ~/install-js/$1
}

function buildExternal() {
    pushd $TE
        $ONLYEMSCRIPTEN || {
            echo Building $TE $RELEASE...
            mkdir -p build
            pushd build
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install/external -DCMAKE_BUILD_TYPE=$RELEASE $CMAKEOPTIONS
                $EXEC $MAKECMD && $EXEC $MAKECMD install
            popd
        }

        $BUILDEMSCRIPTEN && {
            echo Building $TE emscripten...
            mkdir -p build-js
            pushd build-js
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/external -DCMAKE_BUILD_TYPE=$RELEASE -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake $CMAKEOPTIONS
                $EXEC $MAKECMD && $EXEC $MAKECMD install
            popd
        }
    popd
}

function buildThor() {
    pushd $T
        $ONLYEMSCRIPTEN || {
            echo Building $T $RELEASE...
            mkdir -p build
            pushd build
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install/thorcc -DCMAKE_PREFIX_PATH="~/install/external/cmake;~/install/tools/cmake" -DCMAKE_BUILD_TYPE=$RELEASE $CMAKEOPTIONS
                $EXEC $MAKECMD && $EXEC $MAKECMD install
            popd
        }

        $BUILDEMSCRIPTEN && {
            echo Building $T emscripten...
            mkdir -p build-js
            pushd build-js
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/thorcc -DCMAKE_PREFIX_PATH="~/install-js/external/cmake;~/install/tools/cmake" -DCMAKE_BUILD_TYPE=$RELEASE -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake $CMAKEOPTIONS
                $EXEC $MAKECMD && $EXEC $MAKECMD install
            popd
        }
    popd
}

function buildExamples() {
    pushd $TX
        $ONLYEMSCRIPTEN || {
            echo Building $TX $RELEASE...
            mkdir -p build
            pushd build
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install/examples -DCMAKE_PREFIX_PATH="~/install/external/cmake;~/install/thorcc/cmake;~/install/tools/cmake" -DCMAKE_MODULE_PATH=~/install/thorcc/cmake -DCMAKE_BUILD_TYPE=$RELEASE $CMAKEOPTIONS
                $EXEC $MAKECMD && $EXEC $MAKECMD install
            popd
        }

        $BUILDEMSCRIPTEN && {
            echo Building $TX emscripten...
            mkdir -p build-js
            pushd build-js
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/examples -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake -DCMAKE_PREFIX_PATH="~/install-js/external/cmake;~/install-js/thorcc/cmake;~/install/tools/cmake" -DCMAKE_MODULE_PATH=~/install-js/thorcc/cmake -DCMAKE_BUILD_TYPE=$RELEASE $CMAKEOPTIONS
                $EXEC $MAKECMD
            popd
        }
    popd
}

function linkAssets() {
    pushd $TX
        mkdir -p $1/editor
        $EXEC ln -sf $TX/tools/config.js $TX/$1/editor/
        $EXEC ln -sf $TX/assets $TX/$1/editor/assets
        $EXEC ln -sf $TX/editorAssets $TX/$1/editor/editorAssets
        mkdir -p $1/game
        $EXEC ln -sf $TX/tools/config.js $TX/$1/game/
        $EXEC ln -sf $TX/assets $TX/$1/game/assets
    popd
}

if $CLEAN; then 
    $EXTERNAL && clean $TE
    $EXTERNAL && cleanInstall external
    $THOR && clean $T
    $THOR && cleanInstall thorcc
    $EXAMPLES && clean $TX
    $EXAMPLES && cleanInstall examples
fi

$EXTERNAL && buildExternal
$THOR && buildThor
$EXAMPLES && buildExamples
$ASSETS && linkAssets build
$ASSETS && linkAssets build-js

