//
//  MQTTChuckViewModel.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 10/04/23.
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif


@available(iOS 15.0, *)
class MQTTChuckViewModel: ObservableObject, MQTTChuckLoggerDelegate {
    
    let logger: MQTTChuckLogger
    @Published var logs = [MQTTChuckLog]()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        return df
    }()
    
    init(logger: MQTTChuckLogger) {
        self.logger = logger
        self.logs = logger.logs.reversed()
        self.logger.delegate = self
    }
    
    func mqttChuckLoggerDidUpdateLogs(_ logs: [MQTTChuckLog]) {
        DispatchQueue.main.async { [weak self] in
            self?.logs = logs.reversed()
        }
    }
}
