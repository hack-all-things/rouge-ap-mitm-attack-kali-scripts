  GNU nano 8.2                                       rouge-wifi-setup-1.sh                                                
#!/bin/bash

#                       example cfg     my cfg
# inet conn IP          192.168.0.12    192.168.86.40
# inet gw IP            192.168.0.1     192.168.86.1

# rouge AP Interface    wlan0           wlan1
# rouge AP IP           192.168.1.1     192.168.1.1
# rouge AP gw IP

sudo ettercap -p -u -T -q -i at0 #start ettercap
