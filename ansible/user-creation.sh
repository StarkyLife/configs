#!/bin/bash

printf '%s\n' 123 123 | adduser --gecos "" $1

usermod -aG sudo $1
