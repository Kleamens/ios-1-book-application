//
//  BookCard.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 05.06.2023.
//

import SwiftUI

struct BookCard: View {
    var title:String
    var image:String
    var readOn:Date
    var author:String
    var publishedDate:String
    
    var adding:Bool = false
    @State var added:Bool = false
    
    
    
    var onTap:()->Void = {}
    
    @StateObject var viewModel : BooksViewModel
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books:
    FetchedResults<Databasebook>
    
    
    var body: some View {
        VStack{
            
            Text(title ?? "Nothing").padding(.top,10)
            Divider()
            
            
            if(image == "Unknown"){
                Image(uiImage: UIImage(named: "placeholder")!).resizable().scaledToFit().frame(width: 150,height: 300).clipped()
            }
            else{
                AsyncImage(url: URL(string:image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
            }
            
            
            Text(author == "" ? "Author:Unknown" : "Author:"+author).padding(.bottom,10)
            
            if(adding){
                
                if(added){
                    Image(systemName: "checkmark").padding()
                }else{
                    Image(systemName: "plus").padding().onTapGesture {
                        added = true
                       onTap()
                        
                    }
                }
                
            }
            
            
        }.onAppear{
            added = viewModel.isBookinCD(databasebooks: viewModel.getBooksByTitle(title: title, moc: moc), title: title, moc: moc)
        }.padding(.all,8)
            .background(.thinMaterial).clipShape(RoundedRectangle(cornerSize:CGSize(width: 5, height: 5))).foregroundColor(.gray).padding()
        
        
    }
    
    
}
