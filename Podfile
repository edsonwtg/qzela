# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'qzela' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'GoogleMaps', '~> 6.0.0'
  pod 'GooglePlaces', '6.0.0'
  pod 'Firebase/Storage'
  pod "Apollo"
  pod "Apollo/WebSocket"
  pod 'Alamofire', '~> 5.4'
  pod 'NVActivityIndicatorView'
  pod 'AnyFormatKit', '~> 2.5.2'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['LD_NO_PIE'] = 'NO'
        end
    end
end
