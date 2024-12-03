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


enum Emotion: Codable {
    case Ecstatic
    case Happy
    case Neutral
    case Sad
    case Depressed
}

class Nyabit: Codable {
    
    var name: String
    var emotion: Emotion
    var timeSinceLastHabitCompleted: Date
    
    var isInitialized: Bool
    
    init(name: String = "My Nyabit", isInitialized: Bool = false) {
        self.name = name
        self.emotion = .Neutral
        timeSinceLastHabitCompleted = Date()
        self.isInitialized = isInitialized
    }
    
    public func getSymbol() -> String {
        return "🐈"
    }
    
    public func getEmotion() -> Text {
        switch emotion {
        case .Ecstatic:
            return Text("Ecstatic")
                .foregroundStyle(.mint)
                .bold()
                .italic()
        case .Happy:
            return Text("Happy")
                .foregroundStyle(.green)
                .bold()
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
}
