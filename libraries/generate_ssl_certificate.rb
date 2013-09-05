require 'openssl'
require 'securerandom'

module SensuAdmin
  class SSL

    @@subject_map = {
      country: 'C',
      state: 'ST',
      city: 'L',
      common_name: 'CN',
      organization: 'O',
      department: 'OU',
      email: 'emailAddress'
    }

    def initialize(options)
      @options = {}.update(options)
      @not_before = Time.now
    end

    def build_subject
      @subject ||= begin
        sub = ''
        @options.each_pair do |attr, val|
          sub += "/#{@@subject_map[attr]}=#{val}" if @@subject_map[attr]
        end
        sub
      end
    end

    def generate_cert_and_key(path)
      @key = OpenSSL::PKey::RSA.new 2048
      @certificate = OpenSSL::X509::Certificate.new
      @certificate.version = 2 # X509 v3
      @certificate.serial = SecureRandom.random_number(32767)
      @certificate.not_before = @not_before
      @certificate.not_after = @certificate.not_before + (365 * 24 * 60 * 60)
      @certificate.public_key = @key.public_key
      @certificate.subject = OpenSSL::X509::Name.parse build_subject
      @certificate.sign(@key, OpenSSL::Digest::SHA256.new)
      write_certificate_and_key_to_disk(path)
    end

    private
    def write_certificate_and_key_to_disk(path)
      ::File.open("#{path}/server-cert.pem", 'w') {|f| f.write @certificate.to_pem}
      ::File.open("#{path}/server-key.pem", 'w')  {|f| f.write @key.to_pem}

      ::File.chmod(0644, "#{path}/server-cert.pem")
      ::File.chmod(0600, "#{path}/server-key.pem")
    end

  end
end
