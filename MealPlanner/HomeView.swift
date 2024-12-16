//import SwiftUI
//
//struct HomeView: View {
//    @State private var plans: [Plan] = [] // All saved plans
//    @State private var mostRecentPlan: Plan? // The most recent plan
//
//    var body: some View {
//        NavigationView {
//            //ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Text("     Plan smarter, eat better!")
//                            .font(.title)
//                            .foregroundColor(.black.opacity(0.8))
//                            .shadow(radius: 5)
//                        Spacer()
//                    }
//                   
//
//                    HStack(spacing: 20) {
//                        Spacer()
//                        FeatureCard(title: "Plan Your Meals", icon: "calendar")
//                        FeatureCard(title: "Discover Recipes", icon: "book")
//                        FeatureCard(title: "Track Groceries", icon: "cart")
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    Spacer()
//                    // Navigation Links
//                    VStack() {
//                        HStack{
//                            Spacer()
//                            NavigationLink(destination: CreateRecipeView()) {
//                                Text("Create a New Recipe")
//                                    .fontWeight(.bold)
//                                    .padding()
//                                    .frame(width: 250)
//                                    .background(Color.green)
//                                    .cornerRadius(10)
//                                    .foregroundColor(.white)
//                            }
//                            Spacer()
//                        }
//                        //Spacer()
//                        HStack{
//                            Spacer()
//                            NavigationLink(destination: MealPlannerView()) {
//                                Text("Plan Your Meals")
//                                    .fontWeight(.bold)
//                                    .padding()
//                                    .frame(width: 250)
//                                    .background(Color.green)
//                                    .cornerRadius(10)
//                                    .foregroundColor(.white)
//                            }
//                            Spacer()
//
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    Spacer()
//
//                    // Planned Meals Section
//                    ScrollView{
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text("     Your Planned Meals")
//                                .font(.headline)
//                                .fontWeight(.bold)
//                                .padding(.horizontal)
//
//                            if plans.isEmpty {
//                                Text("No meal plans found. Start planning your meals!")
//                                    .foregroundColor(.gray)
//                                    .padding(.horizontal)
//                            } else {
//                                HStack{
//                                    Spacer()
//                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
//                                        ForEach(plans, id: \.self) { plan in
//                                            NavigationLink(destination: PlanDetailsView(plan: plan)) {
//                                                VStack(alignment: .leading) {
//                                                    Text(plan.name ?? "Unnamed Plan")
//                                                        .font(.headline)
//                                                        .padding(.vertical, 5)
//                                                        //.forgroundColor(.primary)
//                                                        .foregroundColor(plan == mostRecentPlan ? .primary : .primary)
//                                                    Text("Created: \(formattedDate(plan.createdDate))")
//                                                        .font(.footnote)
//                                                        .foregroundColor(.gray)
//                                                }
//                                                .padding()
//                                                .background(plan == mostRecentPlan ? Color.green.opacity(0.3) : Color(UIColor.systemGray6))
//                                                .cornerRadius(10)
//                                                .shadow(radius: 5)
//                                            }
//                                            .contextMenu {
//                                                Button(role: .destructive) {
//                                                    deletePlan(plan)
//                                                } label: {
//                                                    Label("Delete Plan", systemImage: "trash")
//                                                }
//                                            }
//                                        }
//                                    }
//                                    .padding(.horizontal)
//                                    Spacer()
//                                }
//                            }
//                        }
//                    }
//                    Spacer()
//                }
//                .onAppear(perform: fetchPlans)
//        }
//    }
//
//    // Fetch saved plans from CoreData
//    private func fetchPlans() {
//        plans = PlanManager.shared.fetchAllPlans()
//        mostRecentPlan = plans.first // Assuming the fetch returns sorted by date
//    }
//
//    // Delete a plan
//    private func deletePlan(_ plan: Plan) {
//        PlanManager.shared.deletePlan(plan)
//        fetchPlans() // Refresh the plans after deletion
//    }
//
//    // Format the date as a string
//    private func formattedDate(_ date: Date?) -> String {
//        guard let date = date else { return "Unknown Date" }
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//}
//
//struct FeatureCard: View {
//    var title: String
//    var icon: String
//
//    var body: some View {
//        VStack {
//            Image(systemName: icon)
//                .font(.largeTitle)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//            Text(title)
//                .font(.subheadline)
//                .multilineTextAlignment(.center)
//        }
//        .frame(width: 100, height: 120)
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.shared.container.viewContext
//
//        // Create mock data for preview
//        let mockPlan1 = Plan(context: context)
//        mockPlan1.name = "Weekly Plan"
//        mockPlan1.createdDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())
//
//        let mockPlan2 = Plan(context: context)
//        mockPlan2.name = "Holiday Plan"
//        mockPlan2.createdDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
//
//        let mockDay1 = Day(context: context)
//        mockDay1.date = Calendar.current.date(byAdding: .day, value: -2, to: Date())
//        mockDay1.plan = mockPlan1
//
//        let mockMeal1 = Meal(context: context)
//        mockMeal1.name = "Breakfast"
//        mockMeal1.day = mockDay1
//
//        let mockRecipe1 = PersonalRecipe(context: context)
//        mockRecipe1.name = "Pancakes"
//        mockMeal1.addToRecipes(mockRecipe1)
//
//        let mockMeal2 = Meal(context: context)
//        mockMeal2.name = "Lunch"
//        mockMeal2.day = mockDay1
//
//        let mockRecipe2 = PersonalRecipe(context: context)
//        mockRecipe2.name = "Grilled Chicken Salad"
//        mockMeal2.addToRecipes(mockRecipe2)
//
//        let mockDay2 = Day(context: context)
//        mockDay2.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        mockDay2.plan = mockPlan1
//
//        let mockMeal3 = Meal(context: context)
//        mockMeal3.name = "Dinner"
//        mockMeal3.day = mockDay2
//
//        let mockRecipe3 = PersonalRecipe(context: context)
//        mockRecipe3.name = "Spaghetti Bolognese"
//        mockMeal3.addToRecipes(mockRecipe3)
//
//        // Inject mock data
//        return HomeView()
//            .environment(\.managedObjectContext, context)
//    }
//}
//
//
//
//

import SwiftUI

struct HomeView: View {
    @State private var plans: [Plan] = [] // All saved plans
    @State private var mostRecentPlan: Plan? // The most recent plan

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                HStack {
                    Spacer()
                    Text("     Plan smarter, eat better!")
                        .font(.title)
                        .foregroundColor(.black.opacity(0.8))
                        .shadow(radius: 5)
                    Spacer()
                }

                HStack(spacing: 20) {
                    Spacer()
                    FeatureCard(title: "Plan Your Meals", icon: "calendar")
                    FeatureCard(title: "Discover Recipes", icon: "book")
                    FeatureCard(title: "Track Groceries", icon: "cart")
                    Spacer()
                }
                .padding(.horizontal)
                Spacer()

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
                            Text("No meal plans found. Start planning your meals!")
                                .foregroundColor(.gray)
                                .padding(.horizontal)
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
            .onAppear(perform: fetchPlans)
        }
    }

    // Fetch saved plans from CoreData
    private func fetchPlans() {
        plans = PlanManager.shared.fetchAllPlans()
        mostRecentPlan = plans.first // Assuming the fetch returns sorted by date
    }

    // Delete a plan
    private func deletePlan(_ plan: Plan) {
        PlanManager.shared.deletePlan(plan)
        fetchPlans() // Refresh the plans after deletion
    }

    // Format the date as a string
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
