import SwiftUI

struct HomeView: View {
    @State private var plans: [Plan] = [] // All saved plans
    @State private var mealsForToday: [String] = [] // Planned recipes for today
    @State private var mostRecentPlan: Plan? // The most recent plan

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Planned Recipes for Today
                VStack(alignment: .leading, spacing: 10) {
                    Text("    Recipes planned for today")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    if mealsForToday.isEmpty {
                        Text("    No recipes planned for today!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ScrollView {
                            DisclosureGroup("View Today's Recipes (\(mealsForToday.count))") {
                                ForEach(mealsForToday, id: \.self) { meal in
                                    HStack {
                                        Text("• \(meal)")
                                            .font(.subheadline)
                                        Spacer()
                                    }
                                    .padding(.vertical, 2)
                                    .padding(.horizontal)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        //.frame(height: 150) // Restrict scrollable menu height
                    }
                }
                .padding(.top)

                // Main Header
                HStack {
                    Spacer()
                    Text("     Plan smarter, eat better!")
                        .font(.title)
                        .foregroundColor(.black.opacity(0.8))
                        .shadow(radius: 5)
                    Spacer()
                }

                // Features Section
                HStack(spacing: 20) {
                    Spacer()
                    FeatureCard(title: "Plan Your Meals", icon: "calendar")
                    FeatureCard(title: "Discover Recipes", icon: "book")
                    FeatureCard(title: "Track Groceries", icon: "cart")
                    Spacer()
                }
                .padding(.horizontal)

                // Navigation Buttons
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateRecipeView()) {
                            Text("Create a New Recipe")
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 250)
                                .background(Color.green)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        NavigationLink(destination: MealPlannerView()) {
                            Text("Plan Your Meals")
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 250)
                                .background(Color.green)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Planned Meals Section
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("     Your Planned Meals")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        if plans.isEmpty {
                            HStack {
                                Spacer()
                                Text("   No meal plans found.\nStart planning your meals!")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                Spacer()
                            }
                        } else {
                            HStack {
                                Spacer()
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                    ForEach(plans, id: \.self) { plan in
                                        ZStack(alignment: .topTrailing) {
                                            NavigationLink(destination: PlanDetailsView(plan: plan)) {
                                                VStack(alignment: .leading) {
                                                    Text(plan.name ?? "Unnamed Plan")
                                                        .font(.headline)
                                                        .padding(.vertical, 5)
                                                        .foregroundColor(plan == mostRecentPlan ? .primary : .primary)
                                                    Text("Created: \(formattedDate(plan.createdDate))")
                                                        .font(.footnote)
                                                        .foregroundColor(.gray)
                                                }
                                                .padding()
                                                .background(plan == mostRecentPlan ? Color.green.opacity(0.3) : Color(UIColor.systemGray6))
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                            }

                                            // "X" button for deleting plans
                                            Button(action: {
                                                deletePlan(plan)
                                            }) {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.gray)
                                                    .font(.title3)
                                                    .padding(5)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                Spacer()
                            }
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                fetchPlans()
                fetchMealsForToday()
            }
        }
    }

    // Fetch planned meals for the current day
    private func fetchMealsForToday() {
        let today = Date()
        let formattedToday = formattedDate(today)
        
        var plannedMeals: [String] = []
        let plans = PlanManager.shared.fetchAllPlans()
        
        for plan in plans {
            let days = PlanManager.shared.fetchDays(for: plan)
            for day in days where formattedDate(day.date ?? Date()) == formattedToday {
                let meals = PlanManager.shared.fetchMeals(for: day)
                for meal in meals {
                    if let recipes = meal.recipes as? Set<PersonalRecipe> {
                        plannedMeals.append(contentsOf: recipes.compactMap { $0.name })
                    }
                }
            }
        }
        mealsForToday = plannedMeals
    }

    // Fetch saved plans from CoreData
    private func fetchPlans() {
        plans = PlanManager.shared.fetchAllPlans()
        mostRecentPlan = plans.first
    }

    // Delete a plan
    private func deletePlan(_ plan: Plan) {
        PlanManager.shared.deletePlan(plan)
        fetchPlans()
        fetchMealsForToday()
    }

    // Format the date as a string
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct FeatureCard: View {
    var title: String
    var icon: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 120)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext

        // Create mock data for preview
        let mockPlan1 = Plan(context: context)
        mockPlan1.name = "Weekly Plan"
        mockPlan1.createdDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())

        let mockPlan2 = Plan(context: context)
        mockPlan2.name = "Holiday Plan"
        mockPlan2.createdDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())

        return HomeView()
            .environment(\.managedObjectContext, context)
    }
}

