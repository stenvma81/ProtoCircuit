//
//  ProtoCircuitApp.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 15.11.2025.
//

import SwiftUI

@main
struct MyApp: App {
    let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}

