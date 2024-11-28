//
//  Habit.swift
//  HabitTracker
//
//  Created by Ehan Haque on 11/26/24.
//

import Foundation

enum HabitImportance {
    case Low, Medium, High
}

class Habit {
    private(set) var name: String
    private(set) var importance: HabitImportance
    private(set) var frequency: Int
    private(set) var completed: Bool
    
    init(name: String, importance: HabitImportance, frequency: Int, completed: Bool) {
        self.name = name
        self.importance = importance
        self.frequency = frequency
        self.completed = completed
    }
    
    func toggleCompleted() {
        completed.toggle()
    }
}
