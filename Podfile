# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Rise' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Rise
pod 'SPStorkController'
pod 'NotificationBannerSwift'
pod 'AnimatedGradientView', :git => 'https://github.com/rwbutler/AnimatedGradientView.git', :branch => 'swift-5'
pod 'AIFlatSwitch'
pod 'RealmSwift'
pod 'Alamofire'
pod 'SwiftyJSON'

  target 'RiseTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RiseUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['LD_NO_PIE'] = 'NO'
        end
    end
end
