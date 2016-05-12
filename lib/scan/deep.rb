class Scan
  class Deep
    def perform
      system "nmap -oA `date '+%F-%R:%S'` -v -A 10.0.1.0/24"
    end
  end
end
