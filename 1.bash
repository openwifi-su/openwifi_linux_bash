#!/bin/bash
set -x
set +ue

iwlist  scanning > src.txt
JOIN_STR=''
for line in `cat src.txt | grep "\- Address\: " | awk '{ print $5 }'  |  sed 's/\://g'` ; do
JOIN_STR="${JOIN_STR},${line}"
done
JOIN_STR=${JOIN_STR:1}
echo $JOIN_STR
wget -Osrc2.txt http://openwifi.su/api/v1/bssids/$JOIN_STR
cat src2.txt |     sed -e 's/[{}]/''/g' |      awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' > src3.txt
LAT=`cat src3.txt | grep lat | awk -F":" '{print $2}'`
LON=`cat src3.txt | grep lon | awk -F":" '{print $2}'`
echo "http://www.openstreetmap.org/#map=19/${LAT}/${LON}"
#rm -f src.txt
#rm -f src2.txt
#rm -f src3.txt