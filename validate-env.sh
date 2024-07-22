#!/bin/bash

if [ -z AWS_REGION ]; then
  echo "AWS_REGION is not set"
  exit 1
fi

if [ -z AWS_ACCESS_KEY_ID ]; then
  echo "AWS_ACCESS_KEY_ID is not set"
  exit 1
fi

if [ -z AWS_SECRET_ACCESS_KEY ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set"
  exit 1
fi
