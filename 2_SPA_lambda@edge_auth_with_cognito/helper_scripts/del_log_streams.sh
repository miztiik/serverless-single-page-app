#!/usr/bin/env bash
#set -e
set -x

#################################################
#         SET ENVIRONMENT VARAIABLES            #
#################################################


function del_log_group(){
aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output table --region "$REGION" \
 | awk '{print $2}' \
 | grep -v $LOG_GROUP \
 | grep -v '^$' \
 | while read x; \
    do aws logs delete-log-group --log-group-name --region "${REGION}" $x; \
   done

exit
}

function del_log_streams(){
    LOG_GROUP_NAME=${1:?log group name is not set}
    REGION=${2:?Region not set}
    LOG_STREAMS=$(
        aws logs describe-log-streams \
            --log-group-name ${LOG_GROUP_NAME} \
            --query 'logStreams[*].logStreamName' \
            --output table \
            --region ${REGION} |
            awk '{print $2}' |
            grep -v ^$ |
            grep -v DescribeLogStreams
    )

    for name in ${LOG_STREAMS}; do
        printf "Delete stream ${name}"
        aws logs delete-log-stream --log-group-name ${LOG_GROUP_NAME} --log-stream-name ${name} --region ${REGION} && echo OK || echo Fail
    done
}


# Begin Log Steam Deletion
# del_log_streams

del_log_streams /aws/lambda/us-east-1.serverless-single-page-app-001-dev-viewerReq eu-central-1
del_log_streams /aws/lambda/us-east-1.serverless-single-page-app-001-dev-originResp eu-central-1
del_log_streams /aws/lambda/us-east-1.serverless-single-page-app-001-dev-viewerReq eu-west-2
del_log_streams /aws/lambda/us-east-1.serverless-single-page-app-001-dev-originResp eu-west-2
del_log_streams /aws/lambda/us-east-1.serverless-single-page-app-001-dev-viewerReq eu-west-1
del_log_streams /aws/lambda/us-east-1.serverless-single-page-app-001-dev-originResp eu-west-1