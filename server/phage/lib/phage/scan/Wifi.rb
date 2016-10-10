require 'iwlist_parser'

class Scan
  class Wifi
    @networks = []

    def initialize(interface_name = 'ra0')
      @interface_name = interface_name
    end

    def perform
      #      results = system "iwlist scanning #{@interface_name}"
      results = <<END_OF_IWLIST
ra0       Scan completed :
          Cell 01 - Address: B8:C7:5D:05:7C:BF
                    Protocol:802.11b/g/n
                    ESSID:"tell me about the chicken"
                    Mode:Managed
                    Frequency:2.437 GHz (Channel 6)
                    Quality=96/100  Signal level=-52 dBm  Noise level=-92 dBm
                    Encryption key:on
                    Bit Rates:54 Mb/s
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
          Cell 02 - Address: 88:1F:A1:33:15:34
                    Protocol:802.11b/g/n
                    ESSID:"tell me about the chicken"
                    Mode:Managed
                    Frequency:2.437 GHz (Channel 6)
                    Quality=70/100  Signal level=-62 dBm  Noise level=-92 dBm
                    Encryption key:on
                    Bit Rates:57.5 Mb/s
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
          Cell 03 - Address: B8:C7:5D:05:7C:C0
                    Protocol:802.11a/n
                    ESSID:"put a bird on it 5GHz"
                    Mode:Managed
                    Frequency:5.785 GHz (Channel 157)
                    Quality=73/100  Signal level=-61 dBm  Noise level=-92 dBm
                    Encryption key:on
                    Bit Rates:120 Mb/s
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
          Cell 04 - Address: 44:32:C8:E3:6B:98
                    Protocol:802.11g/n
                    ESSID:"HOME-6B98"
                    Mode:Managed
                    Frequency:2.462 GHz (Channel 11)
                    Quality=15/100  Signal level=-84 dBm  Noise level=-85 dBm
                    Encryption key:on
                    Bit Rates:57.5 Mb/s
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD180050F204104A00011010440001021049000600372A000120
          Cell 05 - Address: 46:32:C8:E3:6B:9A
                    Protocol:802.11g/n
                    ESSID:"xfinitywifi"
                    Mode:Managed
                    Frequency:2.462 GHz (Channel 11)
                    Quality=15/100  Signal level=-84 dBm  Noise level=-93 dBm
                    Encryption key:off
                    Bit Rates:57.5 Mb/s
          Cell 06 - Address: 46:32:C8:E3:6B:99
                    Protocol:802.11g/n
                    ESSID:""
                    Mode:Managed
                    Frequency:2.462 GHz (Channel 11)
                    Quality=15/100  Signal level=-84 dBm  Noise level=-93 dBm
                    Encryption key:on
                    Bit Rates:57.5 Mb/s
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
          Cell 07 - Address: D8:97:BA:70:29:52
                    Protocol:802.11g/n
                    ESSID:"xfinitywifi"
                    Mode:Managed
                    Frequency:2.462 GHz (Channel 11)
                    Quality=15/100  Signal level=-84 dBm  Noise level=-88 dBm
                    Encryption key:off
                    Bit Rates:54 Mb/s
          Cell 08 - Address: D8:97:BA:70:29:51
                    Protocol:802.11g/n
                    ESSID:""
                    Mode:Managed
                    Frequency:2.462 GHz (Channel 11)
                    Quality=15/100  Signal level=-84 dBm  Noise level=-90 dBm
                    Encryption key:on
                    Bit Rates:54 Mb/s
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
          Cell 09 - Address: D8:97:BA:70:29:50
                    Protocol:802.11g/n
                    ESSID:"HOME-45BE-2.4"
                    Mode:Managed
                    Frequency:2.462 GHz (Channel 11)
                    Quality=13/100  Signal level=-85 dBm  Noise level=-89 dBm
                    Encryption key:on
                    Bit Rates:54 Mb/s
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD1D0050F204104A0001101044000102103C0001011049000600372A000120
          Cell 10 - Address: D8:97:BA:70:FA:9A
                    Protocol:802.11a/n
                    ESSID:"xfinitywifi"
                    Mode:Managed
                    Frequency:5.765 GHz (Channel 153)
                    Quality=5/100  Signal level=-88 dBm  Noise level=-97 dBm
                    Encryption key:off
                    Bit Rates:120 Mb/s
END_OF_IWLIST
      cells = IwlistScanParser.parse results
    end
  end
end
