platform :ios, '14.0'
source 'https://cdn.cocoapods.org/'
# use_modular_headers!

def courier_pods
  pod 'ReachabilitySwift', '>= 5.0.0'
end

target 'CourierMQTT' do
  use_frameworks!
  courier_pods
end

target 'CourierProtobuf' do
  use_frameworks!
  pod 'SwiftProtobuf'
end

target 'CourierE2EApp' do
  use_frameworks!
  courier_pods
  pod 'SwiftProtobuf'
end

target 'CourierTests' do
  use_frameworks!
  courier_pods
  pod 'SwiftProtobuf'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end