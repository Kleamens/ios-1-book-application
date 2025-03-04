//
//  IOSBookAppApp.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import SwiftUI

@main
struct IOSBookAppApp: App {
    @StateObject private var dataController = CoreDataController()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: BooksViewModel()).environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
