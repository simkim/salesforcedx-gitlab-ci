#!/bin/bash
set -e
set -x

if [ -z $CI_SFDX_USERNAME ];then
  echo "You must define CI_SFDX_USERNAME with your HubOrg username"
  exit 1
fi

if [ ! -f "$CI_PROJECT_DIR/$CI_SFDX_KEY" ];then
  echo "$CI_PROJECT_DIR/$CI_SFDX_KEY must be present"
  exit 1
fi

if [ ! -f "$CI_PROJECT_DIR/$CI_SFDX_SCRATCH_DEF" ];then
  echo "$CI_PROJECT_DIR/$CI_SFDX_SCRATCH_DEF must be present"
  exit 1
fi

sfdx force:auth:jwt:grant --clientid $CI_SFDX_CONSUMER_KEY --jwtkeyfile "$CI_PROJECT_DIR/$CI_SFDX_KEY" --username $CI_SFDX_USERNAME --setdefaultdevhubusername -a HubOrg
sfdx force:org:create -v HubOrg -s -f "$CI_PROJECT_DIR/$CI_SFDX_SCRATCH_DEF" -a $CI_SFDX_ORG
sfdx force:source:push -u $CI_SFDX_ORG
sfdx force:apex:test:run -u $CI_SFDX_ORG -c -r json | tee result.json
cat result.json | python -c "import json, sys; c=reduce(lambda x, y : (x[0]+y[0], x[1]+y[1]),[(x['totalCovered'], x['totalLines']) for x in json.load(sys.stdin)['result']['coverage']['coverage']]); print 'Total Coverage: %f' % (c[0]/float(c[1])*100)"
sfdx force:org:delete -u $CI_SFDX_ORG -p
