require 'dotenv/load'
require 'rom-sql'

class ROMConfig
  def self.opts
    {
        username: ENV['DB_USER'],
        password: ENV['DB_PASS'],
        port: ENV['DB_PORT'],
        encoding: 'UTF8',
      }
  end

  def self.config
    ROM::Configuration.new(:sql, ENV['DB_HOST'], opts)
  end
end
