require 'forwardable'

# get oui.txt from http://standards-oui.ieee.org/oui/oui.txt
class OUI
  include Enumerable

  extend Forwardable
  def_delegators :collection, :each, :<<, :size

  attr_accessor :collection
      
  def initialize(filename)
    @collection = []
    input = File.open filename, 'r:UTF-8'

    input.each_line do |line|
      m = line.match /([0-9|a-f|A-F]{6})\s+\(base 16\)\s+(.+)$/
      if m
        puts "#{m[1]}, #{m[2]}"
        @collection.push({ prefix: m[1], manufacturer: m[2] })
      end
    end
  end
end
