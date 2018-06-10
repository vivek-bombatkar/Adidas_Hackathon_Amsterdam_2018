#!/usr/bin/env bash

set -e

export $(egrep -v '^#' .env | xargs)


# Deploy the infrastructure

cd infrastructure;

terraform init -backend-config="access_key=$ACCESS_KEY";

terraform plan;

terraform apply;

export APIS_RG=`terraform output apis_resource_group_name`
export PRODUCT_API_NAME=`terraform output product_api_name`
export PRODUCT_RECORD_API_NAME=`terraform output product_record_api_name`


# Deploy the product api

cd ../product-api;

docker build . -t $CONTAINER_REGISTRY_SERVER/adicode/product-api:$ENV;

docker login $CONTAINER_REGISTRY_SERVER --username $CONTAINER_REGISTRY_USERNAME --password $CONTAINER_REGISTRY_PASSWORD;

docker push $CONTAINER_REGISTRY_SERVER/adicode/product-api:$ENV

az webapp config container set --name $PRODUCT_API_NAME --resource-group $APIS_RG --docker-custom-image-name $CONTAINER_REGISTRY_SERVER/adicode/product-record-api:$ENV --docker-registry-server-url https://$CONTAINER_REGISTRY_SERVER --docker-registry-server-user $CONTAINER_REGISTRY_USERNAME --docker-registry-server-password $CONTAINER_REGISTRY_PASSWORD


# Deploy the product record api

cd ../product-record-api;

docker build . -t $CONTAINER_REGISTRY_SERVER/adicode/product-record-api:$ENV;

docker login $CONTAINER_REGISTRY_SERVER --username $CONTAINER_REGISTRY_USERNAME --password $CONTAINER_REGISTRY_PASSWORD;

docker push $CONTAINER_REGISTRY_SERVER/adicode/product-record-api:$ENV

az webapp config container set --name $PRODUCT_RECORD_API_NAME --resource-group $APIS_RG --docker-custom-image-name $CONTAINER_REGISTRY_SERVER/adicode/product-record-api:$ENV --docker-registry-server-url https://$CONTAINER_REGISTRY_SERVER --docker-registry-server-user $CONTAINER_REGISTRY_USERNAME --docker-registry-server-password $CONTAINER_REGISTRY_PASSWORD