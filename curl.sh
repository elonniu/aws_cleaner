#!/bin/bash

set -euxo pipefail

export PROTECT_REGION=$1

cd aws_cleaner
chmod +x *.sh

./sagemaker.sh
./log_group.sh
./ecr.sh
./sns.sh
./table.sh
./lambda-layer.sh
./kms.sh

# rm -rf aws_cleaner && git clone https://github.com/elonniu/aws_cleaner.git && bash aws_cleaner/curl.sh "us-east-1"