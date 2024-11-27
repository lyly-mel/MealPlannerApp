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
    var recipes: [Recipe]
}

// FavoriteView - Initial View with Categories
struct FavoriteView: View {
    // State to hold all categories
    @State private var categories: [Category] = [
        Category(name: "Breakfast", recipes: [
            Recipe(name: "Pancakes"),
            Recipe(name: "Omelette")
        ]),
        Category(name: "Lunch", recipes: [
            Recipe(name: "Grilled Chicken Salad"),
            Recipe(name: "Veggie Wrap")
        ]),
        Category(name: "Dinner", recipes: [
            Recipe(name: "Spaghetti Bolognese"),
            Recipe(name: "Chicken Curry")
        ]),
        Category(name: "Dessert", recipes: [
            Recipe(name: "Chocolate Cake"),
            Recipe(name: "Ice Cream")
        ]),
        Category(name: "Drinks", recipes: [
            Recipe(name: "Smoothie"),
            Recipe(name: "Lemonade")
        ]),
        Category(name: "Sides", recipes: [
            Recipe(name: "French Fries"),
            Recipe(name: "Garlic Bread")
        ]),
        Category(name: "Cakes", recipes: [
            Recipe(name: "Carrot Cake"),
            Recipe(name: "Red Velvet Cake")
        ]),
        Category(name: "Others", recipes: [
            Recipe(name: "Guacamole"),
            Recipe(name: "Hummus")
        ])
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Display all categories as clickable folders
                List(categories) { category in
                    NavigationLink(destination: CategoryDetailView(category: category)) {
                        HStack {
                            Text(category.name)
                                .font(.headline)
                            Spacer()
                            Image(systemName: "folder.fill")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
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
    var category: Category
    
    var body: some View {
        VStack {
            // Display the category name
            Text(category.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Display recipes within the selected category
            List(category.recipes) { recipe in
                Text(recipe.name)
            }

            Spacer()
        }
        .navigationTitle(category.name)
        .navigationBarItems(leading: Button("Back") {
            // This back button will automatically navigate back to the previous view (Categories)
        })
        .padding()
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
