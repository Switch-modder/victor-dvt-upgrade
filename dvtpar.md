Partition tables
Modern DVT3 (Basically prod):

Number  Start   End     Size    File system  Name         Flags
 1      67.1MB  134MB   67.1MB  fat16        modem        msftdata
 2      134MB   135MB   524kB                sbl1
 3      135MB   135MB   524kB                sbl1bak
 4      135MB   136MB   1049kB               aboot
 5      136MB   137MB   1049kB               abootbak
 6      137MB   171MB   33.6MB               recovery
 7      171MB   842MB   671MB   ext4         recoveryfs
 8      842MB   843MB   524kB                rpm
 9      843MB   843MB   524kB                rpmbak
10      843MB   844MB   786kB                tz
11      844MB   845MB   786kB                tzbak
12      872MB   872MB   16.4kB               sec
13      872MB   872MB   32.8kB               DDR
14      872MB   874MB   1573kB               fsg
15      874MB   875MB   1049kB               pad          msftdata
16      875MB   877MB   1573kB               modemst1
17      877MB   878MB   1573kB               modemst2
18      878MB   879MB   1049kB               misc
19      879MB   879MB   1024B                fsc
20      879MB   879MB   8192B                ssd
21      879MB   913MB   33.6MB               boot_a
22      913MB   1852MB  940MB   ext4         system_a
23      1852MB  1919MB  67.1MB               persist
24      1919MB  1953MB  33.6MB               boot_b
25      1953MB  2893MB  940MB   ext4         system_b
26      2893MB  2894MB  1049kB               devinfo
27      2894MB  2894MB  524kB                keystore
28      2894MB  2911MB  16.8MB  ext4         oem
29      2911MB  2928MB  16.8MB               emr
30      2928MB  2944MB  16.8MB               switchboard
31      2944MB  2945MB  524kB                config
32      2945MB  3750MB  805MB                userdata

Linux DVT2

Number  Start   End     Size    File system  Name        Flags
 1      67.1MB  134MB   67.1MB  fat16        modem       msftdata
 2      134MB   135MB   524kB                sbl1
 3      135MB   135MB   524kB                sbl1bak
 4      135MB   135MB   32.8kB               DDR
 5      135MB   137MB   1573kB               fsg
 6      137MB   137MB   16.4kB               sec
 7      137MB   170MB   33.6MB               recoveryfs
 8      170MB   573MB   403MB   ext4         userdata
 9      573MB   574MB   1049kB               devinfo
10      574MB   575MB   1049kB               aboot
11      575MB   576MB   1049kB               abootbak
12      604MB   605MB   524kB                rpm
13      605MB   605MB   524kB                rpmbak
14      605MB   606MB   786kB                tz
15      606MB   607MB   786kB                tzbak
16      607MB   608MB   1049kB               pad         msftdata
17      608MB   609MB   1573kB               modemst1
18      609MB   611MB   1573kB               modemst2
19      611MB   612MB   1049kB               misc
20      612MB   612MB   1024B                fsc
21      612MB   612MB   8192B                ssd
22      612MB   612MB   8192B                splash
23      612MB   645MB   33.6MB               boot
24      645MB   1585MB  940MB   ext4         templabel
25      1585MB  1652MB  67.1MB  ext4         persist
26      1652MB  1686MB  33.6MB               boot_b
27      1686MB  2625MB  940MB   ext4         cache
28      2625MB  2626MB  524kB                keystore
29      2626MB  2693MB  67.1MB  ext4         oem
30      2693MB  3767MB  1074MB  ext4         system
31      3767MB  3767MB  524kB                config

Android DVT2
Number  Start   End     Size    File system  Name      Flags
 1      67.1MB  134MB   67.1MB  fat16        modem
 2      134MB   135MB   524kB                sbl1
 3      135MB   135MB   524kB                sbl1bak
 4      135MB   135MB   32.8kB               DDR
 5      135MB   137MB   1573kB               fsg
 6      137MB   137MB   16.4kB               sec
 7      137MB   170MB   33.6MB               recovery
 8      170MB   573MB   403MB   ext4         facrec
 9      573MB   574MB   1049kB               devinfo
10      574MB   575MB   1049kB               aboot
11      575MB   576MB   1049kB               abootbak
12      604MB   605MB   524kB                rpm
13      605MB   605MB   524kB                rpmbak
14      605MB   606MB   786kB                tz
15      606MB   607MB   786kB                tzbak
16      607MB   608MB   1049kB               pad
17      608MB   609MB   1573kB               modemst1
18      609MB   611MB   1573kB               modemst2
19      611MB   612MB   1049kB               misc
20      612MB   612MB   1024B                fsc
21      612MB   612MB   8192B                ssd
22      612MB   612MB   8192B                splash
23      612MB   645MB   33.6MB               boot
24      645MB   1585MB  940MB   ext4         system
25      1585MB  1652MB  67.1MB  ext4         persist
26      1652MB  1686MB  33.6MB               boot_b
27      1686MB  2625MB  940MB   ext4         cache
28      2625MB  2626MB  524kB                keystore
29      2626MB  2693MB  67.1MB               oem
30      2693MB  3767MB  1074MB  ext4         userdata
31      3767MB  3767MB  524kB                config

Android dvt2 notes
Nuke pars
3
8
11
13
22