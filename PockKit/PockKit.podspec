#
# Be sure to run `pod lib lint PockKit.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'PockKit'
  s.version          = '0.1.3'
  s.summary          = 'Core framework for building Pock widgets'

  s.description      = <<-DESC
PockKit is the core framework for building Pock widgets.
Documentation will be available soon on https://kit.pock.dev/docs/
                       DESC

  s.homepage         = 'https://kit.pock.dev'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pigigaldi' => 'info@pigigaldi.com' }
  s.source           = { :git => 'https://github.com/pigigaldi/PockKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pigigaldi'

  s.platform = :osx
  s.osx.deployment_target = '10.12.2'
  s.swift_version = '5'
  
  s.frameworks = 'Foundation'
  s.frameworks = 'AppKit'
  
  s.exclude_files = ['docs/**/*']
  
  s.subspec 'Protocols' do |ss|
    ss.source_files = 'PockKit/Protocols/**/*'
  end
  
  s.subspec 'Sources' do |ss|
    ss.dependency 'PockKit/3rd'
    ss.source_files = 'PockKit/Sources/**/*'
  end
  
  s.subspec '3rd' do |ss|
    ss.source_files = 'PockKit/3rd/**/*'
  end
  
  s.dependency 'SnapKit'

end
