#!/bin/bash

source ./ssh.sh
ansible -i ./src/inv.ini ./play.yml -bK