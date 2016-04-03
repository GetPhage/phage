require 'xmlsimple'
require 'pp'

module Jarvis
  def self.down(h)
    puts "down #{h['address'].first['addr']}"
  end

  def self.up(h)
    puts "up #{h['address'].first['addr']}"
  end

  def self.import(filename)
    doc = XmlSimple.xml_in(filename , { 'KeyAttr' => 'name' })

    # pp doc

    # nmaprun is an array
    # look for host elements
    doc['host'].each do |h|
      unless h['status']
        puts '>>> host no status!! <<<'
        pp h
      end

#      pp h['status']

      state = h['status'].first['state']
      if state == 'up'
        up(h)
        next
      end
      if state == 'down'
        down(h)
        next
      end

      puts '>>> host weird status <<<'
      pp state
    end
  end
end

Jarvis::import('data/pp.xml')
