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
    
    @AppStorage("appColorScheme") private var appColorScheme: String = "system"

    var colorScheme: ColorScheme? {
        switch appColorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .preferredColorScheme(colorScheme)
        }
    }
}

