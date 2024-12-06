//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Ehan Haque on 11/25/24.
//

import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {
    @StateObject private var nyabitStore = NyabitStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(nyabit: nyabitStore.nyabit) {
                Task {
                    do {
                        try await nyabitStore.save(nyabit: nyabitStore.nyabit)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
                .modelContainer(for: Habit.self, inMemory: true)
                .task {
                    do {
                        try await nyabitStore.load()
                        
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
