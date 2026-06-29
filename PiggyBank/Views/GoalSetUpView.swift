//
//  GoalSetUpView.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/04/30.
//

import SwiftUI
import SwiftData

struct GoalSetUpView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var goalName = ""
    @State private var targetAmountText = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("目標設定") {
                    TextField("目標名", text: $goalName)
                    TextField("目標金額", text: $targetAmountText)
                }
                
                Button("保存して始める") {
                    saveGoal()
                }
                .disabled(goalName.isEmpty || targetAmountText.isEmpty)
            }
            .navigationTitle("PiggyBank")
        }
    }
    
    private func saveGoal() {
        guard let amount = Decimal(string: targetAmountText),
              amount > 0 else {
            print("金額の変換に失敗しました: \(targetAmountText)")
            return
        }
        
        let goal = SavingsGoal(
            name: goalName,
            targetAmount: amount
        )
        
        modelContext.insert(goal)
    }
}
