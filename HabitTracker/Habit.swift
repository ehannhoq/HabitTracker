//
//  Habit.swift
//  HabitTracker
//
//  Created by Ehan Haque on 11/26/24.
//

import Foundation
import SwiftUI

enum FrequencyType : String {
    case Daily = "Daily"
    case Weekly = "Weekly"
}

class Habit: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var frequency: Int
    @Published var frequencyType: FrequencyType
    @Published var completedBools: [Bool]
    
    init(name: String = "New Nyabit", frequency: Int = 1, frequencyType: FrequencyType = .Daily) {
        self.name = name
        self.frequency = frequency
        self.frequencyType = frequencyType
        self.completedBools = Array(repeating: false, count: frequency)
    }
    
    func toggleCompletion(forIndex index: Int)
    {
        completedBools[index].toggle()
        objectWillChange.send()
    }
    
    func updateHabit() {
        self.completedBools = Array(repeating: false, count: frequency)
    }
}
class ListOfHabits: ObservableObject {
    @Published var habits: [Habit] = []
    init(habits: [Habit])
    {
        self.habits = habits
    }
    
    func updateHabits() {
        let list = habits
        habits = list
    }
}
