Pod::Spec.new do |mqttc|
	mqttc.name         = "MQTTClientGJ"
	mqttc.version      = "0.0.22"
	mqttc.summary      = "iOS, macOS and tvOS native ObjectiveC MQTT Client Framework"
	mqttc.homepage     = "https://github.com/gojek/courier-iOS"
	mqttc.license      = "EPLv1"
	mqttc.author       = { "Alfian Losari" => "alfian.losari@gojek.com" }
	mqttc.source          = { http: "http://artifactory-gojek.golabs.io/artifactory/gojek-ios-pods/MQTTClientGJ/MQTTClientGJ_#{mqttc.version}.tar.gz" }
	mqttc.platform        = :ios, '12.0'

	mqttc.requires_arc = true
	mqttc.vendored_frameworks = 'MQTTClientGJ.xcframework'
end