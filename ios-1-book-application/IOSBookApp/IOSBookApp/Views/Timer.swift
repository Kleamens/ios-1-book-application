//
//  Timer.swift
//  IOSBookApp
//
//  Created by Maksym Zirchuk on 15.05.2023.
//

import SwiftUI


struct TimerView: View {
    @State var hours: String = "0"{
        didSet{
            if(hours.trimmingCharacters(in: .whitespaces) == ""){
                hours = "0"
            }
        }
    }
    @State var minutes :String = "0"{
        didSet{
            if(hours.trimmingCharacters(in: .whitespaces) == ""){
                hours = "0"
            }
        }
        
    }
    @State var secods :String  = "0"{
        didSet{
            if(hours.trimmingCharacters(in: .whitespaces) == ""){
                hours = "0"
            }
        }
       
    }
    
    @State var timerRunning:Bool = false
    
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    
    @State var invalidInput:Bool = true
    var body: some View {
        VStack{
            HStack{
                Text(hours.appending(" hours")).font(.largeTitle)
                Text(minutes.appending(" min")).font(.largeTitle)
                Text(secods.appending(" sec")).onReceive(timer){
                    _ in
                    if(timerRunning){
                        if(Int(secods) ?? 0<=0){
                            if(Int(minutes) ?? 0<=0){
                                if(Int(hours) ?? 0<=0){
                                    timerRunning = false
                                }else{
                                    var hourValue = Int(hours)
                                    hourValue! -= 1
                                    hours = hourValue?.description ?? "Fail"
                                    minutes = "59"
                                    secods = "59"
                                }
                            }else{
                                var minValue = Int(minutes)
                                minValue! -= 1
                                minutes = minValue?.description ?? "Fail"
                                secods = "59"
                                
                            }
                        }else{
                            var secValue  = Int(secods)
                            secValue! -= 1
                            secods = secValue?.description ?? "Fail"
                        }
                    }
                    
                }.font(.largeTitle)
                
            }
            HStack{
               Text("Hours")
                TextField("Hours", text: $hours).keyboardType(.numberPad).padding(.horizontal).frame(width: 100).textFieldStyle(.roundedBorder).onChange(of: hours){
                    newValue in
                    
                    if(Int(newValue) ?? 0 < 0){
                        invalidInput = true
                    }else{
                        invalidInput = false
                    }
                }
            
            }
            HStack{
               Text("Minutes")
                TextField("Minutes 0-59" , text: $minutes).keyboardType(.numberPad).padding(.horizontal).frame(width: 100).textFieldStyle(.roundedBorder).onChange(of: minutes){
                    newValue in
                    
                    if(Int(newValue) ?? 0 > 59 || Int(newValue) ?? 0 < 0){
                        invalidInput = true
                    }else{
                        invalidInput = false
                    }
                }
            }
            HStack{
               Text("Seconds")
                TextField("Seconds 0-59",text: $secods).keyboardType(.numberPad).padding(.horizontal).frame(width: 100).textFieldStyle(.roundedBorder).onChange(of: secods){
                    newValue in
                    
                    if(Int(newValue) ?? 0 > 59 || Int(newValue) ?? 0 < 0){
                        invalidInput = true
                    }else{
                        invalidInput = false
                    }
                }
            }
            
            
            
            
            HStack{
                Button("Start"){
                    timerRunning = true
                }.disabled(invalidInput)
                Button("Stop"){
                    if(timerRunning){
                        timerRunning = false
                    }
                }
                Button("Reset"){
                    timerRunning = false
                    hours="0"
                    minutes="0"
                    secods = "0"
                }
            }
        }
       
    }
}

//struct Timer_Previews: PreviewProvider {
//    static var previews: some View {
//        Timer()
//    }
//}
