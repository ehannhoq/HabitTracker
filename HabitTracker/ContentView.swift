//
//  ContentView.swift
//  HabitTracker
//
//  Created by Ehan Haque on 11/25/24.
//

import SwiftUI

enum Page {
    case mainPage
    case habitList
}


struct ContentView: View {
    @State private var currentPage: Page = .mainPage
    
    var body: some View {
        VStack {
            switch currentPage {
            case .mainPage:
                MainPage(currentPage: $currentPage)
            case .habitList:
                HabitList(currentPage: $currentPage)
            }
        }
    }
}
struct MainPage: View {
    @Binding var currentPage: Page
    @State var emotion: Emotion = Emotion.Sad
    @State var cat: String = "🐈"

    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    currentPage = .habitList
                }) {
                    Text("Habits")
                        .padding()
                        .foregroundStyle(.green)
                }
                
                Spacer()
            }
            .padding()

            Spacer()
            GetEmotion(emotion)
            Spacer()
            Text(cat)
                .font(.system(size: 100))
            Spacer()
            Spacer()
        }
        .navigationTitle("Main Page")
        .navigationBarHidden(true)
 
    }
}

struct HabitList: View {
    @Binding var currentPage: Page
    @State var habits: [Habit] = [
        Habit(name: "Sleep", importance: HabitImportance.High, frequency: 7, completed: false)
    ]
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    currentPage = .mainPage
                }) {
                    Text("Back")
                        .padding()
                        .foregroundStyle(.gray)
                }
                Spacer()
            }
            .padding()
            
            NavigationStack {
                List(habits, id: \.name) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        if habit.completed {
                            Text("Completed")
                                .foregroundStyle(.green)
                        }
                        else
                        {
                            Text("Incomplete")
                                .foregroundStyle(.red)
                        }
                        Spacer()

                    }
                }
            }
        }
        .navigationTitle("Habits")
        .navigationBarHidden(true)
    }
}




#Preview {
    ContentView()
}
