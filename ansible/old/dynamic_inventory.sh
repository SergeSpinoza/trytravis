#!/bin/bash
export TF_ANSIBLE_GROUPS_TEMPLATE='{{ ["all", name[24:]] | join("\n") }}'
export TF_STATE=../terraform/stage/terraform.tfstate
./yatadis.py $@