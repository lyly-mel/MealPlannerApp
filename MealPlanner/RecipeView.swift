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
//import CoreData

struct RecipeView: View {
    @State private var recipes: [PersonalRecipe] = []

    var body: some View {
        List(recipes, id: \.self) { recipe in
            Text(recipe.name ?? "Untitled Recipe")
        }
        .onAppear {
            recipes = RecipeManager.shared.fetchAllRecipes()
        }
        .navigationTitle("Recipes")
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


