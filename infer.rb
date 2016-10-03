require 'pp'

$LOAD_PATH.unshift File.expand_path('./lib', File.dirname(__FILE__))

require 'active_record'
require 'models'
require 'scan/snmp'
require 'scan/passive'

#ActiveRecord::Base.establish_connection(
#   :adapter   => 'sqlite3',
#   :database  => './jarvis.sqlite'
#)

      ActiveRecord::Base.establish_connection(
        adapter: 'postgresql',
        database: 'jarvis',
        username: 'postgres'
      )


snmp_scanner = Scan::SNMP.new
snmp_scanner.perform

passive_scanner = Scan::Passive.new
passive_scanner.perform

