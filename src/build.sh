#!/bin/bash

# number is the AWS account id
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 356960567614.dkr.ecr.us-west-2.amazonaws.com
docker build -t brendanbeck62/bbcom . --platform=linux/amd64
docker tag brendanbeck62/bbcom:latest 356960567614.dkr.ecr.us-west-2.amazonaws.com/brendanbeckcom-repo:latest
docker push 356960567614.dkr.ecr.us-west-2.amazonaws.com/brendanbeckcom-repo:latest

#aws ecs update-service --cluster my-cluster --service my-first-service --force-new-deployment

