//
//  AddBookView.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import SwiftUI

struct AddBookView: View {
    @State var bookTitle:String = ""
    @State var bookAuthor:String = ""
    @State var bookImage:UIImage =  UIImage()
    @State var bookGenre:Book.Genres
    @State var bookAdditionalInfo:String = ""
    @Binding var showAdd :Bool
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books:
    FetchedResults<Databasebook>
    
    @State var bookReadDate:Date = Date.now
    
    @State var authorError:String = "Author cant be empty"{
        didSet{
            pass = authorError.isEmpty && titleError.isEmpty
        }
    }
    @State var titleError:String  = "Title cant be empty"{
        didSet{
            pass = authorError.isEmpty && titleError.isEmpty
        }
    }
    
    @StateObject var viewModel:BooksViewModel
    
    @State var pass:Bool = false
    var body: some View {
        NavigationView{
            
            Form{
                Section{
                    
                        TextField("Book Title*" ,text: $bookTitle).onChange(of: bookTitle) { [bookTitle] newValue in
                            
                            if newValue.isEmpty{
                                titleError = "Title cant be empty"
                            }else{
                                titleError = ""
                            }
                            // do any validation or alteration here.
                            // 'text' is the old value, 'newValue' is the new one.
                        }
                        if(!titleError.isEmpty){
                            Text(titleError).foregroundColor(.red)
                        }
                    
                    
                    
                    
                    
                    
                            TextField("Book Author*" ,text: $bookAuthor).onChange(of: bookAuthor) { [bookAuthor] newValue in
                                // do any validation or alteration here.
                                // 'text' is the old value, 'newValue' is the new one.
                                if newValue.isEmpty{
                                    authorError = "Author cant be empty"
                                }else{
                                    authorError = ""
                                }
                            }
                            if(!authorError.isEmpty){
                                Text(authorError).foregroundColor(.red)
                            }
                        }
                        
                        
                    
                    
                
                
                Section{
                    DatePicker(selection:$bookReadDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Read on")
                    }
                    
                    Picker("Genre",selection:$bookGenre){
                        ForEach(Book.Genres.allCases){
                            option in
                            Text(option.name)
                        }
                    }
                    
                    
                    
                   
                }
                
               
                       
                
                
            }
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button("Add"){
                            viewModel.addBook(book: Book(id: UUID(),
                                                         author: bookAuthor,
                                                         title: bookTitle,
                                                         image: "",
                                                         genre: bookGenre,
                                                         addionalInfo: bookAdditionalInfo,
                                                         readOn: bookReadDate, publishedDate: ""),
                                              moc: moc)
                            viewModel.convertToBooks(databaseBooks: books)
                        }.padding(.horizontal,20).disabled(!pass).overlay(alignment: .center,content:{
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray, lineWidth: 1)
                        })
                    }
                }
            
         
    
            
            
            
            
            
        }
        
        
    }
    
}
            
            
        




