class Scan
  class SNMP
    def perform
      for i in 1..254 do
        system "snmpwalk -c public 10.0.1.#{i}"
      end
    end
  end
end
