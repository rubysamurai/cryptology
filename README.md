# Cryptology

[![Gem Version](https://badge.fury.io/rb/cryptology.svg)](https://badge.fury.io/rb/cryptology)
[![CI](https://github.com/rubysamurai/cryptology/workflows/CI/badge.svg)](https://github.com/rubysamurai/cryptology/actions?query=workflow%3ACI)

`Cryptology` is a wrapper for encryption and decryption in Ruby using OpenSSL. By default `AES-256-CBC` cipher is used.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cryptology'
```

Save `Gemfile` and execute `$ bundle` command to install the gem.

Or to install it yourself run this command:

```
$ gem install cryptology
```

## Usage

```ruby
# Encrypting
Cryptology.encrypt(data: data, key: key, salt: salt, iter: iter, cipher: cipher, iv: iv)

# Decrypting
Cryptology.decrypt(data: data, key: key, salt: salt, iter: iter, cipher: cipher, iv: iv)

# Check decryption ability (true if can be decrypted, false otherwise)
Cryptology.decryptable?(data: data, key: key, salt: salt, iter: iter, cipher: cipher, iv: iv)
```


Argument | Required? | Default                 | Comment
---------|-----------|-------------------------|-------------
data     | **Yes**   | n/a                     | Data to encrypt or decrypt
key      | **Yes**   | n/a                     | Secure key for encryption and decryption
salt     | *No*      | Random 16 bytes         | Value to prevent attacks on key based on dictionaries
iter     | *No*      | 10,000                  | Number of iterations to adjust computation time
cipher   | *No*      | `AES-256-CBC`           | Cipher algorithm
iv       | *No*      | Random iv for algorithm | Initialization vector

Example:

```ruby
# Data to encrypt (required)
data = 'Very, very confidential data'

# Secure key for encryption (required)
key = 'password_01X'

# Salt (optional)
salt = OpenSSL::Random.random_bytes(16)
# => "r\x97\xEA9]I\x18\x05\xEAZ\xA2\xBB^Y=\x83"

# Number of iterations (optional)
iter = 50000

# Use Camellia cipher in CBC mode (optional)
cipher = 'CAMELLIA-256-CBC'

# Initialization vector for CAMELLIA-256-CBC (optional)
iv = OpenSSL::Cipher.new(cipher).random_iv
# => "\xB0\xCA\xBBc5'\x03i\x01\xC1@\xC0\xB6\xCE7+"

# Encrypt our data
enc = Cryptology.encrypt(data: data,
                         key: key,
                         salt: salt,
                         iter: iter,
                         cipher: cipher,
                         iv: iv)

# => { "cipher"=>"CAMELLIA-256-CBC",
#      "salt"=>"r\x97\xEA9]I\x18\x05\xEAZ\xA2\xBB^Y=\x83",
#      "iter"=>50000,
#      "iv"=>"\xB0\xCA\xBBc5'\x03i\x01\xC1@\xC0\xB6\xCE7+",
#      "data"=>"k+e3JZpkFIgkB15LjK85k5roojNgawN9yPEp6CXGhCQ=\n" }

# Verify that data can be decrypted
Cryptology.decryptable?(data: enc['data'],
                        key: key,
                        salt: enc['salt'],
                        iter: enc['iter'],
                        cipher: enc['cipher'],
                        iv: enc['iv'])
#  => true

# Decrypt our data
plain = Cryptology.decrypt(data: enc['data'],
                           key: key,
                           salt: enc['salt'],
                           iter: enc['iter'],
                           cipher: enc['cipher'],
                           iv: enc['iv'])
# => "Very, very confidential data"
```

### Cipher algorithms

> **Authenticated Encryption and Associated Data (AEAD):** An authenticated encryption mode (CCM, GCM, OCB) with an authentication tag computation is not supported at this time.

List of tested and supported ciphers:

```
AES-128-CBC
AES-128-CFB
AES-128-CFB1
AES-128-CFB8
AES-128-CTR
AES-128-ECB
AES-128-OFB
AES-128-XTS
AES-192-CBC
AES-192-CFB
AES-192-CFB1
AES-192-CFB8
AES-192-CTR
AES-192-ECB
AES-192-OFB
AES-256-CBC
AES-256-CFB
AES-256-CFB1
AES-256-CFB8
AES-256-CTR
AES-256-ECB
AES-256-OFB
AES-256-XTS
AES128
AES192
AES256

ARIA-128-CBC
ARIA-128-CFB
ARIA-128-CFB1
ARIA-128-CFB8
ARIA-128-CTR
ARIA-128-ECB
ARIA-128-OFB
ARIA-192-CBC
ARIA-192-CFB
ARIA-192-CFB1
ARIA-192-CFB8
ARIA-192-CTR
ARIA-192-ECB
ARIA-192-OFB
ARIA-256-CBC
ARIA-256-CFB
ARIA-256-CFB1
ARIA-256-CFB8
ARIA-256-CTR
ARIA-256-ECB
ARIA-256-OFB
ARIA128
ARIA192
ARIA256

CAMELLIA-128-CBC
CAMELLIA-128-CFB
CAMELLIA-128-CFB1
CAMELLIA-128-CFB8
CAMELLIA-128-CTR
CAMELLIA-128-ECB
CAMELLIA-128-OFB
CAMELLIA-192-CBC
CAMELLIA-192-CFB
CAMELLIA-192-CFB1
CAMELLIA-192-CFB8
CAMELLIA-192-CTR
CAMELLIA-192-ECB
CAMELLIA-192-OFB
CAMELLIA-256-CBC
CAMELLIA-256-CFB
CAMELLIA-256-CFB1
CAMELLIA-256-CFB8
CAMELLIA-256-CTR
CAMELLIA-256-ECB
CAMELLIA-256-OFB
CAMELLIA128
CAMELLIA192
CAMELLIA256

CHACHA20
CHACHA20-POLY1305

DES-EDE
DES-EDE-CBC
DES-EDE-CFB
DES-EDE-ECB
DES-EDE-OFB
DES-EDE3
DES-EDE3-CBC
DES-EDE3-CFB
DES-EDE3-CFB1
DES-EDE3-CFB8
DES-EDE3-ECB
DES-EDE3-OFB
DES3
```

## License

`Cryptology` © Dmitriy Tarasov. Released under the [MIT](LICENSE.txt) license.
