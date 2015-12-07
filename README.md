# Cryptology

[![Gem Version](https://badge.fury.io/rb/cryptology.svg)](http://badge.fury.io/rb/cryptology)
[![Build Status](https://travis-ci.org/rubysamurai/cryptology.svg?branch=master)](https://travis-ci.org/rubysamurai/cryptology)

`Cryptology` is a wrapper for encryption and decryption in Ruby. Supports all algorithms, that are available in installed version of OpenSSL. By default `AES-256-CBC` is used.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cryptology'
```

Save `Gemfile` and execute `bundle` command to install the gem.

Or to install it yourself run this command: 

```
$ gem install cryptology
```

## Usage

```ruby
# Encrypting
Cryptology.encrypt(data, key, algorithm, iv)

# Decrypting
Cryptology.decrypt(data, key, algorithm, iv)
```

Argument  | Required? | Default       | Comment
----------|-----------|---------------|-------------
data      | **Yes**   | n/a           | Data to encrypt or decrypt
key       | **Yes**   | n/a           | Secure key for encryption and decryption
algorithm | *No*      | `AES-256-CBC` | Cipher algorithm
iv        | *No*      | `nil`         | Initialization vector for CBC, CFB, CTR, OFB modes

Example:

```ruby
# Data to encrypt (required)
data = 'Very, very confidential data'
# Secure key for encryption (required)
key = 'veryLongAndSecurePassword_6154309'
# Use Blowfish algorithm in CBC mode (optional)
algorithm  = 'BF-CBC'
# Initialization vector for BF-CBC (optional)
iv = OpenSSL::Cipher::Cipher.new(algorithm).random_iv

# Encrypt our data
encrypted = Cryptology.encrypt(data, key, algorithm, iv)

# Decrypt our data
plain = Cryptology.decrypt(encrypted, key, algorithm, iv)

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