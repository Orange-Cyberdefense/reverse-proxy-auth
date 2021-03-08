#!/bin/bash
dir=./tls
ca=./ca
CAPASS=$(cat ./ca/ca_key_password.txt)

if [ $# -lt 1 ];
   then
   echo "Usage: sub.domain.tld"
   exit 0
fi

DNSNAME=$1
sed "s/DNSNAME_TOCHANGE/$1/g" $dir/tls.tpl > $dir/tls.cnf

openssl req -new -config $dir/tls.cnf -out $dir/$DNSNAME.csr -keyout $dir/$DNSNAME.key
openssl ca -config $ca/ca.cnf -batch -in $dir/$DNSNAME.csr -out $dir/$DNSNAME.crt -extensions server_ext -passin pass:$CAPASS