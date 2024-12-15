import CoreData
import Foundation

class RecipeManager {
    static let shared = RecipeManager()
    private let viewContext = PersistenceController.shared.container.viewContext

    //create a new recipe
    func createRecipe(
        name: String,
        category: String,
        preparationSteps: String,
        ingredients: [(name: String, quantity: String, unit: String)]
    ) {
        let newRecipe = PersonalRecipe(context: viewContext)
        newRecipe.name = name
        newRecipe.category = category
        newRecipe.preparationSteps = preparationSteps

        // Add ingredients to the recipe
        for ingredient in ingredients {
            let newIngredient = Ingredient(context: viewContext)
            newIngredient.name = ingredient.name
            newIngredient.quantity = ingredient.quantity
            newIngredient.unit = ingredient.unit
            newIngredient.recipe = newRecipe
        }

        saveContext()
    }

    //fetch recipe by category
    func fetchRecipes(for category: String) -> [PersonalRecipe] {
        let fetchRequest: NSFetchRequest<PersonalRecipe> = PersonalRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PersonalRecipe.name, ascending: true)]
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch recipes for category \(category): \(error.localizedDescription)")
            return []
        }
    }

    //Fetch all recipes
    func fetchAllRecipes() -> [PersonalRecipe] {
        let fetchRequest: NSFetchRequest<PersonalRecipe> = PersonalRecipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PersonalRecipe.name, ascending: true)]
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch all recipes: \(error.localizedDescription)")
            return []
        }
    }

    //delete a recipe
    func deleteRecipe(_ recipe: PersonalRecipe) {
        viewContext.delete(recipe)
        saveContext()
    }

    //update a recipe
    func updateRecipe(
        recipe: PersonalRecipe,
        name: String,
        category: String,
        preparationSteps: String,
        ingredients: [(name: String, quantity: String, unit: String)]
    ) {
        recipe.name = name
        recipe.category = category
        recipe.preparationSteps = preparationSteps

        // Delete existing ingredients and add new ones
        if let existingIngredients = recipe.ingredients as? Set<Ingredient> {
            for ingredient in existingIngredients {
                viewContext.delete(ingredient)
            }
        }

        for ingredient in ingredients {
            let newIngredient = Ingredient(context: viewContext)
            newIngredient.name = ingredient.name
            newIngredient.quantity = ingredient.quantity
            newIngredient.unit = ingredient.unit
            newIngredient.recipe = recipe
        }

        saveContext()
    }

    //save context
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
