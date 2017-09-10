
platform :ios, "9.0"

def tvist_pods
    pod 'Flurry-iOS-SDK/FlurrySDK'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SpaceView'
    pod 'DropDown'
    pod 'CocoaAsyncSocket' 
    pod 'Google/Analytics'
end

target 'TVist' do
    
    use_frameworks!
    tvist_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.1' # or '3.0'
        end
    end
end

