
import SwiftUI

struct GroceryItem: Identifiable {
    let id = UUID()
    var name: String
    var quantity: Int
    var isDone: Bool
}

struct GroceriesView: View {
    @State private var groceries: [String: [GroceryItem]] = [
        "Produce": [GroceryItem(name: "Apples", quantity: 5, isDone: false)],
        "Meat": [GroceryItem(name: "Chicken", quantity: 2, isDone: false)],
        "Baking": [GroceryItem(name: "Flour", quantity: 1, isDone: true)]
    ]
    
    @State private var newItemName = ""
    @State private var selectedCategory = "Produce"
    @State private var categories = ["Produce", "Meat", "Baking"]
    @State private var filter: FilterOption = .all // State to control filtering
    @State private var showingAlert = false // State to control the alert
    
    enum FilterOption {
        case all, completed, toBuy
    }
    
    /// <#Description#>
    var body: some View {
        NavigationView {
            VStack {
                // Input Section
                HStack {
                    TextField("Add new item", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                
                // Scrollable List of Groceries
                List {
                    ForEach(Array(filteredGroceries.keys), id: \.self) { category in
                        Section(header: Text(category)) {
                            ForEach(filteredGroceries[category] ?? []) { item in
                                HStack {
                                    HStack() {
                                        Text(item.name)
                                            .strikethrough(item.isDone, color: .black)
                                        Text("  \(item.quantity)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .strikethrough(item.isDone, color: .gray)
                                    }
                                    Spacer()
                                    
                                    // Increase Quantity Button
                                    Button(action: {
                                        increaseQuantity(for: item, in: category)
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.black)
                                    }
                                    
                                    // Decrease Quantity Button
                                    Button(action: {
                                        decreaseQuantity(for: item, in: category)
                                    }) {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(.black)
                                    }
                                    
                                    Button(action: {
                                        toggleDone(item: item, in: category)
                                    }) {
                                        Image(systemName: item.isDone ? "checkmark.circle.fill" : "trash")
                                            .foregroundColor(item.isDone ? .green : .gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("GROCERIES")
            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Groceries")
//                        .font(.headline)
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Show To-Buy Items", action: { filter = .toBuy })
                        Button("Show Completed Items", action: { filter = .completed })
                        Button("Show All Items", action: { filter = .all })
                        Button("Clear All Items", action: { showingAlert = true })
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("This will delete all items in your grocery list."),
                    primaryButton: .destructive(Text("Delete")) {
                        clearList()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    
    private var filteredGroceries: [String: [GroceryItem]] {
        switch filter {
        case .all:
            return groceries
        case .completed:
            return groceries.mapValues { $0.filter { $0.isDone } }.filter{!$0.value.isEmpty}
        case .toBuy:
            return groceries.mapValues { $0.filter { !$0.isDone } }.filter{!$0.value.isEmpty}
        }
    }
    
    
    private func addItem() {
        guard !newItemName.isEmpty else { return }
        let newItem = GroceryItem(name: newItemName, quantity: 1, isDone: false)
        groceries[selectedCategory, default: []].append(newItem)
        newItemName = ""
    }
    
    private func toggleDone(item: GroceryItem, in category: String) {
        if let index = groceries[category]?.firstIndex(where: { $0.id == item.id }) {
            groceries[category]?[index].isDone.toggle()
        }
    }
    
    private func increaseQuantity(for item: GroceryItem, in category: String) {
        if let index = groceries[category]?.firstIndex(where: { $0.id == item.id }) {
            groceries[category]?[index].quantity += 1
        }
    }
    
    private func decreaseQuantity(for item: GroceryItem, in category: String) {
        if let index = groceries[category]?.firstIndex(where: { $0.id == item.id }) {
            let newQuantity = groceries[category]?[index].quantity ?? 1
            groceries[category]?[index].quantity = max(newQuantity - 1, 1)
        }
    }
    
    private func deleteItem(at offsets: IndexSet, in category: String) {
        groceries[category]?.remove(atOffsets: offsets)
    }
    
    private func clearList() {
        groceries = [:]
    }
}

struct GroceriesView_Previews: PreviewProvider {
    static var previews: some View {
        GroceriesView()
    }
}











