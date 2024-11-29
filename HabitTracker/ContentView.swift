//
//  ContentView.swift
//  csfair2024
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
    @StateObject private var habitList: ListOfHabits = ListOfHabits(
        habits: [
            Habit(name: "Exercise", frequency: 4, frequencyType: FrequencyType.Weekly),
            Habit(name: "Meditate", frequency: 1, frequencyType: FrequencyType.Daily),
            Habit(name: "Work", frequency: 7, frequencyType: FrequencyType.Weekly),
            Habit(name: "Read", frequency: 2, frequencyType: FrequencyType.Daily)
            ]
        )
    
    
    var body: some View {
        ZStack {
            switch currentPage {
            case .mainPage:
                MainPage(currentPage: $currentPage, habitList: habitList)
                    .transition(.move(edge: .trailing))
            case .habitList:
                HabitList(currentPage: $currentPage, habits: habitList)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: currentPage)
    }
}

struct MainPage: View {
    @Binding var currentPage: Page
    @ObservedObject var habitList: ListOfHabits
    
    @State var emotion: Emotion = Emotion.Sad
    @State var cat: String = "🐈"

    var body: some View {
        
        ScrollView {
            VStack {
                HStack {
                    Button(action: {
                        currentPage = .habitList
                    }) {
                        Text("Habits")
                            .padding()
                            .foregroundStyle(.green)
                    }
                    .bold()
                    
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
            
            let dailyTasks = habitList.habits.filter { $0.frequencyType == .Daily}
            let weeklyTasks = habitList.habits.filter { $0.frequencyType == .Weekly}
            
            
            
            // TODO: SwiftUI is not immedietly updating a task is completed, but will update if the user switches to the Habits tab then back.
            
            VStack {
                HStack {
                    Text("Daily Tasks")
                    Spacer()
                }
                .font(.title)
                
                ForEach (dailyTasks) { habit in
                    HStack {
                        Text(habit.name)
                            .font(.title2)
                        Spacer()
                        
                        ForEach (habit.completedBools.indices, id: \.self) { i in
                            Button(action: {
                                habit.toggleCompletion(forIndex: i)
                                print(habit.completedBools)
                            }) {
                                Circle()
                                    .fill(habit.completedBools[i] ? Color.green : Color.red)
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                }
            }
            .padding(32)
            
            VStack {
                HStack {
                    Text("Weekly Tasks")
                    Spacer()
                }
                .font(.title)
                
                ForEach (weeklyTasks) { habit in // TODO: Fix the ForEach as they do not properly update the booleans as well as the UI.
                    HStack {
                        Text(habit.name)
                            .font(.title2)
                        Spacer()
                        
                        ForEach (habit.completedBools.indices, id: \.self) { i in
                            Button(action: {
                                habit.toggleCompletion(forIndex: i)
                                print(habit.completedBools)
                            }) {
                                Circle()
                                    .fill(habit.completedBools[i] ? Color.green : Color.red)
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                }
            }
            .padding(32)
            
            
            
            
        }
        .defaultScrollAnchor(.top)

    }
}

struct HabitList: View {
    @Binding var currentPage: Page
    @ObservedObject var habits: ListOfHabits

    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    currentPage = .mainPage
                }) {
                    Text("Back")
                        .padding()
                        .foregroundStyle(.gray)
                }

            }
            .padding()
            
            NavigationStack {
                List(habits.habits, id: \.name) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        Text(habit.frequencyType.rawValue)

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
