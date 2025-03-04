//
//  Detail.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 08.06.2023.
//

import SwiftUI

struct Detail: View {
    @Binding var showDetail :Bool
    @StateObject var viewModel:BooksViewModel
    var body: some View {
        NavigationView{
            VStack{
                AsyncImage(url: URL(string:viewModel.selectedBook?.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 300).padding()
                
                Text(viewModel.selectedBook?.title ?? "Unknown").padding()
                Text("Author:"+(viewModel.selectedBook?.author ?? "Unknown")).padding()
                if(viewModel.selectedBook?.genre != .None){
                    Text((viewModel.selectedBook?.genre.name.description ?? "Unknown")).padding().overlay(
                        RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray, lineWidth: 1)
                        )
                }
                
                Text("Publish date: "+(viewModel.selectedBook?.publishedDate ?? "Unknown"))
                Text("Read on: "+(viewModel.selectedBook?.readOn.formatted(date: .numeric, time: .omitted) ?? "Unkown"))
             
            }.navigationTitle(viewModel.selectedBook?.title ?? "Unknown")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                        Button("Back"){
                            showDetail = false
                        }
                    })
                }
        }
        
    }
}

//struct Detail_Previews: PreviewProvider {
//    static var previews: some View {
//        Detail()
//    }
//}
