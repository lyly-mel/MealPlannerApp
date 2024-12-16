
import SwiftUI
import CoreData

struct RecipesListView: View {
    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Drink", "Cake", "Other"]
    let diverseCategories = ["Favorites", "All Recipes", "Cooked"]
    
    var body: some View {
        NavigationView {
            List {
                // Diverse Categories
                Section(header: Text("Diverse Categories").font(.headline)) {
                    ForEach(diverseCategories, id: \.self) { diverseCategory in
                        NavigationLink(destination: CategoryDetailView(categoryName: diverseCategory)) {
                            HStack {
                                Text(diverseCategory)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: symbolForCategory(diverseCategory))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                    }
                }
                
                // Meal Categories
                Section(header: Text("Meal Categories").font(.headline)) {
                    ForEach(categories, id: \.self) { category in
                        NavigationLink(destination: CategoryDetailView(categoryName: category)) {
                            HStack {
                                Text(category)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: symbolForCategory(category))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Personal Recipes")
        }
    }
    
    private func symbolForCategory(_ category: String) -> String {
        switch category {
        case "Breakfast": return "cup.and.saucer"
        case "Lunch": return "fork.knife"
        case "Dinner": return "fork.knife"
        case "Dessert": return "staroflife"
        case "Drink": return "wineglass"
        case "Cake": return "birthday.cake"
        case "Favorites": return "heart.fill"
        case "All Recipes": return "book.fill"
        case "Cooked": return "checkmark.circle"
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
                if(recipes.isEmpty){
                    HStack{
                        Spacer()
                        Text("No recipes found")
                        Spacer()
                    }
                    .listRowBackground(Color(UIColor.systemGroupedBackground)) // Matches the default list background color
                }
                else {
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
                                Button("Add to Favorites") {
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
            }
            .onAppear {
                selectRecipesToFetch()
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
        // TODO: Add logic for editing the recipe
        print("Editing recipe: \(recipe.name ?? "Untitled")")
    }
    
    private func addToFavorite(_ recipe: PersonalRecipe) {
        // TODO: Implement "Add to Favorites" functionality
        print("Adding to favorites: \(recipe.name ?? "Untitled")")
    }
    
    private func deleteRecipe(_ recipe: PersonalRecipe) {
        guard let index = recipes.firstIndex(of: recipe) else { return }
        recipes.remove(at: index)
        RecipeManager.shared.deleteRecipe(recipe)
    }
    
    private func fetchAllRecipes() {
        recipes = RecipeManager.shared.fetchAllRecipes()
    }
    
    private func fetchFavorites() {
        // TODO: Implement fetching favorites
    }
    
    private func fetchCooked() {
        // TODO: Implement fetching cooked meals
    }
    
    private func selectRecipesToFetch() {
        switch categoryName {
        case "Favorites":
            fetchFavorites()
        case "All Recipes":
            fetchAllRecipes()
        case "Cooked":
            fetchCooked()
        default:
            fetchRecipes()
        }
    }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        return RecipesListView()
            .environment(\.managedObjectContext, context)
    }
}

