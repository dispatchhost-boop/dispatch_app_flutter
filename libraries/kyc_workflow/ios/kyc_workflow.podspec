#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint kyc_workflow.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'kyc_workflow'
  s.version          = '1.2.9'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Akash' => 'akash.kumar@digio.in' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

#   s.preserve_paths = 'DigiokycSDK.xcframework'
#   s.xcconfig = { 'OTHER_LDFLAGS' => '-framework DigiokycSDK' }
#   s.vendored_frameworks = 'DigiokycSDK.xcframework'

  # Inorder to add multiple frameworks
    s.preserve_paths = ['DigiokycSDK.xcframework', 'DigioEsignSDK.xcframework']
    s.xcconfig = { 'OTHER_LDFLAGS' => ['-framework DigiokycSDK', '-framework DigioEsignSDK'] }
    s.vendored_frameworks = ['DigiokycSDK.xcframework', 'DigioEsignSDK.xcframework']

end
