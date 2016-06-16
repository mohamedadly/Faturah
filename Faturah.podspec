#
# Be sure to run `pod lib lint Faturah.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Faturah'
  s.version          = '1.0.0'
  s.summary          = 'Official Faturah Paymenet Gateway iOS SDK'

  s.description      = <<-DESC
Use this SDK to make payments through Faturah Payment Gateway on iOS devices.
                        DESC

  s.homepage         = 'https://github.com/mohamedadly/Faturah'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mohamedadly' => 'eng.mohamed.adly@gmail.com' }
  s.source           = { :git => 'https://github.com/mohamedadly/Faturah.git', :tag => ""}

  s.ios.deployment_target = '9.0'

s.source_files = 'Faturah/Classes/**/*.{h,m}'

  s.dependency 'SoapKit', '~> 0.0.1'
end
