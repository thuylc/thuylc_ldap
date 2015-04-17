Gem::Specification.new do |s|
  s.name        = 'thuylc_ldap'
  s.version     = '0.0.1'
  s.date        = '2015-04-15'
  s.summary     = "LDAP authentication"
  s.description = "A simple authentication via LDAP"
  s.authors     = ["Tapptic"]
  s.email       = 'thuy.le@tapptic.com'
  s.files       = ["lib/thuylc_ldap.rb"]
  s.require_paths = ["lib"]
  s.homepage    = 'http://rubygems.org/gems/thuylc_ldap'
  s.license     = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.add_dependency('net-ldap', '>= 0.3.1', '< 0.6.0')
end