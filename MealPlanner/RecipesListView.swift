
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

// Displays recipes for a selected category
struct CategoryDetailView: View {
    let categoryName: String
    @State private var recipes: [PersonalRecipe] = []
    @State private var showAlert = false
    @State private var recipeToDelete: PersonalRecipe?

    var body: some View {
        VStack {
            Text(categoryName)
                .font(.title)
                .fontWeight(.bold)
            
            List {
                ForEach(recipes, id: \.self) { recipe in
                    HStack {
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            Text(recipe.name ?? "Untitled Recipe")
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes the default button styling (including the > symbol)
                        
                        Spacer()
                        
                        Menu {
                            Button("Edit Recipe") {
                                editRecipe(recipe)
                            }
                            Button("Add to Favorite") {
                                addToFavorite(recipe)
                            }
                            Button("Delete Recipe", role: .destructive) {
                                recipeToDelete = recipe
                                showAlert = true
                            }
                           
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .onAppear {
                fetchRecipes()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Recipe"),
                    message: Text("Are you sure you want to delete this recipe?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let recipe = recipeToDelete {
                            deleteRecipe(recipe)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }

            Spacer()
        }
    }

    private func fetchRecipes() {
        recipes = RecipeManager.shared.fetchRecipes(for: categoryName)
    }
    
    private func editRecipe(_ recipe: PersonalRecipe) {
        // TO DO: Add logic for editing recipe
        print("Editing recipe: \(recipe.name ?? "Untitled")")
    }
    
    private func addToFavorite(_ recipe: PersonalRecipe) {
        //TO DO: implement add to favorite
        print("adding to favorite: \(recipe.name ?? "Unititled")")
    }

    private func deleteRecipe(_ recipe: PersonalRecipe) {
        guard let index = recipes.firstIndex(of: recipe) else { return }
        recipes.remove(at: index)
        RecipeManager.shared.deleteRecipe(recipe)
    }
}


struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        // Create mock recipes for preview
        let mockRecipe1 = PersonalRecipe(context: context)
        mockRecipe1.name = "Mock Recipe 1"
        mockRecipe1.category = "Dinner"

        let mockRecipe2 = PersonalRecipe(context: context)
        mockRecipe2.name = "Mock Recipe 2"
        mockRecipe2.category = "Dinner"
        
        return RecipesListView()
            .environment(\.managedObjectContext, context)
    }
}


//import SwiftUI
//import CoreData
//
//struct RecipesListView: View {
//    let categoryName: String
//    
//    @State private var recipes: [PersonalRecipe] = []
//
//    var body: some View {
//        VStack {
//            Text(categoryName)
//                .font(.title)
//                .fontWeight(.bold)
//            
//            List {
//                ForEach(recipes, id: \.self) { recipe in
//                    HStack {
//                        NavigationLink(destination: RecipeView(recipe: recipe)) {
//                            Text(recipe.name ?? "Untitled Recipe")
//                        }
//                        Spacer()
//                        
//                        // Dropdown Menu for Edit/Delete
//                        Menu {
//                            Button("Edit Recipe") {
//                                editRecipe(recipe)
//                            }
//                            Button("Delete Recipe", role: .destructive) {
//                                deleteRecipe(recipe)
//                            }
//                        } label: {
//                            Image(systemName: "ellipsis")
//                                .rotationEffect(.degrees(90)) // Rotate to vertical
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                fetchRecipes()
//            }
//
//            Spacer()
//        }
//    }
//
//    private func fetchRecipes() {
//        recipes = RecipeManager.shared.fetchRecipes(for: categoryName)
//    }
//
//    private func editRecipe(_ recipe: PersonalRecipe) {
//        // Implement the logic for editing the recipe here
//        print("Editing recipe: \(recipe.name ?? "Untitled")")
//    }
//
//    private func deleteRecipe(_ recipe: PersonalRecipe) {
//        guard let index = recipes.firstIndex(of: recipe) else { return }
//        recipes.remove(at: index)
//        RecipeManager.shared.deleteRecipe(recipe)
//    }
//}
//
//struct RecipesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.shared.container.viewContext
//        
//        // Create mock recipes for preview
//        let mockRecipe1 = PersonalRecipe(context: context)
//        mockRecipe1.name = "Mock Recipe 1"
//        mockRecipe1.category = "Dinner"
//
//        let mockRecipe2 = PersonalRecipe(context: context)
//        mockRecipe2.name = "Mock Recipe 2"
//        mockRecipe2.category = "Dinner"
//
//        // Inject the category name
//        return RecipesListView(categoryName: "Dinner")
//            .environment(\.managedObjectContext, context)
//    }
//}
