//
//  SubscribeData.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 16/06/22.
//

import Foundation

struct SubscribeData: Identifiable {
    let id = UUID()
    let topic: String
    let qos: Int
}
