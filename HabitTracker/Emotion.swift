//
//  Emotion.swift
//  csfair2024
//
//  Created by Ehan Haque on 11/26/24.
//

import Foundation
import SwiftUI

public enum Emotion {
    case Happy, Sad, Ecstatic, Hopefull, Depressed
}

public func GetEmotion(_ emotion: Emotion) -> Text {
    switch emotion {
    case .Happy:
        return Text("Happy")
            .foregroundStyle(.green)
    case .Sad:
        return Text("Sad")
            .foregroundStyle(.blue)
    case .Ecstatic:
        return Text("Ecstatic")
            .foregroundStyle(.mint)
    case .Hopefull:
        return Text("Happy")
            .foregroundStyle(.yellow)
    case .Depressed:
        return Text("Depressed")
            .foregroundStyle(.gray)
    }
}
