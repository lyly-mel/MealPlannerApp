//
//
//
//import SwiftUI
//
//struct GroceryItem: Identifiable {
//    let id = UUID()
//    var name: String
//    var quantity: Int
//    var isDone: Bool
//}
//
//struct GroceriesView: View {
//    @State private var groceries: [String: [GroceryItem]] = [
//        "Produce": [GroceryItem(name: "Apples", quantity: 5, isDone: false)],
//        "Meat": [GroceryItem(name: "Chicken", quantity: 2, isDone: false)],
//        "Baking": [GroceryItem(name: "Flour", quantity: 1, isDone: true)]
//    ]
//    
//    @State private var newItemName = ""
//    @State private var selectedCategory = "Produce"
//    @State private var categories = ["Produce", "Meat", "Baking"]
//    @State private var filter: FilterOption = .all
//    @State private var showingAlert = false
//    
//    enum FilterOption {
//        case all, completed, toBuy
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Input Section
//                AddItemSection(
//                    newItemName: $newItemName,
//                    selectedCategory: $selectedCategory,
//                    categories: categories,
//                    addItemAction: addItem
//                )
//                
//                // Scrollable List of Groceries
//                List {
//                    ForEach(Array(filteredGroceries.keys), id: \.self) { category in
//                        Section(header: Text(category)) {
//                            ForEach(filteredGroceries[category] ?? []) { item in
//                                GroceryItemRow(
//                                    item: item,
//                                    category: category,
//                                    toggleDone: toggleDone,
//                                    increaseQuantity: increaseQuantity,
//                                    decreaseQuantity: decreaseQuantity
//                                )
//                            }
//                            .onDelete { offsets in
//                                deleteItem(at: offsets, in: category)
//                            }
//                        }
//                    }
//                }
//                .listStyle(InsetGroupedListStyle())
//            }
//            .navigationTitle("GROCERIES")
//            .navigationBarBackButtonHidden(true) // This view won't have a back button
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Menu {
//                        Button("Show To-Buy Items", action: { filter = .toBuy })
//                        Button("Show Completed Items", action: { filter = .completed })
//                        Button("Show All Items", action: { filter = .all })
//                        Button("Clear All Items", action: { showingAlert = true })
//                    } label: {
//                        Image(systemName: "ellipsis")
//                            .font(.title2)
//                            .foregroundColor(.green)
//                    }
//                }
//            }
//            .alert(isPresented: $showingAlert) {
//                Alert.clearAllAlert(confirmAction: clearList)
//            }
//        }
//    }
//    
//    private var filteredGroceries: [String: [GroceryItem]] {
//        switch filter {
//        case .all:
//            return groceries
//        case .completed:
//            return groceries.mapValues { $0.filter { $0.isDone } }.filter { !$0.value.isEmpty }
//        case .toBuy:
//            return groceries.mapValues { $0.filter { !$0.isDone } }.filter { !$0.value.isEmpty }
//        }
//    }
//    
//    private func addItem() {
//        guard !newItemName.isEmpty else { return }
//        let newItem = GroceryItem(name: newItemName, quantity: 1, isDone: false)
//        groceries[selectedCategory, default: []].append(newItem)
//        newItemName = ""
//    }
//    
//    private func toggleDone(item: GroceryItem, in category: String) {
//        groceries[category] = groceries[category]?.map {
//            $0.id == item.id ? GroceryItem(name: $0.name, quantity: $0.quantity, isDone: !$0.isDone) : $0
//        }
//    }
//    
//    private func increaseQuantity(for item: GroceryItem, in category: String) {
//        if let index = groceries[category]?.firstIndex(where: { $0.id == item.id }) {
//            groceries[category]?[index].quantity += 1
//        }
//    }
//    
//    private func decreaseQuantity(for item: GroceryItem, in category: String) {
//        if let index = groceries[category]?.firstIndex(where: { $0.id == item.id }) {
//            let newQuantity = groceries[category]?[index].quantity ?? 1
//            groceries[category]?[index].quantity = max(newQuantity - 1, 1)
//        }
//    }
//    
//    private func deleteItem(at offsets: IndexSet, in category: String) {
//        groceries[category]?.remove(atOffsets: offsets)
//    }
//    
//    private func clearList() {
//        groceries = [:]
//    }
//}
//
//struct AddItemSection: View {
//    @Binding var newItemName: String
//    @Binding var selectedCategory: String
//    var categories: [String]
//    var addItemAction: () -> Void
//
//    var body: some View {
//        HStack {
//            TextField("Add new item", text: $newItemName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .frame(maxWidth: .infinity)
//            
//            Picker("Category", selection: $selectedCategory) {
//                ForEach(categories, id: \.self) { category in
//                    Text(category).tag(category)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            
//            Button(action: addItemAction) {
//                Image(systemName: "plus.circle.fill")
//                    .font(.title2)
//                    .foregroundColor(.green)
//            }
//        }
//        .padding()
//    }
//}
//
//struct GroceryItemRow: View {
//    let item: GroceryItem
//    let category: String
//    var toggleDone: (GroceryItem, String) -> Void
//    var increaseQuantity: (GroceryItem, String) -> Void
//    var decreaseQuantity: (GroceryItem, String) -> Void
//
//    var body: some View {
//        HStack {
//            Text(item.name)
//                .strikethrough(item.isDone, color: .black)
//            Text("  \(item.quantity)")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .strikethrough(item.isDone, color: .gray)
//            
//            Spacer()
//            
//            Button(action: { increaseQuantity(item, category) }) {
//                Image(systemName: "plus.circle")
//                    .foregroundColor(.black)
//            }
//            
//            Button(action: { decreaseQuantity(item, category) }) {
//                Image(systemName: "minus.circle")
//                    .foregroundColor(.black)
//            }
//            
//            Button(action: { toggleDone(item, category) }) {
//                Image(systemName: item.isDone ? "checkmark.circle.fill" : "trash")
//                    .foregroundColor(item.isDone ? .green : .gray)
//            }
//        }
//    }
//}
//
//extension Alert {
//    static func clearAllAlert(confirmAction: @escaping () -> Void) -> Alert {
//        Alert(
//            title: Text("Are you sure?"),
//            message: Text("This will delete all items in your grocery list."),
//            primaryButton: .destructive(Text("Delete"), action: confirmAction),
//            secondaryButton: .cancel()
//        )
//    }
//}
//
//struct GroceriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroceriesView()
//    }
//}
//
//
//
//



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
                                GroceryItemRow(
                                    item: item,
                                    category: category,
                                    toggleDone: toggleDone,
                                    increaseQuantity: increaseQuantity,
                                    decreaseQuantity: decreaseQuantity
                                )
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("GROCERIES")
            .toolbar {
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
        .navigationBarBackButtonHidden(true) // No back button for this view
    }
    
    private var filteredGroceries: [String: [GroceryItem]] {
        switch filter {
        case .all:
            return groceries
        case .completed:
            return groceries.mapValues { $0.filter { $0.isDone } }.filter { !$0.value.isEmpty }
        case .toBuy:
            return groceries.mapValues { $0.filter { !$0.isDone } }.filter { !$0.value.isEmpty }
        }
    }
    
    private func addItem() {
        guard !newItemName.isEmpty else { return }
        let newItem = GroceryItem(name: newItemName, quantity: 1, isDone: false)
        groceries[selectedCategory, default: []].append(newItem)
        newItemName = ""
    }
    
    private func toggleDone(item: GroceryItem, in category: String) {
        groceries[category] = groceries[category]?.map { grocery in
            if grocery.id == item.id {
                return GroceryItem(name: grocery.name, quantity: grocery.quantity, isDone: !grocery.isDone)
            }
            return grocery
        }
    }
    
    private func increaseQuantity(for item: GroceryItem, in category: String) {
        groceries[category] = groceries[category]?.map { grocery in
            if grocery.id == item.id {
                return GroceryItem(name: grocery.name, quantity: grocery.quantity + 1, isDone: grocery.isDone)
            }
            return grocery
        }
    }
    
    private func decreaseQuantity(for item: GroceryItem, in category: String) {
        groceries[category] = groceries[category]?.map { grocery in
            if grocery.id == item.id && grocery.quantity > 1 {
                return GroceryItem(name: grocery.name, quantity: grocery.quantity - 1, isDone: grocery.isDone)
            }
            return grocery
        }
    }
    
    private func clearList() {
        groceries = [:]
    }
}

struct GroceryItemRow: View {
    let item: GroceryItem
    let category: String
    var toggleDone: (GroceryItem, String) -> Void
    var increaseQuantity: (GroceryItem, String) -> Void
    var decreaseQuantity: (GroceryItem, String) -> Void

    var body: some View {
        HStack {
            Text(item.name)
                .strikethrough(item.isDone, color: .black)

            Text("\(item.quantity)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .strikethrough(item.isDone, color: .gray)

            Spacer()

            Button(action: {
                increaseQuantity(item, category)
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.gray)
            }

            Button(action: {
                decreaseQuantity(item, category)
            }) {
                Image(systemName: "minus.circle")
                    .foregroundColor(.gray)
            }

            Button(action: {
                toggleDone(item, category)
            }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "trash")
                    .foregroundColor(item.isDone ? .green : .gray)
            }
        }
    }
}

struct GroceriesView_Previews: PreviewProvider {
    static var previews: some View {
        GroceriesView()
    }
}





