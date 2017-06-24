
platform :ios, "9.0"

def mizzle_pods
    pod 'Flurry-iOS-SDK/FlurrySDK'
    pod 'Fabric'
    pod 'AppsFlyerFramework'
    pod 'Crashlytics'
    pod 'SpaceView'
end

target 'Mizzle' do
    
    use_frameworks!
    mizzle_pods
end

target 'Mizzle copy' do
    use_frameworks!
    mizzle_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
        end
    end
end

