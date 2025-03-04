//
//  BooksViewModel.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import Foundation
import SwiftUI
import CoreData

class BooksViewModel: ObservableObject {
    @Published var books:[Book] = []
    @Published var selectedBook: Book?
    @Published var searchedBooks:[Book] = []
    func selectBook(book:Book) {
        selectedBook = book
    }
    
    
    
    func convertToBooks(databaseBooks: FetchedResults<Databasebook>){
        books=databaseBooks.map{
            let image = $0.image
            // proc to tady pada do else???
            
            
            return Book(id: $0.id ?? UUID()
                        , author: $0.author ?? "Unknown author",
                        title: $0.title ?? "Unkonown title",
                        image: image ?? "" ,
                        genre: Book.Genres(rawValue: $0.genre) ?? .Horror,
                        addionalInfo: $0.addionalInfo ?? "No additional info",
                        readOn: $0.readOn ?? Date.now, publishedDate: $0.publishedOn ?? "Unknown"
            )
        }
    }
    
    func addBook(book:Book,moc:NSManagedObjectContext){
        let databaseBook :Databasebook = Databasebook(context:moc)
        
        databaseBook.title = book.title
        databaseBook.genre = book.genre.rawValue
        databaseBook.author = book.author
        databaseBook.id = book.id
        
        databaseBook.addionalInfo = book.addionalInfo
        databaseBook.readOn = book.readOn
        serializeAPIResponse(dbBook: databaseBook, moc: moc)
        
        
        
    }
    
    
    func addFromSearch(book:Book,moc:NSManagedObjectContext){
        let databaseBook :Databasebook = Databasebook(context:moc)
        
        databaseBook.title = book.title
        databaseBook.genre = book.genre.rawValue
        databaseBook.author = book.author
        databaseBook.id = book.id
        
        databaseBook.addionalInfo = book.addionalInfo
        databaseBook.readOn = book.readOn
        databaseBook.image = book.image
        databaseBook.publishedOn = book.publishedDate
        save(moc: moc)
        
        
    }
    func save(moc: NSManagedObjectContext){
        if moc.hasChanges {
            do {
                try moc.save()
            } catch  {
                print(error)
            }
        }
    }
    //you need to change http to https in order to properly load the image
    func addInitialData(moc: NSManagedObjectContext) {
        let testBook = Book(id: UUID(),
                            author: "Joe mama",
                            title: "kill me",
                            image: "https://books.google.com/books/content?id=qK3bDAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
                            genre: .Detective,
                            addionalInfo: "Idk",
                            readOn: Date.now, publishedDate: "1020")
        
        
        addBook(book: testBook
                , moc: moc)
        
    }
    
    func getBooksByTitle(title:String,moc: NSManagedObjectContext)-> [Databasebook]?{
        var request = Databasebook.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title.description)
        guard let items = try? moc.fetch(request) else { return nil }
        return items
    }
    
    func convertDatabaseBookArrayToBookArray(databasebooks:[Databasebook]?)->[Book]?{
        var books = databasebooks?.map{
            let image = $0.image
            // proc to tady pada do else???
            
            
            return Book(id: $0.id ?? UUID()
                        , author: $0.author ?? "Unknown author",
                        title: $0.title ?? "Unkonown title",
                        image: image! ,
                        genre: Book.Genres(rawValue: $0.genre) ?? .Horror,
                        addionalInfo: $0.addionalInfo ?? "No additional info",
                        readOn: $0.readOn ?? Date.now, publishedDate: $0.publishedOn ?? "Unkonwn"
                        
                        
            )
        }
        return books
        
    }

   
    func isBookinCD(databasebooks:[Databasebook]?,title:String,moc: NSManagedObjectContext)->Bool{
        return convertDatabaseBookArrayToBookArray(databasebooks: getBooksByTitle(title: title, moc: moc))?.contains(where: { Book in
            Book.title == title
        }) ?? false
    }
    
    
    
    
    //test comunication
    func callAPI(){
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=harry+potter&callback=handleResponse") else{
            return
        }


        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let data = data, let string = String(data: data, encoding: .utf8){
                print(string)
            }
        }

        task.resume()
    }
    
    func serializeAPIResponse(dbBook:Databasebook,moc:NSManagedObjectContext){
        let title = dbBook.title?.replacingOccurrences(of: " ", with: "+")
        let urlStr = "https://www.googleapis.com/books/v1/volumes?q="+title!
        guard let url = URL(string:urlStr ) else{
            print("\(dbBook.title?.replacingOccurrences(of: " ", with: "+"))")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            
            let decoder = JSONDecoder()
            
            if let data = data{
                        do{
                            let tasks = try decoder.decode(GoogleBook.self, from: data)
                            let image = tasks.items?.first(where: {
                                $0.volumeInfo?.imageLinks?.smallThumbnail != nil
                            })?.volumeInfo?.imageLinks?.smallThumbnail?.replacingOccurrences(of: "http", with: "https") ?? "Unknown"
                            let year = tasks.items?.first(where: {
                                $0.volumeInfo?.publishedDate != nil
                            })?.volumeInfo?.publishedDate
                            
                            
                            dbBook.image = image
                            dbBook.publishedOn = year
                            self.save(moc: moc)
                            print(image)
                            
//
                            
                            
                            
                        }catch{
                            print(error)
                        }
                    }
        }
        task.resume()
        
    }
    
    func getBooksWithApi(title:String,moc:NSManagedObjectContext){
        let title = title.replacingOccurrences(of: " ", with: "+")
        let urlStr = "https://www.googleapis.com/books/v1/volumes?q="+title
        guard let url = URL(string:urlStr ) else{
            print("\(title.replacingOccurrences(of: " ", with: "+"))")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            
            let decoder = JSONDecoder()
            
            if let data = data{
                        do{
                            self.searchedBooks.removeAll()
                            let tasks = try decoder.decode(GoogleBook.self, from: data)
                            let count = tasks.items?.count ?? 0
                            print(count)
                            for  i in 0...count-1{
                                self.searchedBooks.append( Book(id: UUID(),
                                                                author: tasks.items?[i].volumeInfo?.authors?.joined(separator:",") ?? "Unknown",
                                                                title: tasks.items?[i].volumeInfo?.title ?? "Unknown",
                                                                image: tasks.items?[i].volumeInfo?.imageLinks?.smallThumbnail?.replacingOccurrences(of: "http", with: "https") ?? "Unknown",
                                                                genre: .None,
                                                                addionalInfo: tasks.items?[i].volumeInfo?.description ?? "",
                                                                readOn: Date.now,
                                                                publishedDate: tasks.items?[i].volumeInfo?.publishedDate ?? "Unknown"))
                                print("Success \(i.description)")
                                
                            }
                        }catch{
                            print(error)
                        }
                    }
        }
        task.resume()
        
    }
    
    func amountOfBooksInMonth(month:Month)->Int{
        
        books.filter({
            Calendar.current.dateComponents([.month], from: $0.readOn).month == month.rawValue
        }).count
    }
    func getAbsoluteAmount() -> [String:Int]{
        var maximum = 0
        var minimum = 0
        
        let groupByCategory = Dictionary(grouping: books) { book in
            return Calendar.current.dateComponents([.month], from: book.readOn).month
        }
        print(groupByCategory)
        
            maximum = groupByCategory.max(by: { (one,two) in
                one.value.count >  two.value.count
                
            })?.value.count ?? 0
        
            minimum = groupByCategory.values.min(by: { (one,two) in
                one.count < two.count
                
            })?.count ?? 0
        
        if(minimum == maximum){
            minimum = 0
        }
        return ["Maximum":maximum,"Minimum":minimum]
        
    }
    }

//todo make it so that http is changed to https in url
enum Month:Int,Identifiable,CaseIterable{
    
    var id:Self{
        return self
    }
    
    case January = 1
    case February = 2
    case March = 3
    case April = 4
    case May = 5
    case June = 6
    case July = 7
    case August = 8
    case September = 9
    case October = 10
    case November = 11
    case December = 12
}
