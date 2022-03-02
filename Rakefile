# require_relative 'boot'
require_relative 'db/config'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    ROM::SQL::RakeSupport.env = ROMConfig.config
  end
end
