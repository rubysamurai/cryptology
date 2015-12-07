require 'cryptology/version'
require 'openssl'
require 'base64'

module Cryptology
  def self.encrypt(data, key, algorithm = 'AES-256-CBC', iv = nil)
    encrypted = encrypt_data(data.to_s, digest(key), algorithm, iv)
    ::Base64.encode64(encrypted)
  end

  def self.decrypt(data, key, algorithm = 'AES-256-CBC', iv = nil)
    base64_decoded = ::Base64.decode64(data.to_s)
    decrypt_data(base64_decoded, digest(key), algorithm, iv)
      .force_encoding('UTF-8').encode
  end

  private

    def self.encrypt_data(data, key, algorithm, iv)
      cipher = ::OpenSSL::Cipher::Cipher.new(algorithm)
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv unless iv.nil?
      cipher.update(data) + cipher.final
    end

    def self.decrypt_data(encrypted_data, key, algorithm, iv)
      decipher = ::OpenSSL::Cipher::Cipher.new(algorithm)
      decipher.decrypt
      decipher.key = key
      decipher.iv = iv unless iv.nil?
      decipher.update(encrypted_data) + decipher.final
    end

    def self.digest(key)
      ::OpenSSL::Digest::SHA256.digest(key)
    end
end
