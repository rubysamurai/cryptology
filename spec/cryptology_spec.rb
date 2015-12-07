require 'spec_helper'

ALGORITHMS = %w(AES-128-CBC
                AES-128-CFB
                AES-128-CFB1
                AES-128-CFB8
                AES-128-ECB
                AES-128-OFB

                AES-192-CBC
                AES-192-CFB
                AES-192-CFB1
                AES-192-CFB8
                AES-192-ECB
                AES-192-OFB

                AES-256-CBC
                AES-256-CFB
                AES-256-CFB1
                AES-256-CFB8
                AES-256-CTR
                AES-256-ECB
                AES-256-OFB

                BF-CBC
                BF-CFB
                BF-ECB
                BF-OFB

                CAMELLIA-256-CBC
                CAST5-CBC
                DES-CBC
                DES-EDE-CBC
                DES-EDE3-CBC
                DESX-CBC
                RC2-CBC
                SEED-CBC)

describe Cryptology do
  context 'encryption' do
    ALGORITHMS.each do |alg|
      it "encrypts #{alg}" do
        algorithm  = alg
        data       = 'Very, very confidential data'
        key        = OpenSSL::Cipher::Cipher.new(algorithm).random_key
        iv         = OpenSSL::Cipher::Cipher.new(algorithm).random_iv
        expect { Cryptology.encrypt(data, key, algorithm, iv) }
          .not_to raise_error
      end
    end
  end

  context 'decryption' do
    ALGORITHMS.each do |alg|
      it "decrypts #{alg}" do
        algorithm  = alg
        data       = 'Very confidential data with UTF-8 symbols: ♠ я ü æ'
        key        = OpenSSL::Cipher::Cipher.new(algorithm).random_key
        iv         = OpenSSL::Cipher::Cipher.new(algorithm).random_iv
        encrypted  = Cryptology.encrypt(data, key, algorithm, iv)
        expect(Cryptology.decrypt(encrypted, key, algorithm, iv)).to eq data
      end
    end
  end
end
