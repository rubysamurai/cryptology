CIPHERS = %w[AES-128-CBC
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
             DES3].freeze

RSpec.describe Cryptology do
  let(:data) { 'Very confidential data with UTF-8 symbols: ♠ я ü æ' }
  let(:key) { 'veryLongAndSecurePassword_61543054534' }
  let(:salt) { OpenSSL::Random.random_bytes(16) }
  let(:iter) { 25_000 }
  let(:cipher) { 'CAMELLIA-256-CBC' }
  let(:iv) { OpenSSL::Cipher.new(cipher).random_iv }

  it 'encrypts and decrypts with default arguments' do
    encrypted = Cryptology.encrypt(data: data, key: key)
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         salt: encrypted['salt'],
                         iv: encrypted['iv'])
    ).to eq data
  end

  it 'encrypts and decrypts with salt argument' do
    encrypted = Cryptology.encrypt(data: data, key: key, salt: salt)
    expect(encrypted['salt']).to eq salt
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         salt: salt,
                         iv: encrypted['iv'])
    ).to eq data
  end

  it 'encrypts and decrypts with iter argument' do
    encrypted = Cryptology.encrypt(data: data, key: key, iter: iter)
    expect(encrypted['iter']).to eq iter
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         salt: encrypted['salt'],
                         iter: iter,
                         iv: encrypted['iv'])
    ).to eq data
  end

  it 'encrypts and decrypts with iv argument' do
    encrypted = Cryptology.encrypt(data: data, key: key, iv: iv)
    expect(encrypted['iv']).to eq iv
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         salt: encrypted['salt'],
                         iv: iv)
    ).to eq data
  end

  it 'encrypts and decrypts with cipher argument' do
    encrypted = Cryptology.encrypt(data: data, key: key, cipher: cipher)
    expect(encrypted['cipher']).to eq cipher
    expect(
      Cryptology.decrypt(data: encrypted['data'],
                         key: key,
                         salt: encrypted['salt'],
                         cipher: cipher,
                         iv: encrypted['iv'])
    ).to eq data
  end

  context '#encrypt' do
    it 'throws error without data argument' do
      expect { Cryptology.encrypt(key: key) }
        .to raise_error(ArgumentError)
    end

    it 'throws error without key argument' do
      expect { Cryptology.encrypt(data: data) }
        .to raise_error(ArgumentError)
    end
  end

  context '#decrypt' do
    let(:encrypted) { Cryptology.encrypt(data: data, key: key) }

    it 'throws error without data argument' do
      expect { Cryptology.decrypt(key: key, salt: salt, iv: iv) }
        .to raise_error(ArgumentError)
    end

    it 'throws error without key argument' do
      expect { Cryptology.decrypt(data: encrypted, salt: salt, iv: iv) }
        .to raise_error(ArgumentError)
    end

    it 'throws error without salt argument' do
      expect { Cryptology.decrypt(data: encrypted, key: key, iv: iv) }
        .to raise_error(ArgumentError)
    end

    it 'throws error without iv argument' do
      expect { Cryptology.decrypt(data: encrypted, key: key, salt: salt) }
        .to raise_error(ArgumentError)
    end
  end

  context '#decryptable?' do
    let(:encrypted) do
      Cryptology.encrypt(data: data, key: key, salt: salt, iter: iter, cipher: cipher, iv: iv)
    end

    it 'returns true for valid arguments' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key,
                                salt: salt,
                                iter: iter,
                                cipher: cipher,
                                iv: iv)
      ).to be true
    end

    it 'returns false for invalid data argument' do
      expect(
        Cryptology.decryptable?(data: 'random',
                                key: key,
                                salt: salt,
                                iter: iter,
                                cipher: cipher,
                                iv: iv)
      ).to be false
    end

    it 'returns false for invalid key argument' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key.upcase,
                                salt: salt,
                                iter: iter,
                                cipher: cipher,
                                iv: iv)
      ).to be false
    end

    it 'returns false for invalid salt argument' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key,
                                salt: 'invalid',
                                iter: iter,
                                cipher: cipher,
                                iv: iv)
      ).to be false
    end

    it 'returns false for invalid iter argument' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key,
                                salt: salt,
                                iter: iter - 1,
                                cipher: cipher,
                                iv: iv)
      ).to be false
    end

    it 'returns false for invalid cipher argument' do
      expect(
        Cryptology.decryptable?(data: encrypted['data'],
                                key: key,
                                salt: salt,
                                iter: iter,
                                cipher: 'AES-128-CCM',
                                iv: iv)
      ).to be false
    end
  end

  context 'encryption' do
    CIPHERS.each do |c|
      it "encrypts #{c}" do
        data = 'Very, very confidential data'
        key  = OpenSSL::Cipher.new(c).random_key
        expect { Cryptology.encrypt(data: data, key: key, cipher: c) }.not_to raise_error
      end
    end
  end

  context 'decryption' do
    CIPHERS.each do |c|
      it "decrypts #{c}" do
        data      = 'Very confidential data with UTF-8 symbols: ♠ я ü æ'
        key       = OpenSSL::Cipher.new(c).random_key
        encrypted = Cryptology.encrypt(data: data, key: key, cipher: c)
        expect(
          Cryptology.decrypt(data: encrypted['data'],
                             key: key,
                             salt: encrypted['salt'],
                             iter: encrypted['iter'],
                             cipher: c,
                             iv: encrypted['iv'])
        ).to eq data
      end
    end
  end
end
