//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Ehan Haque on 11/25/24.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
