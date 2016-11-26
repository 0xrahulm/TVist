
platform :ios, "8.0"

def escape_pods
    pod 'Alamofire', '~> 3.5.0'
    pod 'AlamofireImage', '~> 2.0'
    pod 'SwiftyJSON', '~> 2.3.2'
    pod 'Locksmith', '~> 2.0.8'
    pod 'ionicons'
    pod 'RealmSwift'
end

target 'Escape' do
    
    use_frameworks!
    escape_pods
    
end

target 'Escape copy' do
    use_frameworks!
    escape_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3' # or '3.0'
        end
    end
end

