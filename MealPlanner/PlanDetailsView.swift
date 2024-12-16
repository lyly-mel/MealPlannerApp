//
//  PlanDetailsView.swift
//  MealPlanner
//
//  Created by lylia melahi on 12/16/24.
//

import SwiftUI

struct PlanDetailsView: View {
    let plan: Plan

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(plan.name ?? "Unnamed Plan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                if let days = plan.days as? Set<Day> {
                    ForEach(days.sorted(by: { $0.date ?? Date() < $1.date ?? Date() }), id: \.self) { day in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date: \(formattedDate(day.date))")
                                .font(.headline)

                            if let meals = day.meals as? Set<Meal> {
                                ForEach(meals.sorted(by: { $0.name ?? "" < $1.name ?? "" }), id: \.self) { meal in
                                    DisclosureGroup("\(meal.name ?? "Unnamed Meal")") {
                                        if let recipes = meal.recipes as? Set<PersonalRecipe> {
                                            ForEach(recipes.sorted(by: { $0.name ?? "" < $1.name ?? "" }), id: \.self) { recipe in
                                                Text("- \(recipe.name ?? "Unnamed Recipe")")
                                                    .font(.footnote)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                } else {
                    Text("No days planned for this plan.")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .navigationTitle(plan.name ?? "Plan Details")
    }

    // Format the date as a string
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct PlanDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext

        // Mock Plan and related entities
        let mockPlan = Plan(context: context)
        mockPlan.name = "Mock Plan"
        mockPlan.createdDate = Date()

        let mockDay1 = Day(context: context)
        mockDay1.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        mockDay1.plan = mockPlan

        let mockMeal1 = Meal(context: context)
        mockMeal1.name = "Breakfast"
        mockMeal1.day = mockDay1

        let mockRecipe1 = PersonalRecipe(context: context)
        mockRecipe1.name = "Pancakes"
        mockMeal1.addToRecipes(mockRecipe1)

        let mockMeal2 = Meal(context: context)
        mockMeal2.name = "Lunch"
        mockMeal2.day = mockDay1

        let mockRecipe2 = PersonalRecipe(context: context)
        mockRecipe2.name = "Grilled Chicken Salad"
        mockMeal2.addToRecipes(mockRecipe2)

        let mockDay2 = Day(context: context)
        mockDay2.date = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        mockDay2.plan = mockPlan

        let mockMeal3 = Meal(context: context)
        mockMeal3.name = "Dinner"
        mockMeal3.day = mockDay2

        let mockRecipe3 = PersonalRecipe(context: context)
        mockRecipe3.name = "Spaghetti Bolognese"
        mockMeal3.addToRecipes(mockRecipe3)

        return PlanDetailsView(plan: mockPlan)
            .environment(\.managedObjectContext, context)
    }
}

