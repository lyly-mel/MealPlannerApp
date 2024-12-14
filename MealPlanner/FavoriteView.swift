import SwiftUI

// Recipe Model
struct Recipe: Identifiable {
    var id = UUID()
    var name: String
}

// Category Model
struct Category: Identifiable {
    var id = UUID()
    var name: String
    var symbol: String
    var recipes: [Recipe]
}

// FavoriteView - Initial View with Categories
struct FavoriteView: View {
    // State to hold all categories
    @State private var categories: [Category] = [
        Category(name: "Breakfast", symbol: "cup.and.saucer",
            recipes: [
            Recipe(name: "Pancakes"),
            Recipe(name: "Omelette")
        ]),
        Category(name: "Lunch", symbol: "fork.knife",
            recipes: [
            Recipe(name: "Grilled Chicken Salad"),
            Recipe(name: "Veggie Wrap")
        ]),
        Category(name: "Dinner", symbol: "fork.knife",
            recipes: [
            Recipe(name: "Spaghetti Bolognese"),
            Recipe(name: "Chicken Curry")
        ]),
        Category(name: "Dessert", symbol: "staroflife",
            recipes: [
            Recipe(name: "Chocolate Cake"),
            Recipe(name: "Ice Cream")
        ]),
        Category(name: "Drinks", symbol: "wineglass",
            recipes: [
            Recipe(name: "Smoothie"),
            Recipe(name: "Lemonade")
        ]),
        Category(name: "Sides", symbol: "carrot",
            recipes: [
            Recipe(name: "French Fries"),
            Recipe(name: "Garlic Bread")
        ]),
        Category(name: "Cakes", symbol: "birthday.cake",
            recipes: [
            Recipe(name: "Carrot Cake"),
            Recipe(name: "Red Velvet Cake")
        ]),
        Category(name: "Others", symbol: "questionmark",
            recipes: [
            Recipe(name: "Guacamole"),
            Recipe(name: "Hummus")
        ])
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List(categories) { category in
                    NavigationLink(destination: CategoryDetailView(category: category)) {
                        HStack {
                            Text(category.name)
                                .font(.headline)
                            Spacer()
                            Image(systemName: category.symbol)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .cornerRadius(8)
                    }
                }
                .navigationTitle("Favorite Recipes")
            }
        }
    }
}

// CategoryDetailView - View to show the selected category's recipes

struct CategoryDetailView: View {
    @State var category: Category  // Make it @State to allow mutation
    
    var body: some View {
        VStack {
            // Category name
            Text(category.name)
                .font(.title)
                .fontWeight(.bold)
            
            // List of recipes with delete functionality
            List {
                ForEach(category.recipes) { recipe in
                    Text(recipe.name)
                }
                .onDelete(perform: deleteRecipe) // Swipe-to-delete functionality
            }
            
            Spacer()
        }
        .navigationBarTitle("Category Details", displayMode: .inline) // Optional: Set navigation bar title
    }
    
    // Function to delete a recipe from the list
    private func deleteRecipe(at offsets: IndexSet) {
        category.recipes.remove(atOffsets: offsets)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
