//
//  ContentView.swift
//  iExpense
//
//  Created by Armando Francisco on 11/5/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items: [ExpenseItem] = [] {
        didSet {
            if let encode = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encode, forKey: "Items")
            }
        }
    }
    
    init() {
        if let saveDitems = UserDefaults.standard.data(forKey: "Items") {
            if let decodeItems = try? JSONDecoder().decode([ExpenseItem].self, from: saveDitems) {
                items = decodeItems
                return
            }
        }
        
        items = []
    }
}

struct AmountColors: ViewModifier {
    var amount: Double
    func body(content: Content) -> some View {
        switch amount {
        case 0...10:
            content
                .font(.title2)
                .bold()
                .foregroundStyle(.green)
        case 11..<101:
            content
                .font(.title2)
                .bold()
                .foregroundStyle(.orange)
        case 101...Double.infinity:
            content
                .font(.title2)
                .bold()
                .foregroundStyle(.red)
        default:
            content
                .font(.title2)
                .bold()
                .foregroundStyle(.black)
        }
    }
}

extension View {
    func amountColorsStyle(_ amount: Double) -> some View {
        modifier(AmountColors(amount: amount))
    }
}
struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense: Bool = false
    
    func deleteItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    var body: some View {
        if !expenses.items.isEmpty {
            NavigationStack {
                List {
                    Section("Personal Expenses") {
                        ForEach(expenses.items) { item in
                            if item.type == "Personal" {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }
                                    Spacer()
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .amountColorsStyle(item.amount)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    Section("Business Expenses") {
                        ForEach(expenses.items) { item in
                            if item.type == "Business" {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }
                                    Spacer()
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .amountColorsStyle(item.amount)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                    Section("Other Expenses") {
                        ForEach(expenses.items) { item in
                            if item.type != "Personal" && item.type != "Business" {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }
                                    Spacer()
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                        .amountColorsStyle(item.amount)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    
                }
                .navigationBarTitle("iExpense")
                .toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpense.toggle()
                    }
                }
                .sheet(isPresented: $showingAddExpense){
                    AddView(expense: expenses)
                }
            }
        } else {
            NavigationStack {
                VStack {
                    Text("No Expenses Yet :)")
                        .font(.headline)
                }
                .navigationBarTitle("iExpense")
                .toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpense.toggle()
                    }
                }
                .sheet(isPresented: $showingAddExpense){
                    AddView(expense: expenses)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
