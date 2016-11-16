#!/bin/sh
set -e

STACK_NAME="test-lambda"
REGION="ap-southeast-2"
BUCKETNAME="test"
FILENAME="diagnostic/endpoint.end"
FILECONTENT="OK"
SCHEDULEEXPRESSION="rate(1 day)"

if aws cloudformation describe-stacks --stack-name "$STACK_NAME" --region "$REGION"; then
  echo "Updating Stack \"$STACK_NAME\" in region \"$REGION\""
  COMMAND=update-stack
else
  echo "Creating Stack \"$STACK_NAME\" in region \"$REGION\""
  COMMAND=create-stack
fi

aws cloudformation "$COMMAND" --stack-name "$STACK_NAME" \
--template-body "file://lambda.json" --parameters "\
[{\"ParameterKey\":\"BucketName\",\"ParameterValue\":\"$BUCKETNAME\"},\
{\"ParameterKey\":\"FileName\",\"ParameterValue\":\"$FILENAME\"},\
{\"ParameterKey\":\"FileContent\",\"ParameterValue\":\"$FILECONTENT\"},\
{\"ParameterKey\":\"ScheduleExpression\",\"ParameterValue\":\"$SCHEDULEEXPRESSION\"}]" \
--capabilities CAPABILITY_IAM --region "$REGION"
