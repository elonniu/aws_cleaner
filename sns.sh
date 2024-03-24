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

  # Retrieve all sns topics in the current region
  topics=$(aws sns list-topics --query 'Topics[].TopicArn' --output text)

  if [ -z "$topics" ]; then
    continue
  fi

  for topic in "${topics[@]}"; do
    echo "$region: Deleting $topic_arn"
    aws sns delete-topic --topic-arn "$topic_arn" | jq
  done

done
