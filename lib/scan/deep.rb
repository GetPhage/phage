class Scan
  class Deep
    def initialize(host)
      system "nmap -oA `date '+%F-%R:%S'` -v -A #{host}"
    end
  end
end
