Pod::Spec.new do |c|
    c.name            = 'CourierCore'
    c.version         = '0.0.27'
    c.summary         = "Gojek iOS Long Run Connection Open Source SDK"
    c.description     = "Publish and Subscribe data with bidirectional communication between client and server"

    c.homepage        = 'https://github.com/gojek/courier-iOS'
    c.license         = 'MIT'
    c.author          = { "Alfian Losari" => "alfian.losari@gojek.com" }
    c.platform        = :ios, '14.0'

    c.source          = {
		:git => "https://github.com/gojek/courier-iOS.git",
		:tag => "#{c.version}"
	}
    c.swift_version   = '5.3'
    c.source_files    = 'CourierCore/**/*.swift'
end