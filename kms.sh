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
    echo "Skip region: $region"
    continue
  fi

  keys=$(aws kms list-keys --query 'Keys[].KeyId' --output text)

  for KeyId in $keys
  do
    echo "$region: Deletschedule-key-deletioning $KeyId"
    aws kms schedule-key-deletion --key-id $KeyId --pending-window-in-days 7 | jq
  done

done
