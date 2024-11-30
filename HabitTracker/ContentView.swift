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
    case initNyabit
}


struct ContentView: View {
    @State private var currentPage: Page = .habitList
    @StateObject private var nyabit: Nyabit = Nyabit(name: "Carl")
    @StateObject private var habitList: ListOfHabits = ListOfHabits(
        habits: [
            Habit(name: "Exercise", frequency: 4, frequencyType: FrequencyType.Weekly),
            Habit(name: "Meditate", frequency: 1, frequencyType: FrequencyType.Daily),
            Habit(name: "Work", frequency: 7, frequencyType: FrequencyType.Weekly),
            Habit(name: "Read", frequency: 2, frequencyType: FrequencyType.Daily)
            ]
        )
    
    private var resolvedPage: Page {
        nyabit.name == "NOT SET" ? .initNyabit : currentPage
    }
    
    var body: some View {
        ZStack {
            switch resolvedPage {
            case .mainPage:
                MainPage(currentPage: $currentPage, nyabit: nyabit, habitList: habitList)
                    .transition(.move(edge: .trailing))
            case .habitList:
                HabitList(currentPage: $currentPage, habits: habitList)
                    .transition(.move(edge: .leading))
            case .initNyabit:
                InitializeNyabit(currentPage: $currentPage, nyabit: nyabit)
            }
        }
        .animation(.easeInOut, value: currentPage)
    }
}

struct MainPage: View {
    @Binding var currentPage: Page
    @ObservedObject var nyabit: Nyabit
    @ObservedObject var habitList: ListOfHabits


    var body: some View {
        
        ScrollView {
            VStack (alignment: .center) {
                HStack {
                    Button(action: {
                        currentPage = .habitList
                    }) {
                        Text("My Nyabits")
                            .foregroundStyle(.blue)
                    }
                    .bold()
                    Spacer()
                }
                
                GeometryReader { geometry in
                    TextField("", text: Binding(
                        get: { nyabit.name },
                        set: {
                            var name = $0
                            if name == "" {
                                name = "Nyabit"
                            }
                            nyabit.name = name
                        }
                    ))
                        .padding(.top, 140)
                        .font(.system(size: 28))
                        .frame(width: geometry.size.width)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 170)
         
                
                nyabit.getEmotion()
                    .font(.system(size: 20))
                    .padding(.bottom, 32)
                
                Text(nyabit.getSymbol())
                    .font(.system(size: 100))
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 32)
            .padding(.bottom, 330)
            .navigationTitle("Main Page")
            .navigationBarHidden(true)
            
            let dailyTasks = habitList.habits.filter { $0.frequencyType == .Daily}
            let weeklyTasks = habitList.habits.filter { $0.frequencyType == .Weekly}
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Today")
                .font(.title)
                
                if (!dailyTasks.isEmpty)
                {
                    ForEach (dailyTasks) { habit in
                        HStack {
                            Text(habit.name)
                                .font(.title2)
                            Spacer()
                            ForEach (habit.completedBools.indices, id: \.self) { i in
                                Button(action: {
                                    habit.toggleCompletion(forIndex: i)
                                    habitList.updateHabits()
                                }) {
                                    Circle()
                                        .fill(habit.completedBools[i] ? Color.green : Color.gray)
                                        .frame(width: 20, height: 20)
                                        .animation(.easeInOut, value: habit.completedBools[i])
                                }
                            }
                        }
                    }
                } else {
                    HStack {
                        Text("You have no daily Nyabits.")
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 64)
            
            
            
            VStack (alignment: .leading, spacing: 16){
                Text("This Week")
                    .font(.title)
                
                if (!weeklyTasks.isEmpty) {
                    ForEach (weeklyTasks) { habit in
                        HStack {
                            Text(habit.name)
                                .font(.title2)
                            Spacer()
                            
                            ForEach (habit.completedBools.indices, id: \.self) { i in
                                Button(action: {
                                    habit.toggleCompletion(forIndex: i)
                                    habitList.updateHabits()
                                }) {
                                    Circle()
                                        .fill(habit.completedBools[i] ? Color.green : Color.gray)
                                        .frame(width: 20, height: 20)
                                        .animation(.easeInOut, value: habit.completedBools[i])
                                }
                            }
                        }
                    }
                } else {
                    HStack {
                        Text("You have no weekly Nyabits.")
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 256)
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
                        .foregroundStyle(.gray)
                }
                
            }
            .padding(32)
            
            HStack {
                Text("Name")
                Spacer()
                Text("Frequency")
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
            ScrollView {
                VStack (alignment: .center, spacing: 32){
                    ForEach (habits.habits) { habit in
                        HStack {
                            TextField("My Nyabit", text: Binding (
                                get: { habit.name },
                                set: { habit.name = $0 }
                            )
                            )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            
                            
                            TextField("Frequency", text: Binding (
                                get: { String(habit.frequency) },
                                set: {
                                    var value = Int($0) ?? 0
                                    
                                    if value > 7 { value = 7 }
                                    
                                    habit.frequency = value
                                    habit.updateHabit()
                                }
                            ))
                            .frame(width: 100)
                            
                            Picker(habit.frequencyType.rawValue, selection: Binding (
                                get: { habit.frequencyType},
                                set: { habit.frequencyType = $0}
                            )) {
                                Text("Daily").tag(FrequencyType.Daily)
                                Text("Weekly").tag(FrequencyType.Weekly)
                            }
                            .pickerStyle(.palette)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .navigationTitle("Habits")
                .navigationBarHidden(true)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    habits.habits.append(Habit())
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
                
            }
            .padding(.horizontal, 32)
            .offset(x: -30)
        }
    }
}

struct InitializeNyabit: View {
    @Binding var currentPage: Page
    @ObservedObject var nyabit: Nyabit
    @State private var inputedName: String = ""
    
    var body: some View {
        VStack {
            Text("Name your Nyabit:")
                .font(.headline)
                .padding(.bottom, 10)
            
            TextField("", text: $inputedName)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 150)
            
            Button(action: {
                nyabit.name = inputedName
            }) {
                Text("Save")
            }
            .padding(.top, 50)
            .offset(y: 100)
        }
        .padding(32)
    }
}




#Preview {
    ContentView()
}
