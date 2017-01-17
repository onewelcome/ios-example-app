source 'https://github.com/CocoaPods/Specs.git'

plugin 'cocoapods-art', :sources => [
 'onegini'
]

target 'OneginiExampleApp' do
  pod 'OneginiSDKiOSFIDO', '~> 5.01.02'
  pod 'ZFDragableModalTransition', '~> 0.6'
  pod 'MBProgressHUD', '~> 1.0.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == "Pods-OneginiExampleApp"
      puts "Updating #{target.name} OTHER_LDFLAGS"
      target.build_configurations.each do |config|
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig_file = File.open(xcconfig_path, 'r')
        xcconfig_file_temp = File.open(xcconfig_path.to_s + '.tmp', 'w')

        xcconfig_file.each_line do |line|
          line.sub! '-ObjC', '-force_load $(SRCROOT)/Pods/OneginiSDKiOSFIDO/libOneginiSDKiOSFIDO-5.01.02.a'
          xcconfig_file_temp.puts line
        end

        xcconfig_file.close
        xcconfig_file_temp.close

        File.rename(xcconfig_file_temp.path, xcconfig_file.path)
      end
    end
  end
end

# vi:syntax=ruby
