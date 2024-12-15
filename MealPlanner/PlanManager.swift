//
//  PlanManager.swift
//  MealPlanner
//
//  Created by lylia melahi on 12/15/24.
//

import CoreData
import Foundation

class PlanManager {
    static let shared = PlanManager()
    private let viewContext = PersistenceController.shared.container.viewContext

    // create a new plan
    func createPlan(name: String, createdDate: Date) -> Plan {
        let newPlan = Plan(context: viewContext)
        newPlan.name = name
        newPlan.createdDate = createdDate

        saveContext()
        return newPlan
    }

    // create a new day
    func createDay(for plan: Plan, date: Date) -> Day {
        let newDay = Day(context: viewContext)
        newDay.date = date
        newDay.plan = plan

        saveContext()
        return newDay
    }

    // create a new meal
    func createMeal(for day: Day, name: String,recipes: [PersonalRecipe]) -> Meal {
        let newMeal = Meal(context: viewContext)
        newMeal.name = name
        newMeal.day = day

        // Associate recipes with the meal
        for recipe in recipes {
            newMeal.addToRecipes(recipe)
        }

        saveContext()
        return newMeal
    }

    // fetch all plans
    func fetchAllPlans() -> [Plan] {
        let fetchRequest: NSFetchRequest<Plan> = Plan.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Plan.createdDate, ascending: false)]
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch plans: \(error.localizedDescription)")
            return []
        }
    }

    // fetch days for a plan
    func fetchDays(for plan: Plan) -> [Day] {
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "plan == %@", plan)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch days for plan \(plan.name ?? "Unknown"): \(error.localizedDescription)")
            return []
        }
    }

    // fetch meals for a day
    func fetchMeals(for day: Day) -> [Meal] {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "day == %@", day)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Meal.name, ascending: true)]
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch meals for day \(day.date): \(error.localizedDescription)")
            return []
        }
    }

    // update plan
    func updatePlan(plan: Plan, name: String) {
        plan.name = name
        saveContext()
    }

    // delete plan
    func deletePlan(_ plan: Plan) {
        // Delete associated days and meals
        if let days = plan.days as? Set<Day> {
            for day in days {
                deleteDay(day)
            }
        }
        viewContext.delete(plan)
        saveContext()
    }

    // delete day
    func deleteDay(_ day: Day) {
        // Delete associated meals
        if let meals = day.meals as? Set<Meal> {
            for meal in meals {
                deleteMeal(meal)
            }
        }
        viewContext.delete(day)
        saveContext()
    }

    // delete a meal
    func deleteMeal(_ meal: Meal) {
        // Remove relationships with recipes
        meal.removeFromRecipes(meal.recipes ?? NSSet())
        viewContext.delete(meal)
        saveContext()
    }

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


