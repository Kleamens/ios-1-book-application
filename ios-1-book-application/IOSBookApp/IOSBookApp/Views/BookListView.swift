//
//  BookListView.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import SwiftUI
import UIKit

struct BookListView: View {
    
    
    
    @State var showAdd : Bool = false
    @State var showStas : Bool = false
    @State var showSearch : Bool = false
    @State var showDetail : Bool = false
    
    @State var inputvalue:String=""
        
    
    @State var searching:Bool = false
  
          
       
       
    
    @State var books_search:[Book] = []
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books:
    FetchedResults<Databasebook>
    
    
    @StateObject var viewModel : BooksViewModel
    
    
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical){
                TextField("Search in your collection", text: $inputvalue).textFieldStyle(RoundedBorderTextFieldStyle()).onSubmit {
                    books_search = viewModel.convertDatabaseBookArrayToBookArray(databasebooks: viewModel.getBooksByTitle(title: inputvalue, moc: moc)) ?? []
                    searching = true
                }.clearButton(text: $inputvalue).padding(.horizontal).onChange(of: inputvalue, perform: { newValue in
                    if(newValue == ""){
                        searching = false
                    }
                })
                if(searching){
                    if(books_search.isEmpty ){
                        Text("No books were found")
                    }
                    LazyVGrid(columns:[ GridItem(.fixed(200)),
                                        GridItem(.fixed(200))],spacing: 2){
                        ForEach(books_search){book in
                            
                            BookCard(
                                title: book.title,
                                image: book.image,
                                readOn: book.readOn,
                                author: book.author,
                                publishedDate: book.publishedDate, viewModel: viewModel).onTapGesture {
                                    viewModel.selectBook(book: book)
                                    showDetail = true
                                }
                            
                            
                        }.scrollContentBackground(.hidden)
                    }.sheet(isPresented: $showDetail){
                        Detail(showDetail: $showDetail, viewModel: viewModel)
                           
                        
                    }
                                                
                }else{
                    LazyVGrid(columns:[ GridItem(.fixed(200)),
                                        GridItem(.fixed(200))],spacing: 2){
                
                        ForEach(viewModel.books){book in
                            
                            BookCard(
                                title: book.title,
                                image: book.image,
                                readOn: book.readOn,
                                author: book.author,
                                publishedDate: book.publishedDate, viewModel: viewModel).onTapGesture {
                                    viewModel.selectBook(book: book)
                                    showDetail = true
                                }
                            
                            
                        }.scrollContentBackground(.hidden)
                    }.sheet(isPresented: $showDetail){
                        Detail(showDetail: $showDetail, viewModel: viewModel)
                            
                            
                                                
                    }.sheet(isPresented: $showAdd){
                        AddBookView(bookGenre: .Detective, showAdd: $showAdd, viewModel: viewModel)
                    }.navigationTitle("Book List")
                        .toolbar{
                            ToolbarItemGroup(placement: .navigationBarTrailing){
                                Button("Add"){
                                    showAdd = true
                                }.padding(.horizontal,20).foregroundColor(.gray).overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                                .stroke(.gray, lineWidth: 1)
                                )
                            }
                        }
                }
                
                
                
                
                
            }.scrollContentBackground(.hidden)
            //  https://books.google.com/books/content?id=qK3bDAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api
            // http://books.google.com/books/content?id=qK3bDAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api
                
            
        }.onAppear(){
            viewModel.callAPI()
            if(books.isEmpty){
                
                viewModel.addInitialData(moc: moc)
                print("Die")
                
            }
            viewModel.books.forEach{
                i in
                print(i.image)
            }
            
            
            
            viewModel.convertToBooks(databaseBooks: books)
            
            
        }
    }
    
    
}


