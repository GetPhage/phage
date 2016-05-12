class Scan
  class Diff
    
    def initialize(results)
    end

    def snapshot
      Scan.transaction do
        scan = Scan.create 
        results.each do |item|
          d = Device.find_or_create! mac_address: item[:mac_address]
          
        end
      end
    end
  end
end
