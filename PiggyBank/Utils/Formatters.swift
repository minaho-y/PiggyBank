//
//  Formatters.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/05/08.
//

import Foundation

enum Formatters {
    static func yenString(from amount: Decimal) -> String {
        amount.formatted(.currency(code: "JPY"))
    }
    
    static func digitsOnly(from text: String) -> String {
        text.filter(\.isNumber)
    }

    static func commaString(from text: String) -> String {
        let digits = digitsOnly(from: text)
        
        guard let number = Int(digits) else {
            return ""
        }
        
        return number.formatted(.number)
    }
}

