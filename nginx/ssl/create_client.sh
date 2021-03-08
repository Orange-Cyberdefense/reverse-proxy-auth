#!/bin/bash
dir=./clients
ca=./ca

# enough args
if [ $# -lt 3 ];
   then
   printf "Usage: firstname lastname email@address\n"
   exit 0
fi

if [ ! -d "$dir/p12" ]
then
	mkdir $dir/p12
fi

# string conversion
FIRSTNAME=$(echo $1 | iconv -f utf8 -t ascii//TRANSLIT)
LASTNAME=$(echo $2 | iconv -f utf8 -t ascii//TRANSLIT)
EMAIL=$3
CAPASS=$(cat ./ca/ca_key_password.txt)
fullname="${FIRSTNAME}_${LASTNAME}"
password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)

EXISTING_CLIENT=clients/${FIRSTNAME}_${LASTNAME}.crt
if [ -f "$EXISTING_CLIENT" ]; then
  echo "Client $FIRSTNAME $LASTNAME already exists. If you want to reissue a certificate, revoke the old one first using revoke_client.sh, then issue a new one."
  echo "Quitting"
  exit 0
fi

# generating the configuration file from the template, replacing variables
sed "s/FIRSTNAME/$FIRSTNAME/g" $dir/client.tpl > $dir/client.cnf
sed -i "s/LASTNAME/$LASTNAME/g" $dir/client.cnf
sed -i "s/EMAIL/$EMAIL/g" $dir/client.cnf

# creating the client key + csr using a password
openssl req -new -config $dir/client.cnf -out $dir/$fullname.csr -keyout $dir/$fullname.key -passout pass:$password

# creating the crt using extensions
openssl ca -config $ca/ca.cnf -in $dir/$fullname.csr -out $dir/$fullname.crt -extensions client_ext -passin pass:$CAPASS -batch

# creating the .p12 file for clients using a password
openssl pkcs12 -export -name "$FIRSTNAME $LASTNAME" -inkey $dir/$fullname.key -in $dir/$fullname.crt -out $dir/p12/$fullname.p12 -passout pass:$password -passin pass:$password

echo "Client $FIRSTNAME $LASTNAME created. The p12 file is located in $dir/p12/$fullname.p12 and protected with the password $password"
echo $FIRSTNAME $LASTNAME: $password >> $dir/passwords.txt
echo "Password added to $dir/passwords.txt"
