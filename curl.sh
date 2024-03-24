#!/bin/bash

set -euxo pipefail

export PROTECT_REGION=$1

chmod +x *.sh

./sagemaker.sh
./log_group.sh
./ecr.sh
./sns.sh
./table.sh
./lambda-layer.sh
./kms.sh

# git clone https://github.com/elonniu/aws_cleaner.git && cd aws_cleaner &&  bash ./curl.sh "us-east-1"