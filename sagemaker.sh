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

    echo "Working on region $region"

    # delete all sagemaker endpoint
    for endpoint in $(aws sagemaker list-endpoints --query "Endpoints[*].EndpointName" --output text); do
        aws sagemaker delete-endpoint --endpoint-name "$endpoint"
        echo "Deleted endpoint $endpoint"
    done

    # delete all sagemaker endpoint config
    for config in $(aws sagemaker list-endpoint-configs --query "EndpointConfigs[*].EndpointConfigName" --output text); do
        aws sagemaker delete-endpoint-config --endpoint-config-name "$config"
        echo "Deleted endpoint config $config"
    done

    # delete all sagemaker model
    for model in $(aws sagemaker list-models --query "Models[*].ModelName" --output text); do
        aws sagemaker delete-model --model-name "$model"
        echo "Deleted model $model"
    done

done
