Pod::Spec.new do |mqttc|
	mqttc.name         = "MQTTClientGJ"
	mqttc.version      = "0.0.27"
	mqttc.summary      = "iOS, macOS and tvOS native ObjectiveC MQTT Client Framework"
	mqttc.homepage     = "https://github.com/gojek/courier-iOS"
	mqttc.license      = "EPLv1"
	mqttc.author       = { "Alfian Losari" => "alfian.losari@gojek.com" }
	mqttc.source       = {
		:git => "https://github.com/gojek/courier-iOS.git",
		:tag => "#{mqttc.version}"
	}
	mqttc.platform        = :ios, '14.0'

	mqttc.requires_arc = true
	mqttc.vendored_frameworks = 'MQTTClientGJ.xcframework'
end
