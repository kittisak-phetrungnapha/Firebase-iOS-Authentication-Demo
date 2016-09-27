platform :ios, '9.0'

target 'firebase authentication' do
  use_frameworks!
  
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'IQKeyboardManagerSwift'
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
