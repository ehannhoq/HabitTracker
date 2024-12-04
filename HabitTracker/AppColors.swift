//
//  AppColors.swift
//  HabitTracker
//
//  Created by Ehan Haque on 12/4/24.
//

import SwiftUI

class AppColors {
    
    class LightMode {

    }
    
    class DarkMode {
        public static let backgroundColors: [Color] = [
            Color(red: 0.2, green: 0.2, blue: 0.2),
            Color(red: 0.05, green: 0.05, blue: 0.1)
        ]
        
        public static let habitButton1: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
        public static let habutButton2: Color = Color(red: 0.05, green: 0.05, blue: 0.1)
    }
    
    public static func getBackgroundColors() -> [Color] {
        var colors: [Color] = []
        
        var _ = Color(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                colors = DarkMode.self.backgroundColors
                
            }
            return .clear
        })
        
        return colors
    }
}
