require 'nokogiri'
require 'pp'

doc = Nokogiri::XML File.read('nmap.xml')

pp doc
