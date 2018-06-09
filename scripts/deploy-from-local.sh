#!/usr/bin/env bash

set -e

export $(egrep -v '^#' .env | xargs)


# Deploy the infrastructure

cd infrastructure;

terraform init -backend-config="access_key=$ACCESS_KEY";

terraform plan;

terraform apply;
