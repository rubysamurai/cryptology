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

> **Note:** Ruby 2.4 and above would throw an error if key is too short or too long for a given cipher algorithm (see [this commit](https://github.com/ruby/ruby/commit/ce635262f53b760284d56bb1027baebaaec175d1) for details) Make sure you choose a cipher with 32 bytes size key.

List of tested and supported ciphers:

```
Ruby 2.7.0, OpenSSL 1.1.1

AES-128-XTS
AES-256-CBC
AES-256-CBC-HMAC-SHA1
AES-256-CBC-HMAC-SHA256
AES-256-CFB
AES-256-CFB1
AES-256-CFB8
AES-256-CTR
AES-256-ECB
AES-256-OFB
AES256

ARIA-256-CBC
ARIA-256-CFB
ARIA-256-CFB1
ARIA-256-CFB8
ARIA-256-CTR
ARIA-256-ECB
ARIA-256-OFB
ARIA256

CAMELLIA-256-CBC
CAMELLIA-256-CFB
CAMELLIA-256-CFB1
CAMELLIA-256-CFB8
CAMELLIA-256-CTR
CAMELLIA-256-ECB
CAMELLIA-256-OFB
CAMELLIA256

CHACHA20
CHACHA20-POLY1305
```

## License

`Cryptology` © Dmitriy Tarasov. Released under the [MIT](LICENSE.txt) license.
