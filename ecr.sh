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

  # Retrieve all ecr repositories in the current region
  repositories=($(aws ecr describe-repositories --query "repositories[].repositoryName" --output text))

  if [ -z "$repositories" ]; then
    continue
  fi

  for repositoriy in "${repositories[@]}"; do
    echo "$region: Deleting $repository_name"
    aws ecr delete-repository --repository-name $repository_name --force | jq
  done

done

