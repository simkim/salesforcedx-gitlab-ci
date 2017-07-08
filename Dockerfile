FROM simkim/salesforcedx
VOLUME /app
WORKDIR /app
# sfdx environment
ENV SFDX_AUTOUPDATE_DISABLE true
ENV SFDX_USE_GENERIC_UNIX_KEYCHAIN true
ENV SFDX_DOMAIN_RETRY 300
# build environment
ENV CI_SFDX_ORG ciorg
ENV CI_SFDX_KEY /app/assets/server.key
ENV CI_SFDX_SCRATCH_DEF /app/config/project-scratch-def.json
COPY sfdx-test.sh /usr/local/bin/
CMD bash
