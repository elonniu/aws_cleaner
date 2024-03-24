#!/bin/bash

# if PROTECT_REGION is not set
if [ -z "$PROTECT_REGION" ]; then
  echo "PROTECT_REGION is not set. Exiting..."
  exit 1
fi

# First, retrieve all regions
all_regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Function to delete all layer versions in a specific region
delete_layer_versions() {
  local region="$1"
  local layer_name="$2"

  version_numbers=($(aws lambda list-layer-versions --layer-name "$layer_name" --query 'LayerVersions[].Version' --output text))

  # Loop through the version numbers and delete each version
  for version_number in "${version_numbers[@]}"; do
    echo "Deleting $layer_name version: $version_number in region: $region"
    aws lambda delete-layer-version --layer-name "$layer_name" --version-number "$version_number"
  done
}

for region in $all_regions; do

  export AWS_DEFAULT_REGION=$region
  export AWS_REGION=$region

  if [ "$region" = "$PROTECT_REGION" ]; then
    echo "Skip region: $region"
    continue
  fi

  layer_names=($(aws lambda list-layers --query 'Layers[].LayerName' --output text))

  if [ -z "$layer_names" ]; then
    continue
  fi

  for layer_name in "${layer_names[@]}"; do
    echo "Processing layer: $layer_name in region: $region"
    delete_layer_versions "$region" "$layer_name"
  done
  
done
