Cron docker base image
======================

This is the base Cron docker container. It supports all crond fatures, including:

- /var/spool/cron/$USER/
- /etc/crontab
- /etc/cron/{minutely,hourly,daily,weekly,monthly}

Users supply scripts and code via [STI](https://github.com/openshift/source-to-image), just like [any](https://github.com/openshift/sti-php)
[runtime](https://github.com/openshift/sti-ruby) [STI](https://github.com/openshift/sti-nodejs) [container](https://github.com/openshift/sti-python).

The wrapper script `/opt/app-root/bin/logger` (contrib/bin/logger) send messages to stderr instead syslog.

Set `CROND_DEBUG=1` to have a verbose crond.

Extending
---------

Most times you need to run stuff from your own project or framework, for example [rake tasks](https://github.com/ruby/rake),
[laravel's artisan](https://laravel.com/docs/5.1/artisan), [django's manage.py](https://docs.djangoproject.com/en/1.9/ref/django-admin/)
or [nodejs' npm](https://www.npmjs.com/). There are 2 problems here:

- We can't put everything for everyone inside a single cartidge because of the size of the resulting image
- Your code/framework is not available inside this image

The solution is to be able to extend this base cartridge (thus the name __base__) and add your own dependencies and logic.
Both `assemble` and `run` sti scripts are available to bootstrap cron, allowing flexible environments that need to create
it's own jobs, whenever it's necessary.

- s2i/bin/cron-base-assemble
- s2i/bin/cron-base-run

Call it from your own `s2i/bin/{assemble,run}` scripts, like this:

    ## call base script to bootstrap cron
    source $STI_SCRIPTS_PATH/cron-base-assemble
    
    ## do my own "assemble" stuff here

Post-assemble hook
------------------

Add an executable file `cron/post-assemble` to your code repo to be invoked prior exit of `cron-base-assemble`.
It allows this pattern:

    #!/bin/bash
    
    source $STI_SCRIPTS_PATH/cron-base-assemble
    
    ## do my own "assemble" stuff here that needs a working cron configuration
    
    ## execute cron/post-assemble upon exit

In order for this hook to be properly installed, the file `$STI_SCRIPTS_PATH/cron-base-assemble` must be _source_d from your assemble script,
so it run inside the current script.
