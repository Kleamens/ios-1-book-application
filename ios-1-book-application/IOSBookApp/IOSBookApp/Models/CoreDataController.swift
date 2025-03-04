//
//  CoreDataController.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import Foundation
import CoreData


class CoreDataController:ObservableObject{
    let container = NSPersistentContainer(name:"Books")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
}
