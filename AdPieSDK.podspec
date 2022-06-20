Pod::Spec.new do |spec|
  spec.name         = "AdPieSDK"
  spec.version      = "1.3.4"
  spec.summary      = "AdPie Ads SDK."
  spec.description  = "The AdPie SDK allows developers to easily incorporate banner, interstitial and native ads. It will benefit developers a lot."
  spec.homepage     = "https://github.com/gomfactory/AdPie-iOS-SDK"
  spec.license = {
    :type => 'commercial',
    :text => 'Copyright 2015 gomfactory. All rights reserved.'
  }
  spec.author             = "gomfactory"
  spec.platform     = :ios, "8.0"
  spec.ios.deployment_target = "8.0"
  spec.source       = { :git => "https://github.com/gomfactory/AdPie-iOS-SDK.git", :tag => spec.version.to_s }
  spec.ios.vendored_frameworks = "AdPieSDK/AdPieSDK.framework"
  spec.public_header_files = "AdPieSDK/AdPieSDK.framework/**/*.h"
  spec.source_files = "AdPieSDK/AdPieSDK.framework/**/*.h"
  spec.preserve_paths = "AdPieSDK/AdPieSDK.framework"
  spec.frameworks = "AdSupport", "CoreTelephony", "SystemConfiguration"
  spec.weak_frameworks = "WebKit"
  spec.xcconfig  =  { "OTHER_LDFLAGS" => "-ObjC", "LIBRARY_SEARCH_PATHS" => "$(SRCROOT)/Pods/AdPieSDK" }
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
