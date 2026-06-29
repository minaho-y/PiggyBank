//
//  DepositRecord.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/05/01.
//
//  入金記録

import Foundation
import SwiftData

@Model
final class DepositRecord {
    var id: UUID
    var amount: Decimal
    var date: Date
    var memo: String
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        amount: Decimal,
        date: Date,
        memo: String = "",
        createdAt: Date = .now
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.memo = memo
        self.createdAt = createdAt
    }
    
}
