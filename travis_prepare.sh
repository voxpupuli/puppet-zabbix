#!/bin/sh
if [ "${PUPPET_VERSION}" = '~> 4.0' ]; then
  gem install bundler -v '< 2' --no-rdoc --no-ri;
else
  gem update --system;
  gem update bundler;
  bundle --version;
fi
