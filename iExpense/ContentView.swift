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
                    ForEach(expenses.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: "USD"))
                        }
                    }
                    .onDelete(perform: deleteItems)
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
