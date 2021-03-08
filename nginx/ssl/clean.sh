#!/bin/bash
# prevention message
read -p "This will delete all existing generated files. Are you sure ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "Cleaning the files to reset the project.."

echo "> Cleaning CA"
cd ca
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
cd ..
chmod 755 create_ca.sh
echo "Done"
echo ""

echo "> Cleaning TLS"
cd tls
rm *.crt
rm *.csr
rm *.key
cd ..
echo "Done"
echo ""

echo "> Cleaning clients"
cd clients
rm *.crt
rm *.csr
rm *.key
echo "" > passwords.txt
rm p12/*.p12
cd ..
echo "Done"
