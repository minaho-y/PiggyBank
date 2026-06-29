//
//  ContentView.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/04/09.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var goals: [SavingsGoal]
    
    var body: some View {
        if let goal = goals.first {
            HomeView(goal: goal)
        } else {
            GoalSetUpView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [SavingsGoal.self, DepositRecord.self], inMemory: true)
}
