//import SwiftUI
//import CoreData
//
//// RecipesListView - Initial View with Categories
//struct RecipesListView: View {
//    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Drink", "Cake", "Other"]
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                List(categories, id: \.self) { category in
//                    NavigationLink(destination: CategoryDetailView(categoryName: category)) {
//                        HStack {
//                            Text(category)
//                                .font(.headline)
//                            Spacer()
//                            Image(systemName: symbolForCategory(category))
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
//                        .cornerRadius(8)
//                    }
//                }
//                .navigationTitle("Personal Recipes")
//            }
//        }
//    }
//
//    private func symbolForCategory(_ category: String) -> String {
//        switch category {
//        case "Breakfast": return "cup.and.saucer"
//        case "Lunch": return "fork.knife"
//        case "Dinner": return "fork.knife"
//        case "Dessert": return "staroflife"
//        case "Drinks": return "wineglass"
//        case "Cakes": return "birthday.cake"
//        default: return "questionmark"
//        }
//    }
//}
//
//// CategoryDetailView - View to show recipes in the selected category
//struct CategoryDetailView: View {
//    let categoryName: String
//    @State private var recipes: [PersonalRecipe] = []
//
//    var body: some View {
//        VStack {
//            // Category name
//            Text(categoryName)
//                .font(.title)
//                .fontWeight(.bold)
//            
//            // List of recipes in the category
//            List {
//                ForEach(recipes, id: \.self) { recipe in
//                    Text(recipe.name ?? "Untitled Recipe")
//                }
//                .onDelete(perform: deleteRecipe)
//            }
//            .onAppear {
//                fetchRecipes()
//            }
//
//            Spacer()
//        }
//    }
//
//    // Fetch recipes from Core Data for the selected category
//    private func fetchRecipes() {
//        recipes = RecipeManager.shared.fetchRecipes(for: categoryName)
//    }
//
//    // Delete a recipe from Core Data
//    private func deleteRecipe(at offsets: IndexSet) {
//        offsets.map { recipes[$0] }.forEach { recipe in
//            RecipeManager.shared.deleteRecipe(recipe)
//        }
//        fetchRecipes() // Refresh the list after deletion
//    }
//}
//
//struct RecipesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipesListView()
//    }
//}

import SwiftUI
import CoreData

struct RecipesListView: View {
    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Drinks", "Cakes", "Others"]

    var body: some View {
        NavigationView {
            VStack {
                List(categories, id: \.self) { category in
                    NavigationLink(destination: CategoryDetailView(categoryName: category)) {
                        HStack {
                            Text(category)
                                .font(.headline)
                            Spacer()
                            Image(systemName: symbolForCategory(category))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(8)
                    }
                }
                .navigationTitle("Personal Recipes")
            }
        }
    }

    private func symbolForCategory(_ category: String) -> String {
        switch category {
        case "Breakfast": return "cup.and.saucer"
        case "Lunch": return "fork.knife"
        case "Dinner": return "fork.knife"
        case "Dessert": return "staroflife"
        case "Drinks": return "wineglass"
        case "Cakes": return "birthday.cake"
        default: return "questionmark"
        }
    }
}

// CategoryDetailView - Displays recipes for a selected category
struct CategoryDetailView: View {
    let categoryName: String
    @State private var recipes: [PersonalRecipe] = []

    var body: some View {
        VStack {
            // Category name
            Text(categoryName)
                .font(.title)
                .fontWeight(.bold)
            
            // List of recipes
            List {
                ForEach(recipes, id: \.self) { recipe in
                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                        Text(recipe.name ?? "Untitled Recipe")
                    }
                }
            }
            .onAppear {
                fetchRecipes()
            }

            Spacer()
        }
    }

    private func fetchRecipes() {
        recipes = RecipeManager.shared.fetchRecipes(for: categoryName)
    }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView()
    }
}
