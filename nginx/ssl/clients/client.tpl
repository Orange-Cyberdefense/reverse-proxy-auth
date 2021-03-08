[ req ]
default_bits            = 4096                  # RSA key size
encrypt_key             = no                   # Protect private key
default_md              = sha256                  # MD to use
utf8                    = yes                   # Input is UTF-8
string_mask             = utf8only              # Emit UTF-8 strings
prompt                  = no                   # Prompt for DN
distinguished_name      = client_dn              # DN template
req_extensions          = client_reqext          # Desired extensions

[ client_dn ]
0.domainComponent       = "example"
1.domainComponent       = "site"
C = FR
O = Your Organisation
CN = FIRSTNAME_LASTNAME
ST= IDF
L= Paris
OU= Entity
emailAddress= EMAIL


[ client_reqext ]
keyUsage                = critical,digitalSignature,keyEncipherment,nonRepudiation
extendedKeyUsage        = emailProtection,clientAuth
subjectKeyIdentifier    = hash
subjectAltName          = email:EMAIL
