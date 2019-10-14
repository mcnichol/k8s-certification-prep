#!/usr/bin/env bash
set -eu

echo "This will set up your internal Kubernetes registry with the docker images needed for all of these Tasks"
echo ""; sleep 1s

echo "Pulling Docker images"
echo ""; sleep 1s
docker pull polinux/stress
echo ""
docker pull vish/stress
echo ""; sleep 1s; 

echo "Tagging Docker images for Kubernetes cluster registry"
docker tag $(docker images polinux/stress -q) localhost:32000/polinux/stress:local
docker tag $(docker images vish/stress -q) localhost:32000/vish/stress:local
echo ""; sleep 1s; 

echo "Pushing to Kubernetes Cluster"
echo ""; sleep 1s
docker push localhost:32000/polinux/stress
docker push localhost:32000/vish/stress
