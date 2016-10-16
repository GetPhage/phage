require 'pp'

namespace :cve do
  desc "Import master CVE index from MITRE"
  task :import => [:environment] do
#    uri = URI.new 'https://cve.mitre.org/data/downloads/allitems.xml.gz'

    f = File.read './allitems.xml'
    cves = Hash.from_xml f
    cves["cve"]["item"].each do |cve|
      if cve["refs"] == "\n" || !cve["refs"]
        refs = []
      else
        refs = cve["refs"]["ref"]
      end

      if cve["comments"] == "\n" || !cve["comments"]
        comments = []
      else
        comments = cve["comments"]["comment"]
      end

      c = Cve.where(seq: cve["seq"]).first_or_create name: cve["name"],
                                                     seq: cve["seq"],
                                                     status: cve["status"],
                                                     desc: cve["desc"],
                                                     refs: refs,
                                                     comments: comments
    end
  end

  desc "Import CVE feed"
    task :read_feed => [:environment] do
    uri = URI.new 'https://nvd.nist.gov/feeds/xml/cve/nvdcve-2.0-Recent.xml.gz'
  end
end

  
