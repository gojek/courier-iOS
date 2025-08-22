Pod::Spec.new do |c|
    c.name            = 'CourierMQTT'
    c.version         = '0.0.27'
    c.summary         = "Gojek iOS Long Run Connection Open Source SDK"
    c.description     = "Publish and Subscribe data with bidirectional communication between client and server"
  
    c.homepage        = 'https://github.com/gojek/courier-iOS'
    c.license         = 'MIT'
    c.author          = "Gojek"
    c.platform        = :ios, '13.0'
  
    c.source          = {
		:git => "https://github.com/gojek/courier-iOS.git",
		:tag => "#{c.version}"
	}
    c.swift_version = ['6.0', '5.3']
    c.static_framework = true
    c.source_files = "CourierMQTT/**/*.swift"

    c.dependency 'CourierCore', "#{c.version}"
    c.dependency 'MQTTClientGJ', "#{c.version}"
    c.dependency 'ReachabilitySwift', '>= 5.0.0'
    c.dependency 'RxSwift', '>= 6.9.0'
end