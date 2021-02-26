<p style="text-align:center"><img alt="https ssl" src="https://www.chemsresearch.com/wp-content/uploads/SSL.jpeg" width="300"></p>

<h1 style="text-align:center">Local SSL Certificate Generator</h1>

## Installation
```
$ git clone https://github.com/zablik/ssl_cert_generator.git
```

## Generating Certificated

1. We will create local Certification authority (CA).
2. Then we create SSL Certificated for any local domain and sign them with our CA certificates.
3. We install rootCA.pem on our host (add to KeyChain) and mark it as "Always trusted". 

These scripts were created on base of the **@evAPPs** [article](https://habr.com/ru/post/352722/) on [habr.com](https://habr.com)

```
cd ./ssl_cert_generator

# Generate Root CA certificates.
$ ./root_ca.sh

# Generate SSL certificates for a domain
$ ./domain.sh mysite.local

# or with the second COMMON_NAME parameter
$ ./domain.sh mysite.local www.mysite.local 
```

## Directory structure
```
your_dir/
. ssl_cert_generator/
. . root_ca.sh     <--- script to create Root CA
. . domain.sh      <--- script to create SSL Certs for a domain
. . v3.ext

# Root CA are stored in this directory
. root/
. . rootCA.key
. . rootCA.pem

# Certificated for a domains are stored in separate folders
. first-domain.loc/
. . first-domain.loc.key
. . first-domain.loc.crt
. . first-domain.loc.csr
. second-domain.dev/
. . second-domain.loc.dev
. . ..........
```

## Contribution
Any Issue reports and contributions (Pull Requests) are welcomed