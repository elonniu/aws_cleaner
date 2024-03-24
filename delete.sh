#!/bin/bash

set -euxo pipefail

export PROTECT_REGION=ap-northeast-1

chmod +x *.sh

./sagemaker.sh
./log_group.sh
./ecr.sh
./sns.sh
./table.sh
./lambda-layer.sh
./kms.sh