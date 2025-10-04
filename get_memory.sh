#!/bin/bash

echo "Removing stopped containers, unused networks, dangling images and build cache"
docker system prune -a -f > /dev/null

echo "Removing Unused images"
docker image prune -a -f > /dev/null

echo "Removed unused volume"
docker volume prune -a --volumes -f > /dev/null

echo "Checking memory now"
df -h
