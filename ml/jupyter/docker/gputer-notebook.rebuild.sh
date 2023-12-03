#!/usr/bin/env bash


### 1 of 5
# for python37 specify mamba version >= 0.2 at docker-stacks-foundation/Dockerfile
PYTHON_VERSION="3.11"
TAG="ubuntu2204-cuda12-python311"

echo "[1 of 5] Build docker-stacks-foundation image"
cd docker-stacks-foundation
docker build -f Dockerfile \
  --build-arg ROOT_CONTAINER=nvidia/cuda:12.2.2-devel-ubuntu22.04 \
  --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
  -t docker-stacks-foundation:${TAG} \
  .
cd -
echo "[1 of 5] done"
echo


### 2 of 5
BASE_CONTAINER=docker-stacks-foundation:${TAG}

echo "[2 of 5] Build base-notebook image"
cd base-notebook
docker build -f Dockerfile \
  --build-arg BASE_CONTAINER=${BASE_CONTAINER} \
  -t base-notebook:${TAG} \
  .
cd -
echo "[2 of 5] done"
echo


### 3 of 5
BASE_CONTAINER=base-notebook:${TAG}

echo "[3 of 5] Build minimal-notebook image"
cd minimal-notebook
docker build -f Dockerfile \
  --build-arg BASE_CONTAINER=${BASE_CONTAINER} \
  -t minimal-notebook:${TAG} \
  .
cd -
echo "[3 of 5] done"
echo


### 4 of 5
BASE_CONTAINER=minimal-notebook:${TAG}

echo "[4 of 5] Build scipy-notebook image"
cd scipy-notebook
docker build -f Dockerfile \
  --build-arg BASE_CONTAINER=${BASE_CONTAINER} \
  -t scipy-notebook:${TAG} \
  .
cd -
echo "[4 of 5] done"
echo


### 5 of 5
BASE_CONTAINER=scipy-notebook:${TAG}

echo "[5 of 5] Build datascience-notebook image"
cd datascience-notebook
docker build -f Dockerfile \
  --build-arg BASE_CONTAINER=${BASE_CONTAINER} \
  -t datascience-notebook:${TAG} \
  .
cd -
echo "[5 of 5] done"
echo

