#!/usr/bin/env bash

stress --cpu 4 --io 2 --vm 2 --vm-bytes 128M --timeout 20

