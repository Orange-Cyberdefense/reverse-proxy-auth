# Template file for generating csr file
# OpenSSL SUCKS to use environment variable

[ default ]
SAN                     = DNS:site.example    # Default value

[ req ]
default_bits            = 4096                  # RSA key size
encrypt_key             = no                    # Protect private key
default_md              = sha256                  # MD to use
utf8                    = yes                   # Input is UTF-8
string_mask             = utf8only              # Emit UTF-8 strings
prompt                  = no                    # Don't prompt for DN
distinguished_name      = server_dn             # DN section
req_extensions          = server_reqext         # Desired extensions

[ server_dn ]
0.domainComponent       = "example"
1.domainComponent       = "site"
organizationName        = "Your Organization"
organizationalUnitName  = "Entity"
commonName              = "DNSNAME_TOCHANGE"
emailAddress            = "admin@site.example"


[ server_reqext ]
keyUsage                = critical,digitalSignature,keyEncipherment
extendedKeyUsage        = serverAuth,clientAuth
subjectKeyIdentifier    = hash
subjectAltName          = DNS:DNSNAME_TOCHANGE
