//
//  AddDepositView.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/05/01.
//

import SwiftData
import SwiftUI

struct AddDepositView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amountText = ""
    @State private var selectedDate = Date()
    @State private var memo = ""
    @State private var savedAmount: Decimal?
    
    var body: some View {
        NavigationStack {
            if let savedAmount {
                DepositCompleteView(amount: savedAmount) {
                    dismiss()
                }
            } else {
                depositForm
            }
        }
    }
    
    private var depositForm: some View {
        VStack(spacing: 24) {
            Text("入金")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(PiggyTheme.textPrimary)
            
            DepositAmountInputCard(amountText: $amountText)
            
            DatePicker("日付", selection: $selectedDate, displayedComponents: .date)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(PiggyTheme.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("メモ（任意）")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textPrimary)
                
                TextField("バイト代", text: $memo)
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(PiggyTheme.line, lineWidth: 1)
                    )
                    
            }
            
            Button {
                saveDeposit()
            } label: {
                Text("保存する")
                    .piggyPrimaryButtonStyle()
            }
            .disabled(amountText.isEmpty)
            
            Spacer()
        }
        .padding(22)
        .background(Color.white)
    }
    
    private func saveDeposit() {
        let rawAmountText = Formatters.digitsOnly(from: amountText)
        
        guard let amount = Decimal(string: rawAmountText),
              amount > 0 else {
            print("金額の変換に失敗しました")
            return
        }
        
        let deposit = DepositRecord(
            amount: amount,
            date: selectedDate,
            memo: memo
        )
        
        modelContext.insert(deposit)
        do {
            try modelContext.save()
                savedAmount = amount
            } catch {
                print("入金記録の保存失敗: \(error)")
            }
    }
}

private struct DepositCompleteView: View {
    let amount: Decimal
    let onGoHome: () -> Void
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .font(.system(size: 84))
                .foregroundStyle(PiggyTheme.primary)
            
            Text("入金が完了しました！")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(PiggyTheme.textPrimary)
            
            Text("+\(Formatters.yenString(from: amount))")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(PiggyTheme.primary)
            
            Spacer()
            
            Button {
                onGoHome()
            } label: {
                Text("ホームに戻る")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .foregroundStyle(.white)
                    .background(PiggyTheme.buttonGradient)
                    .clipShape(Capsule())
            }
        }
        .padding(22)
        .background(Color.white)
    }
}

struct DepositAmountInputCard: View {
    @Binding var amountText: String
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("¥")
                    .font(.title2)
                
                TextField("0", text: $amountText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 39, weight: .semibold, design: .rounded))
                    .foregroundStyle(PiggyTheme.primary)
                    .multilineTextAlignment(.center)
                    .onChange(of: amountText) { _, newValue in
                        let formatted = Formatters.commaString(from: newValue)
                        
                        if formatted != newValue{
                            amountText = formatted
                        }
                    }
            }
            
            Divider()
            
            HStack {
                quickAmountButton(1000)
                quickAmountButton(5000)
                quickAmountButton(10000)
                quickAmountButton(50000)
            }
            .font(.caption.bold())
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)
    }
    
    private func quickAmountButton(_ amount: Int) -> some View {
        Button("+\(amount.formatted())") {
            addAmount(amount)
        }
        .font(.caption)
        .foregroundStyle(PiggyTheme.textPrimary)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(PiggyTheme.primarySoft)
        .clipShape(Capsule())
    }
    
    private func addAmount(_ amount: Int) {
        let currentText = Formatters.digitsOnly(from: amountText)
        let current = Int(currentText) ?? 0
        let newAmount = current + amount
        
        amountText = Formatters.commaString(from: String(newAmount))
    }
}
