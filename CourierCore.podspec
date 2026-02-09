Pod::Spec.new do |c|
    c.name            = 'CourierCore'
    c.version         = '1.0.6'
    c.summary         = "Gojek iOS Long Run Connection Open Source SDK"
    c.description     = "Publish and Subscribe data with bidirectional communication between client and server"

    c.homepage        = 'https://github.com/gojek/courier-iOS'
    c.license 	      = { :type => 'MIT', :file => './LICENSES/LICENSE' }
    c.author          = "Gojek"
    c.platform        = :ios, '15.0'

    c.source          = {
		:git => "https://github.com/gojek/courier-iOS.git",
		:tag => "#{c.version}"
	}
    c.swift_version   = ['6.0', '5.3']
    c.source_files    = 'CourierCore/**/*.swift'
end