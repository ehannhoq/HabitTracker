//
//  NyabitStore.swift
//  HabitTracker
//
//  Created by Ehan Haque on 12/3/24.
//

import Foundation

@MainActor
class NyabitStore: ObservableObject {
    @Published var nyabit: Nyabit = .init()
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
        .appendingPathComponent("nyabit.data")
        
    }
    
    func load() async throws {
        let task = Task<Nyabit, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return Nyabit()
            }
            let nyabit = try JSONDecoder().decode(Nyabit.self, from: data)
            return nyabit
        }
        let nyabit = try await task.value
        self.nyabit = nyabit
    }
    
    func save(nyabit: Nyabit) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(nyabit)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
        
    }
}
