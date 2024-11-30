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

public enum Emotion {
    case Depressed, Sad, Neutral, Happy, Ecstatic
}

class Nyabit: ObservableObject {
    @Published var name: String
    @Published var emotion: Emotion = .Neutral
    
    init(name: String = "NOT SET") {
        self.name = name
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
