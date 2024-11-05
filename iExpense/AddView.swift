//
//  AddView.swift
//  iExpense
//
//  Created by Armando Francisco on 11/5/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = 0.0
    @State private var type = "Personal"
    
    var expense: Expenses
    
    let types = ["Personal", "Business", "Entertainment"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
                Section {
                    TextField("Amount", value: $amount, format: .currency(code: "USD")).keyboardType(.decimalPad)
                }
                Section {
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                Button("Add") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expense.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expense: Expenses())
}
