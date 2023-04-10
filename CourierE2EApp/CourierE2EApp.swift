//
//  CourierE2EAppApp.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 13/06/22.
//

import SwiftUI

@main
struct CourierE2EApp: App {
    
    let logger = MQTTChuckLogger.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ConnectionFormView()
            }
        }
    }
}
