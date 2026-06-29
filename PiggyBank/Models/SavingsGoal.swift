//
//  SavingsGoal.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/04/30.
//

import Foundation
import SwiftData

@Model
final class SavingsGoal {
    var id: UUID
    var name: String
    var targetAmount: Decimal
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        targetAmount: Decimal,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.createdAt = createdAt
    }
}
