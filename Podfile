# source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

project 'FlexiPassApp', {
    'Debug' => :debug,
    'Release' => :release,
}

def applibs
  pod 'SeosMobileKeysSDK-Debug', :configuration => ['Debug'], :path  => 'Mobile_Keys_IOS_SDK/Debug/SeosMobileKeysSDK-Debug.podspec'
  pod 'SeosMobileKeysSDK-Release', :configuration => ['Release'], :path  => 'Mobile_Keys_IOS_SDK/Release/SeosMobileKeysSDK-Release.podspec'
  pod 'AFNetworking', '~> 4.0'
  pod 'JSONModel'
  pod 'SwiftyUserDefaults', '~> 5.0'
  pod 'KeychainSwift', '~> 20.0'
  pod 'SwiftyUserDefaults', '~> 5.0'
  pod 'PKHUD'
end

target 'FlexiPassApp' do
	workspace 'FlexiPassApp.xcworkspace'
  project 'FlexiPassApp.xcodeproj'
  applibs
end

target 'FlexiPassApp-SIT' do
  workspace 'FlexiPassApp.xcworkspace'
  project 'FlexiPassApp.xcodeproj'
  applibs
end

post_install do |installer| installer.pods_project.targets.each do |target| target.build_configurations.each do |config| config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO' end end end
