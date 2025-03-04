//
//  CustomNavBar.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 15.05.2023.
//

import SwiftUI

enum Tab:String, CaseIterable
{
    case house
    case magnifyingglass

    case tablecells
    case clock
    
}

struct CustomNavBar: View {
    @Binding var selectedTab:Tab
    private var fillImage:String{
        selectedTab.rawValue+".fill"
    }
    var body: some View {
        VStack{
            HStack{
                ForEach(Tab.allCases,id:\.rawValue){
                    tab in
                    Spacer()
                    Image(systemName:tab.rawValue)
                        
                        .padding(12)
                        .background(selectedTab == tab ? .gray : .clear)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.2)){
                                selectedTab = tab
                            }
                            	
                        }
                    Spacer()
                }
                
            }.frame(width: nil,height: 60)
                .background(.thinMaterial)
                .cornerRadius(10)
                .padding()
        }
    }
}

struct CustomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBar(selectedTab:.constant(.house))
    }
}
