require 'net/ldap'
class ThuylcLdap
  REGEX = Regexp.compile(/(\w+)@tapptic\.com/)

  def self.hello
    puts "Hello"
  end

  def load_config
  	ldap_config = YAML.load(ERB.new(File.read("#{Rails.root}/config/ldap.yml")).result)[Rails.env]
  end

  def authenticate!(username,password)
  	config = load_config
  	success = false
    email_from_ldap = nil
    begin
      ldap = Net::LDAP.new(host: config["host"],
                           port: 389,
                           auth: {
                               method: :simple,
                               username: config["proxy_username"],
                               password: config["proxy_password"]
                           })

      filter = Net::LDAP::Filter.eq('uid', username)
      dn = nil
      ldap.search(base: config['search_base'], filter: filter, return_result: false) do |entry|
        entry.each do |attribute, values|
          if attribute.to_sym == :mail
            email_from_ldap = values.find(&:present?)
          elsif attribute.to_sym == :dn
            dn = values.find(&:present?)
          end
        end
      end

      ldap.auth(dn, password)
      success = ldap.bind

      unless success
        Rails.logger.error("LDAP error: #{ldap.get_operation_result}")
      end
    rescue Net::LDAP::LdapError => e
      success = false
      Rails.logger.error("LDAP error: #{e}")
    end
  end

  def ldap_username(username)
    username.match(REGEX)[1]
  end
end