# Cryptology

[![Gem Version](https://badge.fury.io/rb/cryptology.svg)](https://badge.fury.io/rb/cryptology)
[![Build Status](https://travis-ci.org/rubysamurai/cryptology.svg?branch=master)](https://travis-ci.org/rubysamurai/cryptology)

`Cryptology` is a wrapper for encryption and decryption in Ruby. Supports all cipher algorithms, that are available in installed version of OpenSSL. By default `AES-256-CBC` is used.

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
Cryptology.encrypt(data: data, key: key, cipher: cipher, iv: iv)

# Decrypting
Cryptology.decrypt(data: data, key: key, cipher: cipher, iv: iv)
```

Argument | Required? | Default       | Comment
---------|-----------|---------------|-------------
data     | **Yes**   | n/a           | Data to encrypt or decrypt
key      | **Yes**   | n/a           | Secure key for encryption and decryption
cipher   | *No*      | `AES-256-CBC` | Cipher algorithm
iv       | *No*      | `nil`         | Initialization vector for CBC, CFB, CTR, OFB modes

Example:

```ruby
# Data to encrypt (required)
data = 'Very, very confidential data'
# Secure key for encryption (required)
key = 'veryLongAndSecurePassword_6154309'
# Use Blowfish cipher in CBC mode (optional)
cipher = 'BF-CBC'
# Initialization vector for BF-CBC (optional)
iv = OpenSSL::Cipher::Cipher.new(cipher).random_iv

# Encrypt our data
encrypted = Cryptology.encrypt(data: data, key: key, cipher: cipher, iv: iv)

# Decrypt our data
plain = Cryptology.decrypt(data: encrypted, key: key, cipher: cipher, iv: iv)

```

### Cipher algorithms

To get a list of available cipher algorithms in your environment run this command:

```
$ openssl list-cipher-algorithms
```

or this Ruby code:

```ruby
require 'openssl'
puts OpenSSL::Cipher.ciphers
```

## Contributing

Anyone is welcome to contribute to Cryptology. Please [raise an issue](https://github.com/rubysamurai/cryptology/issues), fork the project, make changes to your forked repository and submit a pull request.

## License

`Cryptology` © Dmitriy Tarasov, 2015. Released under the [MIT](https://github.com/rubysamurai/cryptology/blob/master/LICENSE.txt) license.