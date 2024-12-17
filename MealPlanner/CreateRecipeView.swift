import SwiftUI
import CoreData

struct CreateRecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var recipeName: String = ""
    @State private var ingredients: [(name: String, quantity: String, unit: String)] = []
    @State private var ingredientName: String = ""
    @State private var ingredientQuantity: String = ""
    @State private var preparationSteps: String = ""
    @State private var selectedCategory: String = "Breakfast"
    @State private var showAlert: Bool = false
    @State private var selectedUnit = "unit"
    @State private var units = ["unit", "bag", "gram", "kilogram","liter", "block", "bottle", "box", "can", "cup",
                                "gallon", "jar", "ounce", "package", "pint", "pound", "quart"]
    
    // Categories for the picker
    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Drink", "Cake", "Other"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Recipe Name
                    Text("Recipe Name")
                        .font(.headline)
                    TextField("Enter recipe name", text: $recipeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom)
                    
                    // Ingredients Section
                    Text("Ingredients")
                        .font(.headline)
                    VStack {
                        HStack {
                            TextField("Ingredient name", text: $ingredientName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Quantity", text: $ingredientQuantity)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80) // Smaller width for quantity
                                .keyboardType(.numberPad) // Numeric keyboard
                                .onChange(of: ingredientQuantity) { newValue in
                                    // Allow only positive numbers
                                    ingredientQuantity = newValue.filter { $0.isNumber }
                                }
                            Picker("unit", selection: $selectedUnit) {
                                ForEach(units, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Button(action: addIngredient) {
                                Text("Add")
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        ForEach(ingredients, id: \.name) { ingredient in
                            HStack {
                                Text("\(ingredient.quantity) \(ingredient.unit) \(ingredient.name)")
                                Spacer()
                                Button(action: {
                                    removeIngredient(ingredient.name)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    
                    // Preparation Steps
                    Text("Preparation Steps")
                        .font(.headline)
                    TextEditor(text: $preparationSteps)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    
                    // Category Picker
                    Text("Category")
                        .font(.headline)
                    Picker("Select a category", selection: $selectedCategory) {
                        //Text("Breakfast").tag("")
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                    // Save Button
                    Button(action: saveRecipe) {
                        Text("Save Recipe")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Recipe Saved"), message: Text("Your recipe '\(recipeName)' has been saved successfully."), dismissButton: .default(Text("OK")))
                                                    
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Create Recipe")
        }
    }
    
    //adjust the units
    private func adjustUnits () {
        switch selectedUnit {
        case "unit":
            selectedUnit = ""
        case "gram":
            selectedUnit = "g"
        case "kilogram":
            selectedUnit = "kg"
        case "ounce":
            selectedUnit = "oz"
        case "pint":
            selectedUnit = "pt"
        case "quart":
            selectedUnit = "qt"
        case "pound":
            selectedUnit = "lb"
        case "liter":
            selectedUnit = "l"
        default:
            selectedUnit = selectedUnit
        }
    }
    
    // Add ingredient with quantity to the list
    private func addIngredient() {
        // Ensure the ingredient name is not empty
        guard !ingredientName.isEmpty else { return }

        // Allow empty quantity to be represented as ""
        let sanitizedQuantity = ingredientQuantity.trimmingCharacters(in: .whitespaces)
        
        //adjust the print of the unit
        adjustUnits()

        ingredients.append((name: ingredientName, quantity: sanitizedQuantity, unit: selectedUnit))
        ingredientName = ""
        ingredientQuantity = ""
        selectedUnit = "unit"
    }
    
    // Remove an ingredient
    private func removeIngredient(_ name: String) {
        ingredients.removeAll { $0.name == name }
    }
    
    // Save Recipe
    private func saveRecipe() {
        // Validate input
        guard !recipeName.isEmpty, !ingredients.isEmpty, !preparationSteps.isEmpty, !selectedCategory.isEmpty else {
            return // In a future phase, you could show validation alerts here
        }
        // Create a new recipe
        let newRecipe = PersonalRecipe(context: viewContext)
        newRecipe.name = recipeName
        newRecipe.preparationSteps = preparationSteps
        newRecipe.category = selectedCategory

        // Add ingredients
        for ingredient in ingredients {
            let newIngredient = Ingredient(context: viewContext)
            newIngredient.name = ingredient.name
            newIngredient.quantity = ingredient.quantity
            newIngredient.unit = ingredient.unit
            newIngredient.recipe = newRecipe
        }

        // Save to Core Data
        do {
            try viewContext.save()
            print("Recipe saved!")
            showAlert = true
        } catch {
            print("Failed to save recipe: \(error.localizedDescription)")
        }
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}






