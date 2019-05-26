#!/bin/bash
set -e
#set -x

#----- Change these parameters to suit your environment -----#
AWS_PROFILE="default"
AWS_REGION="us-east-1"
o_resp_fn="serverless-single-page-app-001-Dev-originResp"
v_req_fn="serverless-single-page-app-001--Dev-viewerReq"

#----- End of user parameters  -----#

function bump_lambda_ver(){
    aws lambda update-alias --function-name ${o_resp_fn} --name live --function-version "$1"
    aws lambda update-alias --function-name ${v_req_fn} --name live --function-version "$1"

    exit
}



if [ $# -eq 0 ]; then
 echo -e "Lambda version missing"
 exit
  else
    bump_lambda_ver $1
fi
