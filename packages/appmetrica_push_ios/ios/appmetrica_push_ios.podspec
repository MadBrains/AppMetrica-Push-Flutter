require 'yaml'

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = library_version
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Mad Brains'
  s.source           = { :path => '.' }

  s.source_files = 'Classes/**/*'
  s.static_framework = true
  
  s.platform = :ios, '10.0'

  s.dependency 'Flutter'
  s.dependency 'appmetrica_plugin'
  s.dependency 'YandexMobileMetricaPush', '~> 1.3.0'
  
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES',
    # Flutter.framework does not contain a i386 slice.
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' 
  }
  s.swift_version = '5.0'
end
