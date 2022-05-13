Pod::Spec.new do |c|
    c.name            = 'CourierCore'
    c.version         = '0.0.1'
    c.summary         = "Go-jek's Internal iOS Long Run Connection SDK"
    c.description     = "Publish and Subscribe data with bidirectional communication between client and server"

    c.homepage        = 'https://github.com/gojek/courier-iOS'
    c.license         = 'MIT'
    c.author          = { "Alfian Losari" => "alfian.losari@gojek.com" }
    c.platform        = :ios, '11.0'

    c.source          = {
		:git => "git@github.com:gojek/courier-iOS.git",
		:tag => "0.0.1"
	}
    c.swift_version   = '5.3'
    c.source_files    = 'CourierCore/**/*.{h,m,swift}'
end