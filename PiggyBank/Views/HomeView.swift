//
//  HomeView.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/05/01.
//

import SwiftData
import SwiftUI
import Charts


private struct ProgressChartView: View {
    let currentAmount: Double
    let remainingAmount: Double
    let achievementRate: Double
    
    var body: some View {
        ZStack {
            Chart {
                SectorMark(
                    angle: .value("Current", max(currentAmount, 0.01)),
                    innerRadius: .ratio(0.70),
                    angularInset: 2
                )
                .foregroundStyle(PiggyTheme.primary)
                
                SectorMark(
                    angle: .value("Remaining", max(remainingAmount, 0.01)),
                    innerRadius: .ratio(0.70),
                    angularInset: 2
                )
                .foregroundStyle(PiggyTheme.progressTrack)
            }
            .chartLegend(.hidden)
            .frame(width: 180, height: 180)
            
            VStack(spacing: 2) {
                Text("\(achievementRate, specifier: "%.0f")%")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textPrimary)
                
                Text("達成率")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(PiggyTheme.textSecondary)
            }
        }
    }
    
}

private struct ProgressSummaryView: View {
    let currentAmount: Decimal
    let targetAmount: Decimal
    let achievementRate: Double
    let remainingAmount: Decimal
    
    var body: some View {
        VStack(spacing: 12) {
            Text("現在の貯金額")
                .font(.headline)
                .font(.system(size: 28, weight: .bold, design: .rounded))
            
            Text(Formatters.yenString(from: currentAmount))
                .font(.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
            
            Text("目標金額: \(Formatters.yenString(from: targetAmount))")
                
            Text("達成率: \(achievementRate, specifier: "%.1f")%")
            Text("残り金額: \(Formatters.yenString(from: remainingAmount))")
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }
    }
}

//private struct RecentDepositsView: View {
//    
//}

struct HomeView: View {
    let goal: SavingsGoal
    
    @Query private var deposits: [DepositRecord]
    @State private var isShowingAddDepositView = false
    
    var currentAmount: Decimal {
        deposits.reduce(0) { partialResult, record in
            partialResult + record.amount
        }
    }
    
    var achievementRate: Double {
        let current = NSDecimalNumber(decimal: currentAmount).doubleValue
        let target = NSDecimalNumber(decimal: goal.targetAmount).doubleValue
        
        guard target > 0 else { return 0 }
        
        return (current / target) * 100
    }
    
    var remainingAmount: Decimal {
        let remaining = goal.targetAmount - currentAmount
        return remaining > 0 ? remaining : 0
    }
    
    var currentAmountNumber: Double {
        NSDecimalNumber(decimal: currentAmount).doubleValue
    }
    
    var remainingAmountNumber: Double {
        NSDecimalNumber(decimal: remainingAmount).doubleValue
    }
    
    var sortedDeposits: [DepositRecord] {
        deposits.sorted { first, second in
            first.date > second.date
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
//                HomeHeaderView()
                
                HStack() {
                    Text("PiggyBank")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(PiggyTheme.primary)
                    
                    Spacer()
                    
                    Image(systemName: "gearshape")
                        .foregroundStyle(PiggyTheme.primary)
                }
                    
                VStack(spacing: 12){
                    Text("目標：\(goal.name)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(PiggyTheme.textPrimary)
                    
                    ProgressChartView(
                        currentAmount: currentAmountNumber,
                        remainingAmount: remainingAmountNumber,
                        achievementRate: achievementRate
                    )
                    
                    Text(Formatters.yenString(from: currentAmount))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(PiggyTheme.primary)
                    
                    Text("/\(Formatters.yenString(from: goal.targetAmount))")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(PiggyTheme.textSecondary)
                    
                    Divider()
                    
                    Text("あと \(Formatters.yenString(from: remainingAmount))")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(PiggyTheme.textPrimary)
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)
                

                Button() {
                    isShowingAddDepositView = true
                } label: {
                    Label("入金する", systemImage: "plus.circle.fill")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .foregroundStyle(.white)
                        .background(PiggyTheme.buttonGradient)
                        .clipShape(Capsule())
                }
                
                RecentDepositsView(deposits: sortedDeposits)
                
                NavigationLink("入金履歴を見る") {
                    DepositHistoryView()
                }
                .foregroundStyle(PiggyTheme.primary)
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $isShowingAddDepositView) {
            AddDepositView()
        }
    }
    
}

private struct RecentDepositsView: View {
    let deposits: [DepositRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("最近の入金記録")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(PiggyTheme.textPrimary)
            
            ForEach(deposits.prefix(3)) { deposit in
                HStack {
                    Text(deposit.date.formatted(date: .numeric, time: .omitted))
                    
                    Spacer()
                    
                    Text("+ \(Formatters.yenString(from: deposit.amount))")
                        .foregroundStyle(PiggyTheme.primary)
                }
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .padding(.vertical, 6)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)
    }
}
