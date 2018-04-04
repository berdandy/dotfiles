#!/bin/sh

function showHelp() {
    echo "Usage: ./rebuild.sh [-hncjetxaR]"
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
    echo '   -R  build for release (warning: may require clean)'
}

CLEAN=false
DRY_RUN=false
BUILDEMSCRIPTEN=false
ONLYEMSCRIPTEN=false
EXTERNAL=false
THOR=false
EXAMPLES=false
RELEASE=Debug

args=`getopt hncjJetxaR $*`
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
            -R)
                RELEASE=Release
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
$EXTERNAL || $THOR || $EXAMPLES || {
    EXTERNAL=true
    THOR=true
    EXAMPLES=true
}

EXEC=
if $DRY_RUN; then
    EXEC=echo 
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
    $EXEC rm -rf $1/build
    $BUILDEMSCRIPTEN && $EXEC rm -rf $1/build-js
}

function buildExternal() {
    pushd $TE
        $ONLYEMSCRIPTEN || {
            echo Building $TE $RELEASE...
            mkdir -p build
            pushd build
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install/external -DCMAKE_BUILD_TYPE=$RELEASE
                $EXEC make && $EXEC make install
            popd
        }

        $BUILDEMSCRIPTEN && {
            echo Building $TE emscripten...
            mkdir -p build-js
            pushd build-js
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/external -DCMAKE_BUILD_TYPE=$RELEASE -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake
                $EXEC make && $EXEC make install
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
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install/thorcc -DCMAKE_PREFIX_PATH="~/install/external/cmake;~/install/tools/cmake" -DCMAKE_BUILD_TYPE=$RELEASE
                $EXEC make && $EXEC make install
            popd
        }

        $BUILDEMSCRIPTEN && {
            echo Building $T emscripten...
            mkdir -p build-js
            pushd build-js
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/thorcc -DCMAKE_PREFIX_PATH="~/install-js/external/cmake;~/install/tools/cmake" -DCMAKE_BUILD_TYPE=$RELEASE -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake
                $EXEC make && $EXEC make install
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
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install/examples -DCMAKE_PREFIX_PATH="~/install/external/cmake;~/install/thorcc/cmake;~/install/tools/cmake" -DCMAKE_MODULE_PATH=~/install/thorcc/cmake -DCMAKE_BUILD_TYPE=$RELEASE
                $EXEC make && $EXEC make install
            popd
        }

        $BUILDEMSCRIPTEN && {
            echo Building $TX emscripten...
            mkdir -p build-js
            pushd build-js
                $EXEC cmake .. -DCMAKE_INSTALL_PREFIX=~/install-js/examples -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake -DCMAKE_PREFIX_PATH="~/install-js/external/cmake;~/install-js/thorcc/cmake;~/install/tools/cmake" -DCMAKE_MODULE_PATH=~/install-js/thorcc/cmake -DCMAKE_BUILD_TYPE=$RELEASE
                $EXEC make
            popd
        }
    popd
}

if $CLEAN; then 
    $EXTERNAL && clean $TE
    $THOR && clean $T
    $EXAMPLES && clean $TX
fi

$EXTERNAL && buildExternal
$THOR && buildThor
$EXAMPLES && buildExamples

