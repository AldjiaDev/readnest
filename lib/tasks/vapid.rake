namespace :webpush do
  desc "Generate VAPID keys for Web Push notifications"
  task generate_vapid_keys: :environment do
    require "openssl"
    require "base64"

    key = OpenSSL::PKey::EC.generate("prime256v1")

    # Public key: extract uncompressed point from SubjectPublicKeyInfo DER
    pub_bytes = OpenSSL::ASN1.decode(key.public_to_der).value[1].value
    public_key = Base64.urlsafe_encode64(pub_bytes, padding: false)

    # Private key: works with both SEC1 and PKCS8 DER formats
    raw_der = key.to_der
    asn1 = OpenSSL::ASN1.decode(raw_der)
    private_bytes = if asn1.value[1].is_a?(OpenSSL::ASN1::OctetString)
      # SEC1 / ECPrivateKey format
      asn1.value[1].value
    else
      # PKCS8 format (OpenSSL 3.0+)
      ec_pk = OpenSSL::ASN1.decode(asn1.value[2].value)
      ec_pk.value[1].value
    end
    private_key = Base64.urlsafe_encode64(private_bytes.rjust(32, "\x00"), padding: false)

    puts ""
    puts "=== VAPID Keys generated — add these to your environment ==="
    puts ""
    puts "VAPID_PUBLIC_KEY=#{public_key}"
    puts "VAPID_PRIVATE_KEY=#{private_key}"
    puts ""
    puts "For Heroku:"
    puts "  heroku config:set VAPID_PUBLIC_KEY='#{public_key}'"
    puts "  heroku config:set VAPID_PRIVATE_KEY='#{private_key}'"
    puts ""
    puts "For .env (development):"
    puts "  VAPID_PUBLIC_KEY=#{public_key}"
    puts "  VAPID_PRIVATE_KEY=#{private_key}"
    puts ""
  end
end
