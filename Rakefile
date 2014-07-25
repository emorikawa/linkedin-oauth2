# Adds the following task:
#   spec - Run RSpec tests & setup $LOAD_PATH properly
#
# We recommend you set the following RSpec options in your own ~/.rspec
# --color
# --format documentation
# --profile
# --order rand
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Adds the following tasks:
#   build   - Build gem in pkg/ directory
#   install - Build and install gem
#   release - Create tag, build gem, and push it to Rubygems
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks

task default: :spec
