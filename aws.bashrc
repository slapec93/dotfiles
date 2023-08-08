#!/bin/bash

##
## AWS Utils
##
function awsprofile() {
  local target_aws_profile="$1"
  local aws_config_file="/Users/$USER/.aws/credentials"
  local profile_names=($(awk -F'[][]' '/^\[/{print $2}' "$aws_config_file"))
  local options=("Quit, keep the current AWS_PROFILE")
  options+=("Quit, unset AWS_PROFILE")

  echo "The current AWS_PROFILE is: '$AWS_PROFILE'"

  # add profile names to options array
  for profile_name in "${profile_names[@]}"
  do
    options+=("$profile_name")
  done

  # prompt user to choose a profile if none given
  if [[ -z "$target_aws_profile" ]]
  then
    echo "Choose one:"
    select profile_name in "${options[@]}"
    do
      if [[ -n "$profile_name" ]]
      then
        target_aws_profile=$profile_name
        break
      fi
    done
  fi

  # handle the "Quit" option
  if [[ "$target_aws_profile" == "Quit, keep the current AWS_PROFILE" ]]
  then
    echo "Exiting, the current profile is: '$AWS_PROFILE'"
    return
  fi

  if [[ "$target_aws_profile" == "Quit, unset AWS_PROFILE" ]]
  then
    unset AWS_PROFILE
    echo "Exiting, unset the current profile."
    return
  fi

  # verify that a profile with given name exists
  if grep -q "^\[$target_aws_profile\]$" "$aws_config_file"
  then
    AWS_PROFILE="$target_aws_profile"
    export AWS_PROFILE
    echo "AWS_PROFILE set to '$AWS_PROFILE'"
  else
    echo "⚠️  A profile with the name '$target_aws_profile' does not exist in '$aws_config_file'"
    echo "Available profiles:"
    printf '%s\n' "${profile_names[@]}"
    return
  fi
}
alias ap=awsprofile

# the first argument is optional and is the uptime of the container in hours, it defaults to 1h
function ecsssh() {
  local container_uptime_in_h="${1:-1}"
  local container_uptime_in_s=$((container_uptime_in_h * 60 * 60 - (5 * 60))) # subtract 5 minutes to be safe since we're billed per started hour

  awsprofile
  clear

  if ! command -v aws &> /dev/null
  then
      echo "aws-cli is not installed. Please run 'brew install awscli'. More info: https://formulae.brew.sh/formula/awscli"
      exit
  fi

  if ! command -v aws &> /dev/null
  then
      echo "aws session manager is not installed. Please run 'brew install --cask session-manager-plugin'. More info: https://formulae.brew.sh/cask/session-manager-plugin"
      exit
  fi

  if ! command -v jq &> /dev/null
  then
      echo "jq is not installed. Please run 'brew install jq'. More info: https://formulae.brew.sh/formula/jq"
      exit
  fi

  # Fetch ECS clusters and ask the user to choose one:
  local cluster_arns=($(aws ecs list-clusters --query 'clusterArns[]' --output text))
  local cluster_names=() # for the options to choose from, just show the name, not the full ARN
  for arn in "${cluster_arns[@]}"; do
    cluster_names+=($(echo "$arn" | awk -F'/' '{print $NF}'))
  done
  echo "Please select a cluster:"
  select chosen_cluster_name in "${cluster_names[@]}"; do break; done
  # find the ARN for the chosen name
  local index=1
  for name in "${cluster_names[@]}"; do
      if [[ "$name" = "${chosen_cluster_name}" ]]; then
          chosen_cluster_arn="${cluster_arns[$index]}"
          break
      fi
      index=$((index + 1))
  done
  echo "You've chosen cluster $chosen_cluster_name"


  # Fetch services of the chosen cluster and ask the user to choose one:
  local services=($(aws ecs list-services --cluster $chosen_cluster_arn --query 'serviceArns[]' --output text))
  local services_names=() # for the options to choose from, just show the name, not the full ARN
  for service in "${services[@]}"; do
    services_names+=($(echo "$service" | awk -F'/' '{print $NF}'))
  done
  echo "Please select a service:"
  select chosen_service in "${services_names[@]}"; do break; done


  # Get the task definition & network configuration of the chosen service:
  local task_def=$(aws ecs describe-services --cluster $chosen_cluster_arn --services $chosen_service --query 'services[0].taskDefinition' --output text)
  local network_config=$(aws ecs describe-services --cluster $chosen_cluster_arn --services $chosen_service --query 'services[0].networkConfiguration' | jq -r .)

  # launch the task, which will run for 56 minutes
  local task_arn=$(aws ecs run-task --cluster $chosen_cluster_arn --task-definition $task_def --count 1 --group 'task:console' --launch-type 'FARGATE' --enable-execute-command --network-configuration "$network_config" --overrides "{\"containerOverrides\": [{\"name\": \"$chosen_service\", \"command\": [\"sleep\", \"$container_uptime_in_s\"]}]}" --query 'tasks[0].taskArn' --output text)

  # Continuously monitor the new task and print out status changes:
  while :
  do
      task_status=$(aws ecs describe-tasks --cluster $chosen_cluster_arn --tasks $task_arn --query 'tasks[0].lastStatus' --output text)
      echo "Task status: $task_status"
      if [ "$task_status" = "RUNNING" ]; then
          sleep 7 # even after it is running, it takes a few seconds until we can connect to it
          echo "Task status: $task_status"
          break
      elif [ "$task_status" = "STOPPED" ]; then
          reason=$(aws ecs describe-tasks --cluster $chosen_cluster_arn --tasks $task_arn --query 'tasks[0].stoppedReason' --output text)
          stopCode=$(aws ecs describe-tasks --cluster $chosen_cluster_arn --tasks $task_arn --query 'tasks[0].stopCode' --output text)
          echo "Stopped Reason: $reason"
          echo "Stop Code: $stopCode"
          exit
      fi
      sleep 5
  done

  # start SSH session
  echo "" # force new line
  echo "Trying to start the SSH session."
  echo "Sometimes there is a timeout in the first few seconds."
  echo "In case of an error, copy paste the following command and try again:"
  echo "" # force new line
  echo "" # force new line
  echo "aws ecs execute-command --cluster $chosen_cluster_arn --task $task_arn --container $chosen_service --interactive --command '/bin/sh'"
  echo "" # force new line

  # the container will be up until time-current plus container_uptime_in_s
  echo "The container will be up until $(date -v +${container_uptime_in_s}S)"

  # Sometimes, it takes even more time for the container to be ready, in such cases, simply retry a few times.
  # worst case, we have to continue manually using the printed command.
  for i in {1..3}
  do
    aws ecs execute-command --cluster $chosen_cluster_arn --task $task_arn --container $chosen_service --interactive --command '/bin/sh' \
      && break \
      || sleep 5
  done
}
