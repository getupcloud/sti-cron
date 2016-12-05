
**This repo is deprecated in favor of https://github.com/getupcloud/crond**

STI-enabled Cron docker containers
================================

This repo contains [Source to Image](https://github.com/openshift/source-to-image) Docker containers to run cron jobs.

To create a basic cron job image, run:

    $ s2i build https://github.com/getupcloud/sti-cron.git --context-dir=contrib/example getupcloud/cron-base-centos7 mycron
    $ docker run -it --rm mycron

For more info, see [base/README.md](base/README.md).
