source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

plugin 'cocoapods-art', :sources => [
 'onegini',
 'onegini-snapshot'
]

target 'OneginiExampleApp' do
  pod 'OneginiSDKiOS', '7.1.1-SNAPSHOT'
  pod 'ZFDragableModalTransition', '~> 0.6'
  pod 'MBProgressHUD', '~> 1.0.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end
