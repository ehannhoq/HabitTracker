//
//  Habit.swift
//  HabitTracker
//
//  Created by Ehan Haque on 11/26/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Habit: Identifiable {
    var id = UUID()
    var name: String
    var frequency: Int
    var frequencyType: String
    var completedBools: [Bool]
    
    init(name: String = "New Nyabit", frequency: Int = 1, frequencyType: String = "daily") {
        self.name = name
        self.frequency = frequency
        self.frequencyType = frequencyType
        self.completedBools = Array(repeating: false, count: frequency)
    }
    
    func toggleCompletion(forIndex index: Int)
    {
        completedBools[index].toggle()
    }
    
    func updateHabit() {
        self.completedBools = Array(repeating: false, count: frequency)
    }
}
