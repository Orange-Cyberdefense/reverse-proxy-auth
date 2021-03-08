#!/bin/bash
dir=./clients
ca=./ca

# enough args
if [ $# -lt 2 ];
   then
   echo "Usage: firstname lastname"
   exit 0
fi

# string conversion
FIRSTNAME=$(echo $1 | iconv -f utf8 -t ascii//TRANSLIT)
LASTNAME=$(echo $2 | iconv -f utf8 -t ascii//TRANSLIT)
EMAIL=$3
CAPASS=$(cat ./ca/ca_key_password.txt)
fullname="${FIRSTNAME}_${LASTNAME}"

# prevention message
read -p "This will revoke the certificate for $FIRSTNAME $LASTNAME. Are you sure ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# get the pem number from the db
cert_number=$(grep $fullname $ca/ca.db | cut -d$'\t' -f 4)
if [ -z "$cert_number" ]
then
    echo "User $FIRSTNAME $LASTNAME not found"
    echo "Quitting"
    exit 0
fi

# revoke the certificate with the reason "cessationOfOperation"
openssl ca -config $ca/ca.cnf -revoke $ca/certificates/$cert_number.pem -crl_reason cessationOfOperation -passin pass:$CAPASS

# generating the crl list of revoked certficiates
openssl ca -gencrl -config $ca/ca.cnf -out $ca/ca.crl -passin pass:$CAPASS

if [ ! -d "$dir/revoked" ]
then
        mkdir $dir/revoked
fi

mv $dir/p12/$fullname.p12 $dir/revoked/
