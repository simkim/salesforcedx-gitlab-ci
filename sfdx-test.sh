#!/bin/bash
set -e
set -x

if [ -z $CI_SFDX_USERNAME ];then
  echo "You must define CI_SFDX_USERNAME with your HubOrg username"
  exit 1
fi

if [ ! -f $CI_SFDX_KEY ];then
  echo "$CI_SFDX_KEY must be present"
  exit 1
fi

sfdx force:auth:jwt:grant --clientid $CI_SFDX_CONSUMER_KEY --jwtkeyfile $CI_SFDX_KEY --username $CI_SFDX_USERNAME --setdefaultdevhubusername -a HubOrg
sfdx force:org:create -v HubOrg -s -f $CI_SFDX_SCRATCH_DEF -a $CI_SFDX_ORG
sfdx force:source:push -u $CI_SFDX_ORG
sfdx force:apex:test:run -u $CI_SFDX_ORG -c -r human
sfdx force:org:delete -u $CI_SFDX_ORG -p
