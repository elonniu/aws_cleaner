#!/bin/bash

set -euxo pipefail

git clone https://github.com/elonniu/aws_cleaner.git

cd aws_cleaner

chmod +x *.sh

./sagemaker.sh
./log_group.sh
./ecr.sh
./sns.sh
./table.sh
./lambda-layer.sh
./kms.sh

# curl -sSL https://raw.githubusercontent.com/elonniu/aws_cleaner/master/curl.sh | bash
