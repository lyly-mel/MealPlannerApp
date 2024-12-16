import SwiftUI
import CoreData

struct MealPlannerView: View {
    @State private var recipes: [PersonalRecipe] = [] // All recipes fetched from Core Data
    @State private var selectedRecipesForDay: [Date: [PersonalRecipe]] = [:] // Recipes planned per day
    @State private var selectedDate: Date = Date() // Currently selected date
    @State private var selectedRecipes: [PersonalRecipe] = [] // Temporary selected recipes for the current day
    @State private var isCalendarPresented: Bool = false // Show/hide calendar modal
    @State private var mealPlans: [String: [String]] = [:] // Mock meal plans data
    @State private var savedDays: [Date] = [] // Dates with saved plans
    @State private var planName: String = "" // Name for the meal plan
    @State private var showPlanCreationAlert = false // Show alert to create plan

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Calendar Section
                HStack {
                    Spacer()
                    HStack{
                        Text("Plan meals for: ")
                            .font(.headline)
                            //.padding(.horizontal)
                        Text("\(formattedDate(selectedDate))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            //.padding(.horizontal)
                    }
                    Spacer()
                    Button(action: {
                        isCalendarPresented = true
                    }) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    .sheet(isPresented: $isCalendarPresented) {
                        CustomCalendar(
                            selectedDate: $selectedDate,
                            mealPlans: mealPlans,
                            onDateSelected: { date in
                                isCalendarPresented = false
                                selectedRecipes = selectedRecipesForDay[date] ?? [] // Restore previous selection
                            }
                        )
                    }
                    Spacer()
                }

                // Recipes Section
                Text("Available Recipes")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(recipes, id: \.self) { recipe in
                            MealRecipeCard(
                                recipe: recipe,
                                isSelected: selectedRecipes.contains(recipe)
                            ) {
                                toggleRecipeSelection(recipe)
                            }
                        }
                    }
                    .padding()
                }
                .frame(height: 200)

                // Saved Days Section
                if !savedDays.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Planned Days")
                            .font(.headline)
                            .padding(.horizontal)

                        List {
                            ForEach(savedDays, id: \.self) { date in
                                DisclosureGroup("\(formattedDate(date))") {
                                    if let recipesForDay = selectedRecipesForDay[date] {
                                        ForEach(recipesForDay, id: \.self) { recipe in
                                            Text(recipe.name ?? "Unnamed Recipe")
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deletePlannedDay)
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding(.horizontal)
                }
                else{
                    HStack{
                        Spacer()
                        Text("Start planning your meals")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        .padding(.top)
                        Spacer()
                    }
                }

                Spacer()

                // Save Day Plan Button
                Button(action: saveDayPlan) {
                    Text("Save Day Plan")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                // Create Plan Button
                Button(action: {
                    showPlanCreationAlert = true
                }) {
                    Text("Create Meal Plan")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .alert("Create Meal Plan", isPresented: $showPlanCreationAlert, actions: {
                    TextField("Plan Name", text: $planName)
                    Button("Save", action: createMealPlan)
                    Button("Cancel", role: .cancel) { }
                }, message: {
                    Text("Enter a name for your meal plan.")
                })
            }
            .onAppear(perform: fetchRecipes) // Fetch recipes when the view appears
        }
    }

    // MARK: - CoreData Integration with PlanManager

    private func fetchRecipes() {
        recipes = RecipeManager.shared.fetchAllRecipes()
    }

    private func toggleRecipeSelection(_ recipe: PersonalRecipe) {
        if selectedRecipes.contains(recipe) {
            selectedRecipes.removeAll { $0 == recipe }
        } else {
            selectedRecipes.append(recipe)
        }
    }

    private func saveDayPlan() {
        guard !selectedRecipes.isEmpty else { return }

        // Save the selected recipes for the selected date
        selectedRecipesForDay[selectedDate] = selectedRecipes

        if !savedDays.contains(selectedDate) {
            savedDays.append(selectedDate)
        }

        // Clear current selection for the day
        selectedRecipes.removeAll()
    }

    private func deletePlannedDay(at offsets: IndexSet) {
        for index in offsets {
            let dayToDelete = savedDays[index]
            selectedRecipesForDay.removeValue(forKey: dayToDelete)
            savedDays.remove(at: index)
        }
    }

    private func createMealPlan() {
        guard !planName.isEmpty, !savedDays.isEmpty else { return }

        // Create a new plan using PlanManager
        let newPlan = PlanManager.shared.createPlan(name: planName, createdDate: Date())

        // Add days and meals to the plan
        for day in savedDays {
            let newDay = PlanManager.shared.createDay(for: newPlan, date: day)

            if let recipesForDay = selectedRecipesForDay[day] {
                PlanManager.shared.createMeal(for: newDay, name: "Main Meal", recipes: recipesForDay)
            }
        }

        // Reset the UI
        selectedRecipesForDay.removeAll()
        savedDays.removeAll()
        planName = ""
        print("Meal plan '\(newPlan.name ?? "Unnamed Plan")' created successfully!")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct MealRecipeCard: View {
    let recipe: PersonalRecipe
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(destination: RecipeView(recipe: recipe)) {
                VStack {
                    Image(systemName: "photo") // Default image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .padding(.top, 10)

                    Text(recipe.name ?? "Unnamed Recipe")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 10)
                }
                .frame(width: 150, height: 150)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .buttonStyle(PlainButtonStyle())

            // Add/Remove Button
            Button(action: onToggle) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle.fill")
                    .foregroundColor(isSelected ? .green : .blue)
                    .font(.title)
                    .padding(5)
            }
        }
    }
}

struct MealPlannerView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext

        // Add mock recipes for preview
        let mockRecipe1 = PersonalRecipe(context: context)
        mockRecipe1.name = "Mock Recipe 1"

        let mockRecipe2 = PersonalRecipe(context: context)
        mockRecipe2.name = "Mock Recipe 2"

        return MealPlannerView()
            .environment(\.managedObjectContext, context)
    }
}

