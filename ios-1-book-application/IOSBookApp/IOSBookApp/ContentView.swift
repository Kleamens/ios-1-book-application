//
//  ContentView.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 28.04.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: BooksViewModel
    @State var selectedTab:Tab = .house
    var body: some View {
        ZStack{
            TabView(selection: $selectedTab){
                switch(selectedTab){
                case .house:
                    BookListView(viewModel: viewModel)
                
                case.magnifyingglass:
                    SearchView(viewModel: viewModel)
                
                case.clock:
                    TimerView()
                    
                case.tablecells:
                    BookStatsView(viewModel: viewModel)
                
                }
            }
        }
        VStack{
           
            CustomNavBar(selectedTab: $selectedTab)
        }
        
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: BooksViewModel())
    }
}
