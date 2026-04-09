//
//  Item.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/04/09.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
