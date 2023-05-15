# Manage own simple Certification Authority

## Create new ROOT CA
```shell script
# prepare CA directory tree and openssl.cnf
export COUNTRY=RU
export STATE=Moscow
export LOCALITY=Moscow
export ORGANIZATION='Red Hat'
export ORGANIZATIONAL_UNIT='Security dept.'
export EMAIL=ca@ru.redhat.com
export CA_HOSTNAME=redhat.ru

bin/002-new-ca-config.sh ROOT

# create private key
CA=ROOT bin/010-new-key.sh

# examine just created key
bin/020-info-key.sh ROOT/private/ROOT.key.pem

# create Self-signed certificate of ROOT CA
CA=ROOT bin/030-self-sign.sh

# examine content of just created certificate 
bin/040-info-cert.sh ROOT/certs/ROOT.crt.pem

# generate Certificate Revockation List
CA=ROOT bin/050-genrate-crl.sh

# verify just created certificate
CA=ROOT bin/060-verify-cert.sh ROOT/certs/ROOT.crt.pem
```

### Create intermediate CA (Demo Lab)
```shell script
# prepare CA directory tree and openssl.cnf
unset CA_HOSTNAME
export COUNTRY=RU
export STATE=Moscow
export LOCALITY=Moscow
export ORGANIZATION='Red Hat'
export ORGANIZATIONAL_UNIT='Demo Lab'
export EMAIL=ca-demo-lab@ru.redhat.com

bin/002-new-ca-config.sh labs.redhat.ru

# create private key
CA=labs.redhat.ru bin/010-new-key.sh

# examine just created key
bin/020-info-key.sh labs.redhat.ru/private/labs.redhat.ru.key.pem

# create Certificate Signing Request for newly created intermediate CA
CA=labs.redhat.ru bin/110-request-cert.sh

# examine CSR
bin/120-request-info.sh labs.redhat.ru/csr/labs.redhat.ru.csr
```

Send just created CSR to ROOT CA

### Manage CSR of Demo Labs CA at ROOT CA
```shell script
# sign Labs CA
CA=ROOT bin/130-request-sign.sh labs.redhat.ru.csr

# optionaly examine and virify just signed Demo Labs CA Cert

# pack certificate to portable format (PKCS12)
CA=ROOT bin/140-bundle-pack.sh labs.redhat.ru
```
Send just created bundle back to Demo Labs unit

### Deploy received bundle
```shell script
# examine content of just received bundle
bin/150-bundle-info.sh labs.redhat.ru.p12

# unpack bundle
CA=labs.redhat.ru bin/160-bundle-ca-unpack.sh labs.redhat.ru.p12

# examine signed Demo Labs certificate
bin/040-info-cert.sh labs.redhat.ru/certs/labs.redhat.ru.crt.pem

# generate CRL
CA=labs.redhat.ru bin/050-genrate-crl.sh

## verify received certificate
#CA=labs.redhat.ru bin/060-verify-cert.sh labs.redhat.ru/certs/labs.redhat.ru.crt.pem
```

### Generate Server key pair and signed certificate (WWW server)
```shell script
# generate key pair and CSR locally or receive from users
CA=labs.redhat.ru bin/010-new-key.sh apache
CA=labs.redhat.ru bin/110-request-cert.sh apache 10.10.1.115 www www.labs.redhat.ru

# examine just received or created cert (look at ' Requested Extensions' section for requested alternative names)
bin/120-request-info.sh labs.redhat.ru/csr/apache.csr

# sign CSR by Demo Lans CA
CA=labs.redhat.ru bin/130-request-sign.sh labs.redhat.ru/csr/apache.csr

# examine and verify apache certificate
bin/040-info-cert.sh labs.redhat.ru/certs/apache.crt.pem
CA=labs.redhat.ru bin/060-verify-cert.sh labs.redhat.ru/certs/apache.crt.pem

# create bundle for certificate (including keys, if they were generated locally)
CA=labs.redhat.ru bin/140-bundle-pack.sh apache
```
Send bundle apache.p12 to user
