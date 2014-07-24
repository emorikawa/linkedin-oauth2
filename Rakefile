# Adds the following task:
#   spec - Run RSpec tests & setup $LOAD_PATH properly
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Adds the following tasks:
#   build   - Build gem in pkg/ directory
#   install - Build and install gems
#   release - Create tag, build, and push to Rubygems
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks

task default: :spec
