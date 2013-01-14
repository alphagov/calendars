#!/bin/bash -x

export RAILS_ENV=test
export GOVUK_APP_DOMAIN=dev.gov.uk
export GOVUK_ASSET_HOST=http://static.dev.gov.uk

bundle install --path "${HOME}/bundles/${JOB_NAME}"

export DISPLAY=:99
bundle exec rake stats
bundle exec rake ci:setup:testunit test
bundle exec rake assets:precompile
