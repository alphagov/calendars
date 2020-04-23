#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

if Rails.env.test?
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
end

Rails.application.load_tasks
