#!/bin/bash
# This script can be executed by the bash that's packaged with git for Windows.
cd `dirname "$0"` || exit $?
if [ ! -e node_modules ]; then
    npm install # https://nodejs.org
    npm install --global pkg@4.2.6 # https://github.com/zeit/pkg
fi
pkg.cmd -t node4-win-x86 bin/Outpost_Forms.js || exit $?
mv Outpost_Forms.exe bin/ || exit $?

if [ ! -e pack-it-forms/.git ]; then # Don't delete an experimental copy.
    rm -rf pack-it-forms
fi
if [ ! -e pack-it-forms ]; then
    git clone "https://github.com/jmkristian/pack-it-forms.git" || exit $?
    (cd pack-it-forms && git checkout vSCCo.10)
    rm -rf pack-it-forms/.git*
fi

rm -rf built; mkdir -p built/addons
node bin/Outpost_Forms.js build Los_Altos "bin\\LAARES_Forms.exe"
"C:/Program Files (x86)/NSIS/makensis.exe" setup-LAARES.nsi || exit $?

rm -rf built; mkdir -p built/addons
node bin/Outpost_Forms.js build HTTP "bin\\HTTP_server.exe"
"C:/Program Files (x86)/NSIS/makensis.exe" setup-HTTP.nsi || exit $?

rm -rf built; mkdir -p built/addons
node bin/Outpost_Forms.js build Enhanced "bin\\SCCoPIFO.exe"
"C:/Program Files (x86)/NSIS/makensis.exe" setup-SCCo.nsi || exit $?
"C:/Program Files (x86)/NSIS/makensis.exe" setup-SCCo_private.nsi || exit $?
