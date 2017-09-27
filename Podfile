
platform :ios, "10.0"

def tvist_pods
    pod 'Flurry-iOS-SDK/FlurrySDK'
    pod 'Fabric', '~> 1.6'
    pod 'Crashlytics', '~> 3.8.6'
    pod 'DropDown'
    pod 'CocoaAsyncSocket'
    pod 'SwipeCellKit'
    pod 'Google/Analytics'
end

target 'TVist' do
    
    use_frameworks!
    tvist_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2' # or '3.0'
        end
    end
end

