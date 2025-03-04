//
//  Book.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import Foundation
import SwiftUI

struct Book:Identifiable{
    let id:UUID
    var author:String
    var title:String
    var image :String
    var genre:Genres
    var addionalInfo:String
    var readOn:Date
    var publishedDate :String
    
    
    enum Genres:Int16,Identifiable,CaseIterable{
        case None = 0
        case Detective = 1
        case Thriller = 2
        case Mystery = 3
        case Horror = 4
        
        var id:Self{self}
        
        var name:String{
            get{return String(describing: self)}
        }
        
    }
}
