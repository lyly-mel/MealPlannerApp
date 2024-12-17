
import SwiftUI
import CoreData

struct GroceryItem: Identifiable {
    let id = UUID()
    var name: String
    var quantity: Double
    var unit: String
    var isDone: Bool
}

struct GroceriesView: View {
    @State private var groceries: [String: GroceryItem] = [:] // Grocery items indexed by name
    @State private var newItemName = ""
    @State private var selectedCategory = "Produce"
    @State private var categories = ["Produce", "Meat", "Baking", "other"]
    @State private var filter: FilterOption = .all
    @State private var showingAlert = false

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

//                    Button(action: addItem) {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.title2)
//                            .foregroundColor(.green)
//                    }
                }
                .padding()
                
                // Scrollable List of Groceries
                List {
                    ForEach(Array(filteredGroceries.values), id: \.id) { item in
                        GroceryItemRow(
                            item: item,
                            toggleDone: toggleDone,
                            increaseQuantity: increaseQuantity,
                            decreaseQuantity: decreaseQuantity
                        )
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
            .onAppear(perform: fetchGroceriesFromCoreData)
        }
    }

    private var filteredGroceries: [String: GroceryItem] {
        switch filter {
        case .all:
            return groceries
        case .completed:
            return groceries.filter { $0.value.isDone }
        case .toBuy:
            return groceries.filter { !$0.value.isDone }
        }
    }

    private func fetchGroceriesFromCoreData() {
        var tempGroceries: [String: GroceryItem] = [:]

        let plans = PlanManager.shared.fetchAllPlans()
        for plan in plans {
            let days = PlanManager.shared.fetchDays(for: plan)
            for day in days {
                let meals = PlanManager.shared.fetchMeals(for: day)
                for meal in meals {
                    if let recipes = meal.recipes as? Set<PersonalRecipe> {
                        for recipe in recipes {
                            if let ingredients = recipe.ingredients as? Set<Ingredient> {
                                for ingredient in ingredients {
                                    let name = ingredient.name ?? "Unnamed Ingredient"
                                    let quantity = ingredient.quantity ?? "0"
                                    let unit = ingredient.unit ?? ""

                                    let quantityValue = Double(quantity) ?? 0.0

                                    if let existingItem = tempGroceries[name] {
                                        tempGroceries[name] = GroceryItem(
                                            name: name,
                                            quantity: existingItem.quantity + quantityValue,
                                            unit: unit,
                                            isDone: existingItem.isDone
                                        )
                                    } else {
                                        tempGroceries[name] = GroceryItem(
                                            name: name,
                                            quantity: quantityValue,
                                            unit: unit,
                                            isDone: false
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        groceries = tempGroceries
    }

    private func toggleDone(item: GroceryItem) {
        groceries[item.name]?.isDone.toggle()
    }

    private func increaseQuantity(for item: GroceryItem) {
        groceries[item.name]?.quantity += 1
    }

    private func decreaseQuantity(for item: GroceryItem) {
        if let currentQuantity = groceries[item.name]?.quantity, currentQuantity > 1 {
            groceries[item.name]?.quantity -= 1
        }
    }

    private func clearList() {
        groceries = [:]
    }
}

struct GroceryItemRow: View {
    let item: GroceryItem
    var toggleDone: (GroceryItem) -> Void
    var increaseQuantity: (GroceryItem) -> Void
    var decreaseQuantity: (GroceryItem) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .strikethrough(item.isDone, color: .black)

                if !item.unit.isEmpty {
                    Text("\(item.quantity, specifier: "%.2f") \(item.unit)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .strikethrough(item.isDone, color: .gray)
                }
            }

            Spacer()

            HStack {
                Button(action: {
                    decreaseQuantity(item)
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.gray)
                }

                Text("\(item.quantity, specifier: "%.2f")")
                    .foregroundColor(.secondary)

                Button(action: {
                    increaseQuantity(item)
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.gray)
                }
            }

            Button(action: {
                toggleDone(item)
            }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
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









