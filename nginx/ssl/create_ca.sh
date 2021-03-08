#!/bin/bash
dir=./ca
PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)

# prevention message
read -p "This will delete all existing CA files. Are you sure ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# cleaning
cd $dir
rm *.old
rm *.srl
rm *.attr
rm *.crt
rm *.csr
rm *.db
rm *.key
rm *.crl
rm *password.txt
rm certificates/*


# initialize
cp /dev/null ca.db
cp /dev/null ca.db.attr
echo '01' > ca.crt.srl
echo '01' > ca.crl.srl
if [ ! -d "$dir/certificates" ]
then
        mkdir certificates
fi
cd ..
echo "Cleaning done"

# generate the things
openssl req -new -config $dir/ca.cnf -out $dir/ca.csr -keyout $dir/ca.key -passout pass:$PASS
openssl ca -selfsign -config $dir/ca.cnf -batch -in $dir/ca.csr -out $dir/ca.crt -extensions root_ca_ext -passin pass:$PASS
# generating the crl list of revoked certficiates
openssl ca -gencrl -config $dir/ca.cnf -out $dir/ca.crl -passin pass:$PASS
echo $PASS > $dir/ca_key_password.txt
echo "Generating certificate done. The key is protected by the password $PASS"
echo "$ ls -l $dir"
ls -l $dir

# locking the script in order to protect the CA
echo "Locking create_ca.sh to avoid accident"
chmod 000 create_ca.sh
