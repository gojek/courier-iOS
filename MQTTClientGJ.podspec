Pod::Spec.new do |mqttc|
	mqttc.name         = "MQTTClientGJ"
	mqttc.version      = "0.0.15"
	mqttc.summary      = "iOS, macOS and tvOS native ObjectiveC MQTT Client Framework"
	mqttc.homepage     = "https://github.com/gojek/courier-iOS"
	mqttc.license      = "EPLv1"
	mqttc.author       = { "Alfian Losari" => "alfian.losari@gojek.com" }
	mqttc.source       = {
		:git => "https://github.com/gojek/courier-iOS.git",
		:tag => "#{mqttc.version}"
	}

	mqttc.requires_arc = true
	mqttc.platform = :ios, "6.1"
	mqttc.ios.deployment_target = "6.1"

	mqttc.source_files = "Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTCFSocketDecoder.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTCFSocketEncoder.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTCFSocketTransport.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTCoreDataPersistence.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTDecoder.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTInMemoryPersistence.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTLog.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTStrict.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTClientGJ.h",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTMessage.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTPersistence.h",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSSLSecurityPolicy.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSSLSecurityPolicyDecoder.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSSLSecurityPolicyEncoder.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSSLSecurityPolicyTransport.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTProperties.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSession.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSessionLegacy.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSessionSynchron.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTTransport.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/GCDTimer.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/ReconnectTimer.{h,m}",
					"Internal/MQTT-Client-Framework/MQTTClientGJ/MQTTClientGJ/MQTTSessionManager.{h,m}"
					
end
