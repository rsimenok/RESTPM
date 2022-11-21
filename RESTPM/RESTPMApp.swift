//
//  RESTPMApp.swift
//  RESTPM
//
//  Created by Roman Simenok on 19.11.2022.
//

import SwiftUI

@main
struct RESTPMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                RequestView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
