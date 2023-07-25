#!/usr/bin/env bash
source /fsx/OpenFOAM/OpenFOAM-v2212/etc/bashrc
cd "${0%/*}" || exit                                # Run from this directory
. ${WM_PROJECT_DIR:?}/bin/tools/RunFunctions        # Tutorial run functions
#------------------------------------------------------------------------------
casename=$(basename $PWD)
didUpload=false
if test -z url; then
    dudUpload=true
fi
touch case.foam
pvpython renderResults.py $casename
convert  $casename.png -transparent white -trim -resize 90% $casename.png
case didUpload in
    (true) cat url;;
    (*) curl -s --location --request POST "https://api.imgbb.com/1/upload?expiration=600&key=${IMGBB_API_KEY}"\
    --form "image=@./$casename.png" | jq .data.url | tee url;;
esac
