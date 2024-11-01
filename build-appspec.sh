#!/bin/bash

#################################################################
# This file called by buildspec.yaml
#################################################################

TASK_DEFINITION=$1
CONTAINER_NAME=$2
CONTAINER_PORT=$3
SHIFTTRAFFIC_TIMEOUT=$4

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
        PlatformVersion: \"LATEST\"
hooks:
  BeforeAllowTraffic:
    - location: before_allow_traffic.sh
      timeout: ${SHIFTTRAFFIC_TIMEOUT}
      runas: root
      args:
        - ${SHIFTTRAFFIC_TIMEOUT}
" > $APPSPEC_FILE

echo "Updating ${APPSPEC_FILE} content-----------------------------------"
cat $APPSPEC_FILE
echo "-----------------------------------------------------------------"