//
//  SearchView.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel:BooksViewModel
    @Environment(\.managedObjectContext) var moc
    @State var inputvalue:String=""
    @State var books:[Book]? = []
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Title", text: $inputvalue).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal).onSubmit {
                    viewModel.getBooksWithApi(title: inputvalue, moc: moc)
                }
                
                
                
                
                List(viewModel.searchedBooks){item in
                    BookCard(title: item.title,
                             image: item.image,
                             readOn: item.readOn,
                             author: item.author,
                             publishedDate: item.publishedDate,adding: true,onTap: {viewModel.addFromSearch(book: item, moc: moc)}, viewModel: viewModel)
                }
                
                
            }.onDisappear{
                viewModel.searchedBooks = []
            }.scrollContentBackground(.hidden).navigationTitle("Search and add")
            
            
        }
    }
    
}

