source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

def applibs
  pod 'SeosMobileKeysSDK-Debug', :path  => 'Mobile_Keys_IOS_SDK/Debug/SeosMobileKeysSDK-Debug.podspec'
  pod 'AFNetworking', '~> 4.0'
  pod 'JSONModel'
  pod 'SwiftyUserDefaults', '~> 5.0'
  pod 'KeychainSwift', '~> 20.0'
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
