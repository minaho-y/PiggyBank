//
//  PiggyBankApp.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/04/09.
//

import SwiftUI
import SwiftData

@main
struct PiggyBankApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            SavingsGoal.self,
            DepositRecord.self
        ])
    }
}
