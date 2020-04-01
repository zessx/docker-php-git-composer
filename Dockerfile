#
# Provides an image with:
# - PHP
# - Git
# - Composer
#
FROM php:7.4-cli-alpine

LABEL author="Samuel Marchal <samuel@148.fr>"

# Installing Git
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash git openssh 

# Installing Composer
RUN EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)" \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" \
    && if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then rm composer-setup.php && exit 1; fi \
    && php composer-setup.php --quiet \
    && rm composer-setup.php \
    && mv composer.phar /usr/local/bin/composer

# Default command: displays tool versions
CMD [ "/bin/sh", "-c", "echo -e \"PHP:      \\e[32m$(php -v | grep ^PHP | cut -d ' ' -f2)\\e[39m\\nComposer: \\e[32m$(composer --version | cut -d ' ' -f 3)\\e[39m\\nGit:      \\e[32m$(git --version | cut -d ' ' -f 3)\\e[39m\"" ]
