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
    @State private var currentPage: Page = .habitList
    @State private var todaysDate: Date = Date()
    
    @Binding var nyabit: Nyabit
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    @Query private var habits: [Habit] = []
    @Environment(\.modelContext) private var context
    
    var body: some View {
        
        ZStack {
            if nyabit.isInitialized {
                switch currentPage {
                case .mainPage:
                    MainPage(currentPage: $currentPage, nyabit: $nyabit, habits: habits, context: context)
                        .transition(.move(edge: .trailing))
                    
                case .habitList:
                    HabitList(currentPage: $currentPage, habits: habits, context: context)
                        .transition(.move(edge: .leading))
                    
                default:
                    MainPage(currentPage: $currentPage, nyabit: $nyabit, habits: habits, context: context)
                        .transition(.move(edge: .trailing))
                }
            } else {
                InitializeNyabit(currentPage: $currentPage, nyabit: $nyabit)
                    .transition(.move(edge: .leading))
            }

        }
        .animation(.easeInOut, value: currentPage)
        .onChange(of: scenePhase) {
            saveAction()
        }
    }
}

struct MainPage: View {
    @Binding var currentPage: Page
    @Binding var nyabit: Nyabit
    
    var habits: [Habit]
    var context: ModelContext

    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1, green: 0.9, blue: 0.6),
                            Color(red: 0.8, green: 0.7, blue: 0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                .ignoresSafeArea()
            
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
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(width: geometry.size.width)
                            .multilineTextAlignment(.center)
                        }
                        .frame(height: 170)
                        
                        
                        nyabit.getEmotion()
                            .font(.system(size: 20, weight: .medium, design: .monospaced))
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
                    
                    MainPageHabits(nyabit: $nyabit, habits: habits)
                    
                }
                .defaultScrollAnchor(.top)
            }
        }
        
    }
}

struct HabitList: View {
    @Binding var currentPage: Page
    
    var habits: [Habit]
    var context: ModelContext

    @State private var isPresentingHabit: Bool = false
    @State private var selectedHabit: Habit = Habit()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1, green: 0.9, blue: 0.6),
                            Color(red: 0.8, green: 0.7, blue: 0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        currentPage = .mainPage
                        
                        if !habits.isEmpty {
                            for habit in habits {
                                habit.updateHabit()
                            }
                        }
                                       
                    }) {
                        Text("Back")
                            .foregroundStyle(.gray)
                    }
                    
                }
                .padding(32)
                
                
                if (!habits.isEmpty) {
                    ScrollView {
                        LazyVStack (alignment: .center, spacing: 32) {
                            ForEach (Array(habits.indices), id: \.self) { i in
                                let habit = habits[i]
                                Button(action: {
                                    selectedHabit = habit
                                    isPresentingHabit = true
                                }) {
                                    RoundedRectangle(cornerRadius: 10, style: RoundedCornerStyle.continuous)
                                    
                                        .frame(width: 350, height: 100)
                                        .foregroundStyle(
                                            LinearGradient(gradient: Gradient(colors: [
                                                Color(red: 0.9, green: 0.8, blue: 0.7),
                                                Color(red: 0.85, green: 0.75, blue: 0.65)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .overlay(alignment: .center, content: {
                                            RoundedRectangle(cornerRadius: 10, style: RoundedCornerStyle.continuous)
                                                .stroke(Color.black.opacity(0.1), lineWidth: 10)
                                        })
                                    
                                        .overlay(alignment: .leading, content: {
                                            HStack{
                                                Text(habit.name)
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 20, weight: .black, design: .rounded))
                                                    .bold()
                                                    .padding(16)
                                                Spacer()
                                                Text("\(habit.frequencyType.capitalized) Habit")
                                                    .foregroundStyle(.white)
                                                    .padding(16)
                                            }
                                        })
                                        
                                }
                            }
                        }
                    }
                
                } else {
                    VStack {
                        Spacer()
                        Text("You have no nyabits yet!")
                            .font(.system(size: 20, weight: .regular, design: .monospaced))
                            .foregroundStyle(.white)
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
                
                .sheet(
                    isPresented: $isPresentingHabit,
                    content: {
                        ZStack {
                            Rectangle()
                                .frame(width: .infinity, height: .infinity)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.9, green: 0.8, blue: 0.7),
                                            Color(red: 0.85, green: 0.75, blue: 0.65)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                ))
                                .ignoresSafeArea()
                            
                            VStack {
                                DetailedHabitMenu(habit: $selectedHabit, context: context)
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.visible)
                                
                                Button(action: {
                                    context.delete(selectedHabit)
                                    isPresentingHabit = false
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                })
            }
            
        }

    }
}

struct DetailedHabitMenu : View {
    @Binding var habit: Habit
    
    let frequencyRange = Array(1...100)
    var context: ModelContext
    
    @State private var chosenFrequency: Int?
    
    var body: some View {
        
        ZStack {
            VStack (alignment: .center) {
                
                GeometryReader { geometry in
                    TextField("My Nyabit✏️", text: Binding (
                        get: { habit.name },
                        set: {
                            var name = $0
                            if name == "" {
                                name = "My Nyabit✏️"
                            }
                            habit.name = name
                        }
                    ))
                    .padding(.top, 20)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: geometry.size.width)
                    .multilineTextAlignment(.center)
                }
                .frame(height: 40)
                
                Spacer()
                
                HStack {
                    Text("Frequency:")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    
                    Picker("Frequency", selection: $habit.frequency) {
                        ForEach(frequencyRange, id: \.self) { num in
                            Text("\(num)").tag(num)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .foregroundStyle(.white)
                    
                }
                
                Spacer()
                
                Picker(habit.frequencyType, selection: Binding (
                    get: { habit.frequencyType},
                    set: { habit.frequencyType = $0}
                )) {
                    Text("Daily")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .tag("daily")
                    Text("Weekly")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .tag("weekly")
                }
                .frame(width:. infinity)
                .pickerStyle(SegmentedPickerStyle())
                .backgroundStyle(Color(red: 0.85, green: 0.75, blue: 0.65))
                Spacer()
            }
            .padding(32)
        }
    }
}

struct InitializeNyabit: View {
    @Binding var currentPage: Page
    @State private var inputedName: String = ""
    @Binding var nyabit: Nyabit
    
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
                nyabit.isInitialized = true
                currentPage = .mainPage
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
    
    @Binding var nyabit: Nyabit
    var habits: [Habit]
    
    var body: some View {
        let maxBoolsPerRow: Int = 5
        let dailyTasks = habits.filter { $0.frequencyType == "daily"}
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        let weeklyTasks = habits.filter { $0.frequencyType == "weekly"}
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }

        
        
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Today")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
            
            if (!dailyTasks.isEmpty) {
                ForEach (dailyTasks) { habit in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: RoundedCornerStyle.continuous)
                            .foregroundStyle(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
                        HStack {
                                Text(habit.name)
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(.gray)
                                    .shadow(color: Color.white, radius: 5, x: 0, y: 0)
                            
                                Spacer()
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.fixed(24)), count: maxBoolsPerRow),
                                          spacing: 16
                                ) {
                                    ForEach (habit.completedBools.indices, id: \.self) { i in
                                        Button(action: {
                                            let bool = habit.toggleCompletion(forIndex: i)
                                            
                                            if bool {
                                                nyabit.numHabitsCompletedToday += 1
                                                nyabit.setDate()
                                            } else {
                                                nyabit.numHabitsCompletedToday -= 1
                                            }
                                        }) {
                                            Image(systemName: habit.completedBools[i] ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(habit.completedBools[i] ? .green : .gray)
                                                .animation(.easeInOut, value: habit.completedBools[i])
                                        }
                                    }
                                    Spacer()
                                }
                        }
                        .padding(16)
                    }
                }
            } else {
                HStack {
                    Text("You have no daily Nyabits.")
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .foregroundStyle(.white)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 64)
        
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
            if (!weeklyTasks.isEmpty) {
                ForEach (weeklyTasks) { habit in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: RoundedCornerStyle.continuous)
                            .foregroundStyle(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
                        HStack {
                                Text(habit.name)
                                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(.gray)
                                    .shadow(color: Color.white, radius: 5, x: 0, y: 0)
                            
                                Spacer()
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.fixed(24)), count: maxBoolsPerRow),
                                          spacing: 16
                                ) {
                                    ForEach (habit.completedBools.indices, id: \.self) { i in
                                        Button(action: {
                                            let bool = habit.toggleCompletion(forIndex: i)
                                            
                                            if bool {
                                                nyabit.numHabitsCompletedToday += 1
                                                nyabit.setDate()
                                            } else {
                                                nyabit.numHabitsCompletedToday -= 1
                                            }
                                        }) {
                                            Image(systemName: habit.completedBools[i] ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(habit.completedBools[i] ? .green : .gray)
                                                .animation(.easeInOut, value: habit.completedBools[i])
                                        }
                                    }
                                    Spacer()
                                }
                        }
                        .padding(16)
                    }
                }
            } else {
                HStack {
                    Text("You have no weekly Nyabits.")
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .foregroundStyle(.white)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 64)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @State var previewNyabit: Nyabit = .init(name: "test", isInitialized: true)
        ContentView(nyabit: $previewNyabit, saveAction: {})
            .modelContainer(for: Habit.self)
    }
}
