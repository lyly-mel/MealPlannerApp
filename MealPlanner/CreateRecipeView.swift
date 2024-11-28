import SwiftUI

struct CreateRecipeView: View {
    // State variables to hold user input
    @State private var recipeName: String = ""
    @State private var ingredients: [String] = []
    @State private var ingredientInput: String = ""
    @State private var preparationSteps: String = ""
    @State private var selectedCategory: String = ""
    @State private var showAlert: Bool = false
    
    // Categories for the picker
    let categories = ["Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]

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
                            TextField("Add an ingredient", text: $ingredientInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: addIngredient) {
                                Text("Add")
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        ForEach(ingredients, id: \.self) { ingredient in
                            HStack {
                                Text(ingredient)
                                Spacer()
                                Button(action: {
                                    removeIngredient(ingredient)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
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
                        Text("None").tag("")
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
    
    // Add ingredient to the list
    private func addIngredient() {
        guard !ingredientInput.isEmpty else { return }
        ingredients.append(ingredientInput)
        ingredientInput = ""
    }
    
    // Remove an ingredient
    private func removeIngredient(_ ingredient: String) {
        ingredients.removeAll { $0 == ingredient }
    }
    
    // Save Recipe
    private func saveRecipe() {
        // Validate input
        guard !recipeName.isEmpty, !ingredients.isEmpty, !preparationSteps.isEmpty, !selectedCategory.isEmpty else {
            return // In a future phase, you could show validation alerts here
        }
        showAlert = true
        // In future phases, save the data to a database or pass it to another view
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}

