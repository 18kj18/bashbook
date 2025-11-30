#!/bin/bash

ls -d */ | sed 's#/##' | grep "$1"
