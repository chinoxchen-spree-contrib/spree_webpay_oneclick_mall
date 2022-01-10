# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_webpay_oneclick_mall'
  s.version     = '2.4.13'
  s.summary     = 'Integration of WebpayOneClick Mall as a payment method in Spree'
  s.description = 'Gem for integrate WebpayOneClick Mall in Spree'
  s.required_ruby_version = '>= 2.7.1'

  s.author    = 'chinoxchen'
  s.email     = 'chienfu.udp@gmail.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'
  
  spree_version = '>= 4.0.0', '< 5.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_api', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'spree_dev_tools'
end
