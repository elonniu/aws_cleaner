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

  # Retrieve all dynamodb tables in the current region
  tables=$(aws dynamodb list-tables --query 'TableNames' --output text)

  if [ -z "$tables" ]; then
    continue
  fi

  for table in "${tables[@]}"; do
    echo "$region: Deleting $table_name"
    aws dynamodb delete-table --table-name "$table_name" | jq
  done
  
done
