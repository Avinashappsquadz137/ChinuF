# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'ChinuFilms' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChinuFilms
pod 'Alamofire'
pod 'SDWebImage'
pod 'IQKeyboardManagerSwift'
pod 'iOSDropDown'
#pod 'HorizonCalendar'

 # Firebase Configure
pod 'Firebase/Analytics'
pod 'Firebase/Messaging'
pod 'Firebase/Auth'
pod 'KVKCalendar'
pod 'DGCharts', '~> 5.1'
pod 'FSCalendar'
pod 'MarqueeLabel'
pod 'DropDown'
pod 'TagListView'


end
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
      end
    end
  end

  fuse_path = "./Pods/HyperSDK/Fuse.rb"
  clean_assets = true # Pass true to re-download all the assets
  if File.exist?(fuse_path)
    system("ruby", fuse_path.to_s, clean_assets.to_s)
  end
end
