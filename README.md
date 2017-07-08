# How to use

## Manually with a local project
```bash
docker run --rm -ti -e CI_SFDX_USERNAME=XXX@XXX -e CI_SFDX_CONSUMER_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -v YOUR_PROJECT_FOLDER:/app -v YOUR_KEY:/app/assets/server.key  salesforcedx-gitlab-ci sfdx-test.sh
```

## With Gitlab CI

- copy and rename [gitlab-ci.yml](examples/gitlab-ci.yml) in YOU_PROJECT_FOLDER/.gitlab-ci.yml
- Create a pipeline variable **secret_key** with your pem key (server.key) encoded in base64
