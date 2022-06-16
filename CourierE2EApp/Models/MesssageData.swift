//
//  MesssageData.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 16/06/22.
//

import Foundation

struct MessageData: Identifiable {
    let id = UUID()
    let topic: String
    let qos: Int
    let message: String
    let timestamp: Date
}
