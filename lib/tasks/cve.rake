require 'net/http'
require 'uri'

namespace :cve do
  CVE_DOWNLOAD_FILENAME = 'tmp/cve.xml'

  desc 'Download updated master CVE index from MITRE'
  task :download do
    uri = URI.parse 'https://cve.mitre.org/data/downloads/allitems.xml.gz'
    results = Net::HTTP.get uri

    # force encoding because we were getting encoding errors
    File.open(CVE_DOWNLOAD_FILENAME, 'w:') { |f| f.write results.force_encoding('UTF-8') }
  end

  desc 'Import MITRE\'s master CVE index from a file'
  task :import_file => [:environment] do
    f = File.read CVE_DOWNLOAD_FILENAME
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

  desc 'Download and import MITRE\'s master CVE index'
  task :import => [:download, :import_file]

  desc 'Import CVE feed - doesn\'t work yet'
    task :read_feed => [:environment] do
    uri = URI.new 'https://nvd.nist.gov/feeds/xml/cve/nvdcve-2.0-Recent.xml.gz'
  end
end

  
