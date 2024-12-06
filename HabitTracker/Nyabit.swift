//
//  Nyabit.swift
//  HabitTracker
//
//  Created by Ehan Haque on 11/30/24.
//

import SwiftUI

public enum NyabitType {
    case Cat
}

enum HabitInteractType {
    case Completed
    case Incompleted
}

enum Emotion: Codable {
    case Ecstatic
    case Happy
    case Neutral
    case Sad
    case Depressed
}

struct Nyabit: Codable {
    
    var name: String
    
    var emotionPoints: Int
    var emotion: Emotion
    
    var lastCompletedHabit: Date
    var _lastCompletedHabit: Date
    var dailyHabitsCompleted: Int
    var weeklyHabitsCompleted: Int
    
    var lastDeducted: Date
    
    init(name: String = "My Nyabit", isInitialized: Bool = false) {
        self.name = name
        
        self.emotionPoints = 50
        self.emotion = .Neutral
        
        self.lastCompletedHabit = Date()
        self._lastCompletedHabit = Date()
        self.dailyHabitsCompleted = 0
        self.weeklyHabitsCompleted = 0
        
        self.lastDeducted = Date()
    }
    
    public mutating func test(_ int: Int) {
        emotionPoints = int
    }
    
    public mutating func updateHabit(_ habitType: String, _ habitInteractType: HabitInteractType, _ habits: [Habit]) {
        switch habitType {
        case "daily":
            if habitInteractType == .Completed {
                dailyHabitsCompleted += 1
                setDate()
            } else {
                dailyHabitsCompleted -= 1
                revertDate()
            }
        case "weekly":
            if habitInteractType == .Completed {
                weeklyHabitsCompleted += 1
                setDate()
            } else {
                weeklyHabitsCompleted -= 1
                revertDate()
            }
        default:
            break
        }
        
        if dailyHabitsCompleted < 0 {
            dailyHabitsCompleted = 0
        }
        
        if weeklyHabitsCompleted < 0 {
            weeklyHabitsCompleted = 0
        }
    }
    
    private mutating func setDate() {
        let calender = Calendar.current
        
        if !calender.isDateInToday(lastCompletedHabit) {
            _lastCompletedHabit = lastCompletedHabit
            lastCompletedHabit = Date.now
        }
    }
    
    private mutating func revertDate() {
        let calender = Calendar.current
        
        if calender.isDateInToday(lastCompletedHabit) {
            lastCompletedHabit = _lastCompletedHabit
        }
    }
    
    public mutating func updateEmotion() {
        let calendar = Calendar.current
        let now = Date()
        
        if let daysSinceCompleted = calendar.dateComponents([.day], from: lastCompletedHabit, to: now).day {
            if let daysSinceDeducted = calendar.dateComponents([.day], from: lastDeducted, to: now).day {
                
                if daysSinceCompleted > daysSinceDeducted {
                    emotionPoints -= emotionPointFormula(days: daysSinceCompleted)
                    self.lastDeducted = Date.now
                } else {
                    let totalDeducted = emotionPointFormula(days: daysSinceCompleted) - emotionPointFormula(days: daysSinceDeducted)
                    emotionPoints -= totalDeducted
                    self.lastDeducted = Date.now
                }
            }
        }
    }
    
    private func emotionPointFormula(days: Int) -> Int {
        Int(5 * powf(2, Float(days)))
    }
    

    
    public func getSymbol() -> String {
        return "🐈"
    }
    
    public mutating func getEmotion() -> Text {
        calculateEmotion()
        
        switch emotion {
                case .Ecstatic:
                    return Text("Ecstatic")
                        .foregroundStyle(.mint)
                        .bold()
                        .italic()
                case .Happy:
                    return Text("Happy")
                        .foregroundStyle(.green)
                        .italic()
                case .Neutral:
                    return Text("Neutral")
                        .foregroundStyle(.gray)
                case .Sad:
                    return Text("Sad")
                        .foregroundStyle(.blue)
                        .italic()

                case .Depressed:
                    return Text("Depressed")
                        .foregroundStyle(.gray)
                        .bold()
                        .italic()
                }
    }
    
    private mutating func calculateEmotion() {
        if emotionPoints <= 20 {
            self.emotion = .Depressed
        } else if emotionPoints >= 21 && emotionPoints <= 40 {
            self.emotion = .Sad
        } else if emotionPoints >= 41 && emotionPoints <= 60 {
            self.emotion = .Neutral
        } else if emotionPoints >= 61 && emotionPoints <= 80 {
            self.emotion = .Happy
        } else if emotionPoints >= 81 {
            self.emotion = .Ecstatic
        }
    }
}
