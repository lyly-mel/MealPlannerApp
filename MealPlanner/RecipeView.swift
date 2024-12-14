//import SwiftUI
//import CoreData
//
//struct RecipeListView: View {
//    @FetchRequest(
//        entity: PersonalRecipe.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecipe.name, ascending: true)]
//    ) var recipes: FetchedResults<PersonalRecipe>
//    
//    var body: some View {
//        NavigationView {
//            List {
//                if recipes.isEmpty {
//                    Text("No recipes found. Add some!")
//                        .foregroundColor(.gray)
//                        .italic()
//                } else {
//                    ForEach(recipes, id: \.self) { recipe in
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(recipe.name ?? "Untitled Recipe")
//                                .font(.headline)
//                            Text("Category: \(recipe.category ?? "Unknown")")
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                            
//                            if let ingredients = recipe.ingredients as? Set<Ingredient>, !ingredients.isEmpty {
//                                Text("Ingredients:")
//                                    .font(.subheadline)
//                                    .bold()
//                                ForEach(ingredients.sorted { $0.name ?? "" < $1.name ?? "" }, id: \.self) { ingredient in
//                                    Text("- \(ingredient.quantity ?? "1") \(ingredient.unit ?? "") \(ingredient.name ?? "Unknown")")
//                                }
//                            }
//                            
//                            if let steps = recipe.preparationSteps, !steps.isEmpty {
//                                Text("Steps: \(steps)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                        .padding(.vertical, 5)
//                    }
//                }
//            }
//            .navigationTitle("Saved Recipes")
//        }
//    }
//}
//
//struct RecipeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeListView()
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}

import SwiftUI
import CoreData

struct RecipeView: View {
    let recipe: PersonalRecipe
    @State private var selectedSection: Section = .ingredients

    enum Section {
        case ingredients, preparationSteps
    }

    var body: some View {
        VStack {
            // Section Selector
            HStack {
                Button(action: {
                    selectedSection = .ingredients
                }) {
                    Text("Ingredients")
                        .font(.headline)
                        .foregroundColor(selectedSection == .ingredients ? .black : .gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(selectedSection == .ingredients ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(4)
                }

                Button(action: {
                    selectedSection = .preparationSteps
                }) {
                    Text("Preparation Steps")
                        .font(.headline)
                        .foregroundColor(selectedSection == .preparationSteps ? .black : .gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(selectedSection == .preparationSteps ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            Divider()

            if selectedSection == .ingredients {
                IngredientsView(recipe: recipe)
            } else {
                PreparationStepsView(recipe: recipe)
            }

            Spacer()
        }
        .navigationTitle(recipe.name ?? "Recipe Details")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

struct IngredientsView: View {
    let recipe: PersonalRecipe

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Spacer()
                   .frame(height: 10)
                if let ingredients = recipe.ingredients as? Set<Ingredient> {
                    ForEach(ingredients.sorted { $0.name ?? "" < $1.name ?? "" }, id: \.self) { ingredient in
                        HStack(spacing: 5) {
                            Circle()
                                .frame(width: 6, height: 6)
                               
                            Text(" \(ingredient.quantity ?? "") \(ingredient.unit ?? "")")
                                .font(.headline)
                                //.multilineTextAlignment(.center)
                            Text(ingredient.name ?? "Unnamed Ingredient")
                                .font(.body)
                                .fontWeight(.medium)
                                //.multilineTextAlignment(.center)
                        }
                    }
                } else {
                    Text("No ingredients available.")
                }
            }
        }
    }
}




// PreparationStepsView - Displays the preparation steps of the recipe
struct PreparationStepsView: View {
    let recipe: PersonalRecipe

    var body: some View {
        ScrollView {
            Text(recipe.preparationSteps ?? "No preparation steps available.")
                .padding()
                .font(.body)
                .fontWeight(.medium)
               // .multilineTextAlignment(.leading)
        }
    }
}


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext

        // Create a mock recipe for the preview
        let mockRecipe = PersonalRecipe(context: context)
        mockRecipe.name = "Mock Recipe"
        mockRecipe.category = "Dinner"
        mockRecipe.preparationSteps = "1. Step one\n2. Step two\n3. Step three"

        // Add some mock ingredients
        let mockIngredient1 = Ingredient(context: context)
        mockIngredient1.name = "Ingredient 1"
        mockIngredient1.quantity = "1"
        mockIngredient1.unit = "cup"
        mockIngredient1.recipe = mockRecipe

        let mockIngredient2 = Ingredient(context: context)
        mockIngredient2.name = "Ingredient 2"
        mockIngredient2.quantity = "2"
        mockIngredient2.unit = "tablespoons"
        mockIngredient2.recipe = mockRecipe

        return RecipeView(recipe: mockRecipe)
            .environment(\.managedObjectContext, context)
    }
}






