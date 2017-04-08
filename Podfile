
platform :ios, "9.0"

def escape_pods
    pod 'Alamofire', '~> 4'
    pod 'AlamofireImage', '~> 3'
    pod 'SwiftyJSON', '~> 3'
    pod 'Locksmith', '~> 3'
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
            config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
        end
    end
end

