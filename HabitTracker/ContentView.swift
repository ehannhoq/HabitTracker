//
//  ContentView.swift
//  csfair2024
//
//  Created by Ehan Haque on 11/25/24.
//

import SwiftUI
import SwiftData

enum Page {
    case mainPage
    case habitList
    case initNyabit
}


struct ContentView: View {
    @State private var currentPage: Page = .mainPage
    @StateObject private var nyabit: Nyabit = Nyabit(name: "Carl")
    
    @Query private var habits: [Habit] = []
    @Environment(\.modelContext) private var context

    private var resolvedPage: Page {
        nyabit.name == "NOT SET" ? .initNyabit : currentPage
    }
    
    var body: some View {
        
        ZStack {
            switch resolvedPage {
            case .mainPage:
                MainPage(currentPage: $currentPage, nyabit: nyabit, habits: habits, context: context)
                    .transition(.move(edge: .trailing))
                
            case .habitList:
                HabitList(currentPage: $currentPage, habits: habits, context: context)
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

    var habits: [Habit]
    var context: ModelContext

    var body: some View {
        VStack {
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
            .padding(32)
            
            ScrollView {
                VStack (alignment: .center) {
         
                    
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
                
                MainPageHabits(habits: habits)
                
            }
            .defaultScrollAnchor(.top)
            
        }
        
    }
}

struct HabitList: View {
    @Binding var currentPage: Page
    @State private var isEditing: Bool = false
    
    var habits: [Habit]
    var context: ModelContext
    
    var editText: String {
        isEditing ? "Done" : "Edit"
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(editText)
                }
                .animation(.easeInOut, value: isEditing)
                Spacer()
                Button(action: {
                    currentPage = .mainPage
                }) {
                    Text("Back")
                        .foregroundStyle(.gray)
                }
                
            }
            .padding(32)
            
            
            if (!habits.isEmpty) {
                HStack (alignment: .center) {
                    Text("Name")
                    Spacer()
                    Text("Frequency")
                    Spacer()
                    Text("Daily/Weekly")
                }
                
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
                ScrollView {
                    VStack (alignment: .center, spacing: 32) {
                        ForEach (Array(habits.indices), id: \.self) { i in
                            let habit = habits[i]
                            HStack {
                                
                                if isEditing {
                                    Button(action: {
                                        context.delete(habit)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundStyle(.red)
                                    }
                                }
                                
                                TextField("My Nyabit", text: Binding (
                                    get: { habit.name },
                                    set: { habit.name = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 105)

                                Spacer()
                                
                                TextField("Frequency", text: Binding (
                                    get: { String(habit.frequency) },
                                    set: {
                                        let value = Int($0) ?? 0
                                        habit.frequency = value
                                        habit.updateHabit()
                                    }
                                ))
                                .frame(width:30)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .multilineTextAlignment(.center)
                                
                                Spacer()
                                
                                Picker(habit.frequencyType, selection: Binding (
                                    get: { habit.frequencyType},
                                    set: { habit.frequencyType = $0}
                                )) {
                                    Text("Daily").tag("daily")
                                    Text("Weekly").tag("weekly")
                                }
                                .frame(width: 100)
                            }
                            .padding(.horizontal, 32)
                        }
                    }
                    .navigationTitle("Habits")
                    .navigationBarHidden(true)
                }
                
   
                
            } else {
                VStack {
                    Spacer()
                    Text("You have no nyabits yet!")
                    Spacer()
                }
            }
             
            HStack {
                Spacer()
                Button(action: {
                    let newHabit = Habit()
                    context.insert(newHabit)
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal, 48)
            .padding(.vertical, 24)
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

struct MainPageHabits: View  {
    
    var habits: [Habit]
    
    var body: some View {
        let maxBoolsPerRow: Int = 5
        let dailyTasks = habits.filter { $0.frequencyType == "daily"}
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        let weeklyTasks = habits.filter { $0.frequencyType == "weekly"}
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }

        
        
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Today")
                .font(.title)
            
            if (!dailyTasks.isEmpty) {
                ForEach (dailyTasks) { habit in
                    HStack {
                        Text(habit.name)
                            .font(.title2)
                        Spacer()
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.fixed(24)), count: maxBoolsPerRow),
                                  spacing: 16
                        ) {
                            ForEach (habit.completedBools.indices, id: \.self) { i in
                                Button(action: {
                                    habit.toggleCompletion(forIndex: i)
                                }) {
                                    Circle()
                                        .fill(habit.completedBools[i] ? Color.green : Color.gray)
                                        .frame(width: 20, height: 20)
                                        .animation(.easeInOut, value: habit.completedBools[i])
                                }
                            }
                            Spacer()
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
        
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.title)
            
            if (!weeklyTasks.isEmpty) {
                ForEach (weeklyTasks) { habit in
                    HStack {
                        Text(habit.name)
                            .font(.title2)
                        Spacer()
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.fixed(24)), count: maxBoolsPerRow),
                                  spacing: 16
                        ) {
                            ForEach (habit.completedBools.indices, id: \.self) { i in
                                Button(action: {
                                    habit.toggleCompletion(forIndex: i)
                                }) {
                                    Circle()
                                        .fill(habit.completedBools[i] ? Color.green : Color.gray)
                                        .frame(width: 20, height: 20)
                                        .animation(.easeInOut, value: habit.completedBools[i])
                                }
                            }
                            Spacer()
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
        .padding(.bottom, 64)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
