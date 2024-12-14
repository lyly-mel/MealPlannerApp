////
////  RecipeListView.swift
////  MealPlanner
////
////  Created by lylia melahi on 12/10/24.
////
//
import Foundation
import SwiftUI

struct RecipeListView: View {
    @FetchRequest(
        entity: PersonalRecipe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecipe.name, ascending: true)]
    ) var recipes: FetchedResults<PersonalRecipe>

    var body: some View {
        NavigationView {
            List {
                ForEach(recipes, id: \.self) { recipe in
                    VStack(alignment: .leading) {
                        Text(recipe.name ?? "Unnamed Recipe")
                            .font(.headline)
                        Text(recipe.category ?? "No Category")
                            .font(.subheadline)

                        if let ingredients = recipe.ingredients as? Set<Ingredient> {
                            ForEach(Array(ingredients), id: \.self) { ingredient in
                                Text("- \(ingredient.quantity ?? "") \(ingredient.unit ?? "") \(ingredient.name ?? "")")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
        }
    }
}

