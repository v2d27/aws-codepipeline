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
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: \"${TASK_DEFINITION}\"
        LoadBalancerInfo:
          ContainerName: \"${CONTAINER_NAME}\"
          ContainerPort: ${CONTAINER_PORT}
        PlatformVersion: \"LATEST\"" > $APPSPEC_FILE

# hooks:
#   BeforeAllowTraffic:
#     - location: before_allow_traffic.sh
#       timeout: ${SHIFTTRAFFIC_TIMEOUT}
#       runas: root
#       args:
#         - \"${SHIFTTRAFFIC_TIMEOUT}\"

echo "Updating ${APPSPEC_FILE} content-----------------------------------"
cat $APPSPEC_FILE
echo "-----------------------------------------------------------------"


# version: 0.0
# Resources:
#   - TargetService:
#       Type: AWS::ECS::Service
#       Properties:
#         TaskDefinition: "arn:aws:ecs:us-east-1:111222333444:task-definition/my-task-definition-family-name:1"
#         LoadBalancerInfo:
#           ContainerName: "SampleApplicationName"
#           ContainerPort: 80
# # Optional properties
#         PlatformVersion: "LATEST"
#         NetworkConfiguration:
#           AwsvpcConfiguration:
#             Subnets: ["subnet-1234abcd","subnet-5678abcd"]
#             SecurityGroups: ["sg-12345678"]
#             AssignPublicIp: "ENABLED"
#         CapacityProviderStrategy:
#           - Base: 1
#             CapacityProvider: "FARGATE_SPOT"
#             Weight: 2
#           - Base: 0
#             CapacityProvider: "FARGATE"
#             Weight: 1
