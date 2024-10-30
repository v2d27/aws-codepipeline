#!/bin/bash

TASK_DEFINITION=$1
CONTAINER_NAME=$2
CONTAINER_PORT=$3

APPSPEC_FILE="appspec.yaml"

echo "version: 0.0
resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: \"${TASK_DEFINITION}\"
        LoadBalancerInfo:
          ContainerName: \"${CONTAINER_NAME}\"
          ContainerPort: ${CONTAINER_PORT}
        PlatformVersion: \"LATEST\"" > $APPSPEC_FILE

echo "Updating ${APPSPEC_FILE} content-----------------------------------"
cat $APPSPEC_FILE
echo "-----------------------------------------------------------------"