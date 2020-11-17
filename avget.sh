#!/bin/bash
mkdir -p $HOME/.avherald/
mkdir -p $HOME/.avherald/crashs/
mkdir -p $HOME/.avherald/incidents/
mkdir -p $HOME/.avherald/accidents/
mkdir -p $HOME/.avherald/planes/
mkdir -p $HOME/.avherald/airlines/
cd $HOME/.avherald/
cd $HOME/.avherald/crashs/
wget  -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' -p -e robots=off --html-extension --convert-links http://avherald.com/h?list=&opt=7680
cd $HOME/.avherald/accidents/
wget  -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' -p -e robots=off --html-extension --convert-links http://avherald.com/h?list=&opt=7424
cd $HOME/.avherald/incidents/
wget  -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' -p -e robots=off --html-extension --convert-links http://avherald.com/h?list=&opt=6912
cd $HOME/.avherald/
grep 'alt="Crash" title="Crash"' $HOME/.avherald/crashs/avherald.com/h\?list=.html | grep -o -P '(?<=class="headline_avherald">).*(?=</span>)|(?<="></td><td align="left"><a href=").*(?="><span class="headline_avherald">)'| tr '\n' ' ' | sed 's/http/\nhttp/g'| sed 's/&quot;/"/g' | tail -n +2 > $HOME/.avherald/crashs/rawdata.md
#sed -i 's/ /_/g' $HOME/.avherald/crashs/rawdata.md
grep 'alt="Accident" title="Accident"' $HOME/.avherald/accidents/avherald.com/h\?list=.html | grep -o -P '(?<=class="headline_avherald">).*(?=</span>)|(?<="></td><td align="left"><a href=").*(?="><span class="headline_avherald">)' | tr '\n' ' ' | sed 's/http/\nhttp/g'| sed 's/&quot;/"/g'| tail -n +2 > $HOME/.avherald/accidents/rawdata.md
#sed -i 's/ /_/g' $HOME/.avherald/accidents/rawdata.md
grep 'alt="Incident" title="Incident"' $HOME/.avherald/incidents/avherald.com/h\?list=.html | grep -o -P '(?<=class="headline_avherald">).*(?=</span>)|(?<="></td><td align="left"><a href=").*(?="><span class="headline_avherald">)' | tr '\n' ' ' | sed 's/http/\nhttp/g'| sed 's/&quot;/"/g' | tail -n +2 > $HOME/.avherald/incidents/rawdata.md
sed s/'^opt=0'//g $HOME/.avherald/accidents/rawdata.md | sed 's/ at.*//g' | sed 's/ near.*//g'| sed 's/ enroute.*//g' | awk 'NF>1{print $NF}' >> $HOME/.avherald/planes/planetypesraw.md
sed s/'^opt=0'//g $HOME/.avherald/incidents/rawdata.md | sed 's/ at.*//g' | sed 's/ near.*//g'| sed 's/ enroute.*//g' | awk 'NF>1{print $NF}' >> $HOME/.avherald/planes/planetypesraw.md
sed s/'^opt=0'//g $HOME/.avherald/crashs/rawdata.md | sed 's/ at.*//g' | sed 's/ near.*//g'| sed 's/ enroute.*//g' | awk 'NF>1{print $NF}' >> $HOME/.avherald/planes/planetypesraw.md
sort -u $HOME/.avherald/planes/planetypesraw.md > $HOME/.avherald/planes/planetypes.md
cd $HOME/.avherald/planes/
mkdir $(cat $HOME/.avherald/planes/planetypes.md)
cat $HOME/.avherald/planes/planetypes.md | while read ALINE; do
	grep ${ALINE} $HOME/.avherald/accidents/rawdata.md >> $HOME/.avherald/planes/$ALINE/accidentsraw.md
	sort -u $HOME/.avherald/planes/$ALINE/accidentsraw.md > $HOME/.avherald/planes/$ALINE/accidents.md
done
cat $HOME/.avherald/planes/planetypes.md | while read ILINE; do
	grep ${ILINE} $HOME/.avherald/incidents/rawdata.md >> $HOME/.avherald/planes/$ILINE/incidentsraw.md
	sort -u $HOME/.avherald/planes/$ILINE/incidentsraw.md > $HOME/.avherald/planes/$ILINE/incidents.md
done
cat $HOME/.avherald/planes/planetypes.md | while read CLINE; do
	grep ${CLINE} $HOME/.avherald/crashs/rawdata.md >> $HOME/.avherald/planes/$CLINE/crashsraw.md
	sort -u $HOME/.avherald/planes/$CLINE/crashsraw.md > $HOME/.avherald/planes/$CLINE/crashs.md
done
rm -r $HOME/.avherald/crashs/avherald.com
rm -r $HOME/.avherald/accidents/avherald.com
rm -r $HOME/.avherald/incidents/avherald.com
exit
