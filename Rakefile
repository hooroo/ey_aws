#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Bundler.require :development

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = [ '-c', '-f documentation' ]
  task.pattern    = 'spec/**/*_spec.rb'
end

task :default => :spec
