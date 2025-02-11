require 'cryptology/version'
require 'openssl'
require 'base64'

module Cryptology
  def self.encrypt(data:, key:, salt: nil, iter: 10_000, cipher: 'AES-256-CBC', iv: nil)
    salt ||= OpenSSL::Random.random_bytes(16)
    iv ||= OpenSSL::Cipher.new(cipher).random_iv
    derived_key = digest_key(key, salt, iter, OpenSSL::Cipher.new(cipher).key_len)
    encrypted = encrypt_data(data.to_s, derived_key, cipher, iv)
    { 'cipher' => cipher,
      'salt' => salt,
      'iter' => iter,
      'iv' => iv,
      'data' => ::Base64.encode64(encrypted) }
  end

  def self.decrypt(data:, key:, salt:, iter: 10_000, cipher: 'AES-256-CBC', iv:)
    base64_decoded = ::Base64.decode64(data.to_s)
    derived_key = digest_key(key, salt, iter, OpenSSL::Cipher.new(cipher).key_len)
    decrypt_data(base64_decoded, derived_key, cipher, iv)
      .force_encoding('UTF-8').encode
  end

  def self.decryptable?(data:, key:, salt:, iter: 10_000, cipher: 'AES-256-CBC', iv:)
    return true if decrypt(data: data, key: key, salt: salt, iter: iter, cipher: cipher, iv: iv)
  rescue OpenSSL::Cipher::CipherError
    false
  end

  def self.encrypt_data(data, key, cipher, iv)
    c = OpenSSL::Cipher.new(cipher)
    c.encrypt
    c.key = key
    c.iv = iv if iv.length == c.iv_len
    c.update(data) + c.final
  end

  def self.decrypt_data(data, key, cipher, iv)
    decipher = OpenSSL::Cipher.new(cipher)
    decipher.decrypt
    decipher.key = key
    decipher.iv  = iv if iv.length == decipher.iv_len
    decipher.update(data) + decipher.final
  end

  def self.digest_key(key, salt, iter, key_len)
    digest = OpenSSL::Digest.new('SHA256')
    OpenSSL::PKCS5.pbkdf2_hmac(key, salt, iter, key_len, digest)
  end

  private_class_method :encrypt_data, :decrypt_data, :digest_key
end
