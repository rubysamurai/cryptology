require 'spec_helper'

CIPHERS = %w[AES-256-CBC
             AES-256-CFB
             AES-256-CFB1
             AES-256-CFB8
             AES-256-CTR
             AES-256-ECB
             AES-256-OFB

             CAMELLIA-256-CBC
             CAMELLIA-256-CFB
             CAMELLIA-256-CFB1
             CAMELLIA-256-CFB8
             CAMELLIA-256-ECB
             CAMELLIA-256-OFB].freeze

describe Cryptology do
  it 'encrypts and decrypts with default arguments' do
    data      = 'Very confidential data with UTF-8 symbols: ♠ я ü æ'
    key       = 'veryLongAndSecurePassword_61543054534'
    encrypted = Cryptology.encrypt(data: data, key: key)
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         iv: encrypted['iv'])
    ).to eq data
  end

  it 'encrypts and decrypts with iv argument' do
    data      = 'Very confidential data with UTF-8 symbols: ♠ я ü æ'
    key       = 'veryLongAndSecurePassword_61543054534'
    iv        = OpenSSL::Cipher.new('AES-256-CBC').random_iv
    encrypted = Cryptology.encrypt(data: data, key: key, iv: iv)
    expect(encrypted['iv']).to eq iv
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         iv: iv)
    ).to eq data
  end

  it 'encrypts and decrypts with cipher argument' do
    data      = 'Very confidential data with UTF-8 symbols: ♠ я ü æ'
    key       = 'veryLongAndSecurePassword_61543054534'
    cipher    = 'CAMELLIA-256-CBC'
    encrypted = Cryptology.encrypt(data: data, key: key, cipher: cipher)
    expect(encrypted['cipher']).to eq cipher
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         cipher: cipher,
                         iv: encrypted['iv'])
    ).to eq data
  end

  it 'throws error without data argument' do
    key    = 'veryLongAndSecurePassword_61543054534'
    cipher = 'AES-256-CBC'
    iv     = OpenSSL::Cipher.new(cipher).random_iv
    expect { Cryptology.encrypt(key: key, cipher: cipher, iv: iv) }
      .to raise_error(ArgumentError, 'missing keyword: data')
  end

  it 'throws error without key argument' do
    data   = 'Very confidential data with UTF-8 symbols: ♠ я ü æ'
    cipher = 'AES-256-CBC'
    iv     = OpenSSL::Cipher.new(cipher).random_iv
    expect { Cryptology.encrypt(data: data, cipher: cipher, iv: iv) }
      .to raise_error(ArgumentError, 'missing keyword: key')
  end

  context '#decryptable?' do
    let(:data) { 'Very confidential data with UTF-8 symbols: ♠ я ü æ' }
    let(:key) { 'veryLongAndSecurePassword_61543054534' }
    let(:cipher) { 'AES-256-CBC' }
    let(:iv) { OpenSSL::Cipher.new(cipher).random_iv }
    let(:encrypted) { Cryptology.encrypt(data: data, key: key, cipher: cipher, iv: iv) }

    it 'returns true for valid arguments' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key,
                                cipher: cipher,
                                iv: iv)
      ).to be true
    end

    it 'returns false for invalid data argument' do
      expect(
        Cryptology.decryptable?(data: 'random',
                                key: key,
                                cipher: cipher,
                                iv: iv)
      ).to be false
    end

    it 'returns false for invalid key argument' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key.upcase,
                                cipher: cipher,
                                iv: iv)
      ).to be false
    end

    it 'returns false for invalid cipher argument' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key,
                                cipher: 'CAMELLIA-256-CBC',
                                iv: iv)
      ).to be false
    end
  end

  context 'encryption' do
    CIPHERS.each do |c|
      it "encrypts #{c}" do
        data = 'Very, very confidential data'
        key  = OpenSSL::Cipher.new(c).random_key
        iv   = OpenSSL::Cipher.new(c).random_iv
        expect { Cryptology.encrypt(data: data, key: key, cipher: c, iv: iv) }
          .not_to raise_error
      end
    end
  end

  context 'decryption' do
    CIPHERS.each do |c|
      it "decrypts #{c}" do
        data      = 'Very confidential data with UTF-8 symbols: ♠ я ü æ'
        key       = OpenSSL::Cipher.new(c).random_key
        iv        = OpenSSL::Cipher.new(c).random_iv
        encrypted = Cryptology.encrypt(data: data, key: key, cipher: c, iv: iv)
        expect(Cryptology.decrypt(data: encrypted['data'], key: key, cipher: c, iv: iv))
          .to eq data
      end
    end
  end
end
