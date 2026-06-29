//
//  DepositHistoryView.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/05/01.
//

import SwiftData
import SwiftUI

struct DepositHistoryView: View {
    @Query private var deposits: [DepositRecord]
    @Environment(\.modelContext) private var modelContext
    @State private var editingDeposit: DepositRecord?
    
    var sortedDeposits: [DepositRecord] {
        deposits.sorted { first, second in
            first.date > second.date
        }
    }
    
    var totalDepositAmount: Decimal {
        deposits.reduce(0) { partialResult, deposit in
            partialResult + deposit.amount
        }
    }
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("入金履歴")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textPrimary)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("これまでの入金")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(PiggyTheme.textSecondary)
                    
                    Text(Formatters.yenString(from: totalDepositAmount))
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(PiggyTheme.primary)
                    
                    Text("\(deposits.count)件の記録")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .piggyCardStyle()
                
                VStack(spacing: 5) {
                    ForEach(sortedDeposits) { deposit in
                        Button {
                            editingDeposit = deposit
                        } label: {
                            DepositHistoryRow(deposit: deposit)
                        }
                        .buttonStyle(.plain)
                        
                        if deposit.id != sortedDeposits.last?.id {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)
            }
            .padding(22)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingDeposit) { deposit in
            EditDepositView(deposit: deposit)
        }
    }
    
    private func deleteDeposit(_ deposit: DepositRecord) {
        modelContext.delete(deposit)
        
        do {
            try modelContext.save()
        } catch {
            print("入金記録の削除失敗: \(error)")
        }
    }
}

private struct DepositHistoryRow: View {
    let deposit: DepositRecord

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(deposit.date.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textPrimary)
                
                Text(deposit.memo.isEmpty ? "" : deposit.memo)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("+\(Formatters.yenString(from: deposit.amount))")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(PiggyTheme.primary)
                .frame(width: 96, alignment: .trailing)

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(PiggyTheme.primarySoft)
                .frame(width: 18)

        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

private struct EditDepositView: View {
    let deposit: DepositRecord
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var amountText: String
    @State private var selectedDate: Date
    @State private var memo: String
    @State private var isShowingDeleteConfirmation = false
    
    init(deposit: DepositRecord) {
        self.deposit = deposit
        _amountText = State(
            initialValue: Formatters.commaString(
                from: NSDecimalNumber(decimal: deposit.amount).stringValue
            )
        )
        _selectedDate = State(initialValue: deposit.date)
        _memo = State(initialValue: deposit.memo)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("入金を編集")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textPrimary)
                
                DepositAmountInputCard(amountText: $amountText)
                
                DatePicker("日付", selection: $selectedDate, displayedComponents: .date)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textPrimary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("メモ")
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
                    saveChanges()
                } label: {
                    Text("保存する")
                        .piggyPrimaryButtonStyle()
                }
                .disabled(amountText.isEmpty)
                
                Button(role: .destructive) {
                    isShowingDeleteConfirmation = true
                } label: {
                    Text("この入金記録を削除")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                
                Spacer()
            }
            .padding(22)
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
        .alert(
            "この入金記録を削除しますか？",
            isPresented: $isShowingDeleteConfirmation
        ) {
            Button("キャンセル", role: .cancel) {
            }
            
            Button("削除する", role: .destructive) {
                deleteDeposit()
            }
        } message: {
            Text("削除するともとに戻せません")
        }
    }
    
    private func saveChanges() {
        let rawAmountText = Formatters.digitsOnly(from: amountText)
        guard let amount = Decimal(string: rawAmountText),
              amount > 0 else {
            return
        }
        
        deposit.amount = amount
        deposit.date = selectedDate
        deposit.memo = memo
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("入金記録の更新失敗: \(error)")
        }
    }

    private func deleteDeposit() {
        modelContext.delete(deposit)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("入金記録の削除失敗: \(error)")
        }
    }
}
