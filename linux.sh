#!/bin/bash

(cd installer && conan install -p compilers/x64_gcc6_release -u .)
(cd sources/scripts/ && pip3 install -r requirements.txt)
(cd sources/scripts/ && python3 autoComplete.py)


# Build
pushd sources
rm -f ./LibLogicalAccessNet/Generated/*.cs
rm -f ./LibLogicalAccessNet/Generated/Reader/*.cs
rm -f ./LibLogicalAccessNet/Generated/Card/*.cs
rm -f ./LibLogicalAccessNet/Generated/Core/*.cs
rm -f ./LibLogicalAccessNet/Generated/Crypto/*.cs

nice -n -19 swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Generated/Card" -namespace LibLogicalAccess.Card -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_card.i &

nice swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Generated" -namespace LibLogicalAccess -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_data.i &

nice swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Exception" -namespace LibLogicalAccess -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_exception.i &

nice swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Generated" -namespace LibLogicalAccess -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_library.i &

nice -n -19 swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Generated/Reader" -namespace LibLogicalAccess.Reader -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_reader.i &

nice swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Generated" -namespace LibLogicalAccess -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_iks.i &

nice swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Generated/Crypto" -namespace LibLogicalAccess.Crypto -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_crypto.i &

nice swig -csharp -c++ -I"../swig/csharp" -I"../installer/packages/include" -outdir "LibLogicalAccessNet/Generated/Core" -namespace LibLogicalAccess -dllimport LogicalAccessNetNative LibLogicalAccessNet.win32/liblogicalaccess_core.i &

wait
popd
