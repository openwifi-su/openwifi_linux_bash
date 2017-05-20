#!/bin/bash
set -x
set +ue

JOIN_STR=''
while read -r line; do
  JOIN_STR="${JOIN_STR},${line}"
done < <(sudo iwlist  scanning | grep "\- Address\: " | awk '{ print $5 }'  |  sed 's/\://g')
JOIN_STR="${JOIN_STR:1}"
echo "$JOIN_STR"
REQUEST_GEO="$(wget -O - http://openwifi.su/api/v1/bssids/"$JOIN_STR")"
FILTER_REQUEST=$(echo "$REQUEST_GEO" | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}')
LAT=$(echo "$FILTER_REQUEST" | grep lat | awk -F":" '{print $2}')
LON=$(echo "$FILTER_REQUEST" | grep lon | awk -F":" '{print $2}')
echo "http://www.openstreetmap.org/#map=19/${LAT}/${LON}"
