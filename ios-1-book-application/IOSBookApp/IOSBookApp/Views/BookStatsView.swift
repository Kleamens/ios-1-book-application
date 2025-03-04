//
//  Stats.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 15.05.2023.
//

import SwiftUI
import Charts

struct BookStatsView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books:
    FetchedResults<Databasebook>
    
    
    @StateObject var viewModel : BooksViewModel
    @State var maxmin:[String:Int] = [:]
    var body: some View {
        NavigationView{
            VStack{
                Chart{
                    ForEach(Month.allCases){i in
                        BarMark(
                            x: .value("Month",DateFormatter().shortMonthSymbols[i.rawValue-1]),
                            y: .value("Value", viewModel.amountOfBooksInMonth(month: i))
                        )
                    }
                }.foregroundColor(.gray).frame(height: 250).padding()
            
                Text("Biggest amount in one month \(maxmin["Maximum"]?.description ?? "0")").padding()
                Text("Smallest amount in one month \(maxmin["Minimum"]?.description ?? "0")").padding()
            
            }
                
            }.onAppear{
                viewModel.convertToBooks(databaseBooks: books)
                maxmin = viewModel.getAbsoluteAmount()
            }
        }
    }


