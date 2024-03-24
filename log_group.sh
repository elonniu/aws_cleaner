#!/bin/bash

# if PROTECT_REGION is not set
if [ -z "$PROTECT_REGION" ]; then
  echo "PROTECT_REGION is not set. Exiting..."
  exit 1
fi

# First, retrieve all regions
all_regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

for region in $all_regions; do

  export AWS_DEFAULT_REGION=$region
  export AWS_REGION=$region

  if [ "$region" = "$PROTECT_REGION" ]; then
    continue
  fi

  echo "Checking region $region"

  log_groups=$(aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output text)

  for log_group_name in $log_groups
  do
    echo "$region: Deleting $log_group_name"
    aws logs delete-log-group --log-group-name $log_group_name
  done

done
