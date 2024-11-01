#!/bin/bash

#######################################################################
# This file is called by appspec.yaml
#######################################################################

# Unify the messages for Bash Shell in CodeDeploy
STATUS_WAIT_MESSAGE="waiting"
STATUS_STOP_MESSAGE="stopaction"
STATUS_CONTINUE_MESSAGE="continueaction"

# BashShell setting
TIMEOUT=$1 # argument timeout from appspec file (seconds)
SLEEP_INTERVAL=7  # Interval to check each 7 seconds
START_TIME=$(date +%s)

send_notification () {
    json_string='{"codedeploy":"send_notification"}'
    aws lambda invoke --function-name codedeploy_confirm_email --payload "$(echo -n "$json_string" | base64)" response.json
    # aws lambda invoke --function-name codedeploy_confirm_email --payload 'eyJjb2RlZGVwbG95IjogInNlbmRfbm90aWZpY2F0aW9uIn0=' response.json
    echo "$(jq -r '.body' response.json)" # Return function value
}

getstatus () {
    json_string='{"codedeploy":"getstatus"}'
    aws lambda invoke --function-name codedeploy_confirm_email --payload "$(echo -n "$json_string" | base64)" response.json
    # aws lambda invoke --function-name codedeploy_confirm_email --payload 'eyJjb2RlZGVwbG95IjogImdldHN0YXR1cyJ9' response.json
    echo "$(jq -r '.body' response.json)" # Return function value
}

# Send email notification
result=$(send_notification)
echo "$result"

# Checking confirmation
while true; do
    status=$(getstatus)
    if [[ "$status" == "$STATUS_WAIT_MESSAGE" ]]; then
        echo "status: ${status}"
    elif [[ "$status" == "$STATUS_CONTINUE_MESSAGE" ]]; then
        echo "User choose: ${status}"
        exit 0  # Exit 0 to continue
    elif [[ "$status" == "$STATUS_STOP_MESSAGE" ]]; then
        echo "User choose: ${status}"
        exit 1  # Exit 1 to cancel pipeline
    fi
    
    # Timeout calculating
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
        echo "Timeout reached. Confirmation email not received."
        sleep 1
        # Sleep more 1 second to raise the default CodeDeploy action_on_timeout event
        # Please check:
        #   aws_codedeploy_deployment_group
        #    .blue_green_deployment_config
        #    .deployment_ready_option
        #    .action_on_timeout = "STOP_DEPLOYMENT" | "CONTINUE_DEPLOYMENT" 
        # in Terraform
        exit 0
    fi
    echo "Waiting for confirmation email... (Elapsed: $ELAPSED_TIME seconds)"
    sleep $SLEEP_INTERVAL  # Wait before checking again
done







