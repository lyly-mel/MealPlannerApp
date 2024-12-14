import CoreData
import Foundation

class RecipeManager {
    static let shared = RecipeManager()

    private let viewContext = PersistenceController.shared.container.viewContext

    // Fetch all recipes
    func fetchAllRecipes() -> [PersonalRecipe] {
        let fetchRequest: NSFetchRequest<PersonalRecipe> = PersonalRecipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PersonalRecipe.name, ascending: true)]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch recipes: \(error.localizedDescription)")
            return []
        }
    }

    // Save a new recipe
    func saveRecipe(name: String, category: String, preparationSteps: String, ingredients: [(name: String, quantity: String, unit: String)]) {
        let newRecipe = PersonalRecipe(context: viewContext)
        newRecipe.name = name
        newRecipe.category = category
        newRecipe.preparationSteps = preparationSteps

        for ingredient in ingredients {
            let newIngredient = Ingredient(context: viewContext)
            newIngredient.name = ingredient.name
            newIngredient.quantity = ingredient.quantity
            newIngredient.unit = ingredient.unit
            newIngredient.recipe = newRecipe
        }

        saveContext()
    }

    // Delete a recipe
    func deleteRecipe(_ recipe: PersonalRecipe) {
        viewContext.delete(recipe)
        saveContext()
    }

    // Update a recipe
    func updateRecipe(_ recipe: PersonalRecipe, name: String, category: String, preparationSteps: String) {
        recipe.name = name
        recipe.category = category
        recipe.preparationSteps = preparationSteps
        saveContext()
    }

    // Save the Core Data context
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                print("Changes saved to Core Data.")
            } catch {
                print("Failed to save changes: \(error.localizedDescription)")
            }
        }
    }
}
