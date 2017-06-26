require 'cryptology/version'
require 'openssl'
require 'base64'

module Cryptology
  def self.encrypt(data:, key:, cipher: 'AES-256-CBC', iv: nil)
    iv ||= OpenSSL::Cipher.new(cipher).random_iv
    encrypted = encrypt_data(data.to_s, digest(key), cipher, iv)
    { 'cipher' => cipher,
      'iv' => iv,
      'data' => ::Base64.encode64(encrypted) }
  end

  def self.decrypt(data:, key:, cipher: 'AES-256-CBC', iv: nil)
    base64_decoded = ::Base64.decode64(data.to_s)
    decrypt_data(base64_decoded, digest(key), cipher, iv)
      .force_encoding('UTF-8').encode
  end

  def self.decryptable?(data:, key:, cipher: 'AES-256-CBC', iv: nil)
    return true if decrypt(data: data, key: key, cipher: cipher, iv: iv)
  rescue OpenSSL::Cipher::CipherError
    return false
  end

  def self.encrypt_data(data, key, cipher, iv)
    cipher = OpenSSL::Cipher.new(cipher)
    cipher.encrypt
    cipher.key = key
    cipher.iv  = iv unless iv.nil? || iv.length != 16
    cipher.update(data) + cipher.final
  end

  def self.decrypt_data(data, key, cipher, iv)
    decipher = OpenSSL::Cipher.new(cipher)
    decipher.decrypt
    decipher.key = key
    decipher.iv  = iv unless iv.nil? || iv.length != 16
    decipher.update(data) + decipher.final
  end

  def self.digest(key)
    OpenSSL::Digest::SHA256.digest(key)
  end

  private_class_method :encrypt_data, :decrypt_data, :digest
end
