//
//  TransactionExportView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Transaction Export View
struct TransactionExportView: View {
    @Binding var isPresented: Bool
    let transactions: [TransactionData]
    @State private var selectedFormat: ExportFormat = .csv
    @State private var selectedDateRange: DateRange = .all
    @State private var showShareSheet = false
    @State private var exportData: String = ""
    
    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case pdf = "PDF"
        case json = "JSON"
    }
    
    enum DateRange: String, CaseIterable {
        case week = "Last Week"
        case month = "Last Month"
        case year = "Last Year"
        case all = "All Time"
    }
    
    private var filteredTransactions: [TransactionData] {
        // In a real app, would filter by selectedDateRange
        // For now, return all transactions
        return transactions
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Format Selection
                    formatSelection
                    
                    // Date Range Selection
                    dateRangeSelection
                    
                    // Preview
                    previewSection
                    
                    // Export Button
                    exportButton
                }
                .padding()
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Export Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [exportData])
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(.phantomPurple)
            
            Text("Export Transaction History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("\(filteredTransactions.count) transactions")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    // MARK: - Format Selection
    private var formatSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export Format")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(ExportFormat.allCases, id: \.self) { format in
                    Button {
                        selectedFormat = format
                        HapticManager.shared.selection()
                    } label: {
                        Text(format.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedFormat == format ? .white : .white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedFormat == format ? Color.phantomPurple : Color.white.opacity(0.05))
                            )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Date Range Selection
    private var dateRangeSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date Range")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(DateRange.allCases, id: \.self) { range in
                    Button {
                        selectedDateRange = range
                        HapticManager.shared.selection()
                    } label: {
                        HStack {
                            Text(range.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if selectedDateRange == range {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.phantomPurple)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedDateRange == range ? Color.phantomPurple.opacity(0.2) : Color.white.opacity(0.05))
                        )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Format: \(selectedFormat.rawValue)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            
            Text("Transactions: \(filteredTransactions.count)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Export Button
    private var exportButton: some View {
        Button {
            exportTransactions()
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Export & Share")
            }
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.phantomPurple, Color.phantomGold],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Export Function
    private func exportTransactions() {
        switch selectedFormat {
        case .csv:
            exportData = generateCSV()
        case .pdf:
            exportData = generatePDF()
        case .json:
            exportData = generateJSON()
        }
        
        HapticManager.shared.notification(.success)
        showShareSheet = true
    }
    
    private func generateCSV() -> String {
        var csv = "Date,Merchant,Amount,EUR Amount,Type,Category,Token\n"
        for transaction in filteredTransactions {
            csv += "\(transaction.date),\(transaction.merchant),\(transaction.amount),\(transaction.eurAmount),\(transaction.isCredit ? "Credit" : "Debit"),\(transaction.category),\(transaction.tokenSymbol)\n"
        }
        return csv
    }
    
    private func generateJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let exportData = filteredTransactions.map { transaction in
            [
                "date": transaction.date,
                "merchant": transaction.merchant,
                "amount": transaction.amount,
                "eurAmount": transaction.eurAmount,
                "type": transaction.isCredit ? "Credit" : "Debit",
                "category": transaction.category,
                "token": transaction.tokenSymbol
            ]
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return "{}"
    }
    
    private func generatePDF() -> String {
        // Simplified PDF generation - in real app would use PDFKit
        var pdf = "Transaction History Report\n"
        pdf += "Generated: \(Date())\n"
        pdf += "Format: PDF\n\n"
        pdf += "Date | Merchant | Amount | Type\n"
        pdf += "--------------------------------\n"
        for transaction in filteredTransactions {
            pdf += "\(transaction.date) | \(transaction.merchant) | \(transaction.amount) | \(transaction.isCredit ? "Credit" : "Debit")\n"
        }
        return pdf
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

