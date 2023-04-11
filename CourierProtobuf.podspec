Pod::Spec.new do |c|
    c.name            = 'CourierProtobuf'
    c.version         = '0.0.17'
    c.summary         = "Gojek iOS Long Run Connection Open Source SDK"
    c.description     = "Publish and Subscribe data with bidirectional communication between client and server"
  
    c.homepage        = 'https://github.com/gojek/courier-iOS'
    c.license         = 'MIT'
    c.author          = { "Alfian Losari" => "alfian.losari@gojek.com" }
    c.platform        = :ios, '11.0'
  
    c.source          = {
		:git => "https://github.com/gojek/courier-iOS.git",
		:tag => "#{c.version}"
	}
    c.swift_version   = '5.3'

    c.source_files = "CourierProtobuf/**/*.{h,m,swift}"

    c.dependency 'CourierCore', "#{c.version}"
    c.dependency 'CourierMQTT', "#{c.version}"
    c.dependency 'SwiftProtobuf'
end
  
