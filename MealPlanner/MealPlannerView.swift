import SwiftUI
import FSCalendar

struct MealPlannerView: View {
    // Current date
    @State private var selectedDate = Date() // Default to today
    @State private var mealPlans: [String: [String]] = [
        "2024-12-14": ["Pancakes", "Grilled Chicken Salad"],
        "2024-12-15": ["Spaghetti Bolognese"]
    ] // Example meal plans keyed by date (YYYY-MM-DD)
    
    var body: some View {
        NavigationView {
            VStack {
                // Meals for Today / Selected Date
                VStack(alignment: .leading, spacing: 10) {
                    Text("Meals for today: \(formattedDate(selectedDate))")
                        .font(.headline)
                    
                    if let meals = mealPlans[dateKey(selectedDate)], !meals.isEmpty {
                        List {
                            ForEach(meals, id: \.self) { meal in
                                HStack {
                                    Text(meal)
                                    Spacer()
                                    Menu {
                                        Button("Edit Meal") {
                                            editMeal(meal: meal, date: selectedDate)
                                        }
                                        Button("Delete Meal", role: .destructive) {
                                            deleteMeal(meal: meal, date: selectedDate)
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .rotationEffect(.degrees(90))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .frame(height: 200) // Adjust as needed
                    } else {
                        Text("No meals planned for \(formattedDate(selectedDate)).")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Calendar Picker
                VStack {
                    Text("Pick a day to view or plan meals:")
                        .font(.headline)
                    
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(.blue) // Highlight the selected date
                    .onChange(of: selectedDate) { _ in
                        // Optionally perform an action when the date changes
                        print("Selected date: \(formattedDate(selectedDate))")
                    }
                }
                .padding()
                
                Spacer()

                // Add Meal Button
                Button(action: {
                    addMeal(for: selectedDate)
                }) {
                    Text("Add Meal")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding()
            }
            .navigationTitle("Meal Planner")
        }
    }
    
    // MARK: - Helper Functions
    
    /// Converts a Date to a user-friendly string
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // Example: "Saturday, December 14, 2024"
        return formatter.string(from: date)
    }
    
    /// Converts a Date to a string key (YYYY-MM-DD)
    private func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Actions
    
    private func addMeal(for date: Date) {
        // Example logic to add a meal
        let dateKey = dateKey(date)
        if mealPlans[dateKey] == nil {
            mealPlans[dateKey] = []
        }
        mealPlans[dateKey]?.append("New Meal \(mealPlans[dateKey]?.count ?? 1 + 1)")
        print("Added meal for \(formattedDate(date))")
    }

    private func editMeal(meal: String, date: Date) {
        // Implement edit functionality here
        print("Editing meal '\(meal)' on \(formattedDate(date))")
    }

    private func deleteMeal(meal: String, date: Date) {
        let dateKey = dateKey(date)
        if let index = mealPlans[dateKey]?.firstIndex(of: meal) {
            mealPlans[dateKey]?.remove(at: index)
        }
        print("Deleted meal '\(meal)' on \(formattedDate(date))")
    }
}

// MARK: - Preview

struct MealPlannerView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlannerView()
    }
}



//import SwiftUI
//
//struct MealPlannerView: View {
//    @State private var selectedDate = Date() // Default to today
//    @State private var mealPlans: [String: [String]] = [
//        "2024-12-14": ["Pancakes", "Grilled Chicken Salad"],
//        "2024-12-15": ["Spaghetti Bolognese"],
//        "2024-12-16": ["Spaghetti Bolognese"]
//    ] // Example meal plans keyed by date (YYYY-MM-DD)
//
//    private var daysInCurrentMonth: [Date] {
//        let calendar = Calendar.current
//        guard let range = calendar.range(of: .day, in: .month, for: selectedDate) else { return [] }
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
//        return range.compactMap { day -> Date? in
//            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Display Meals for Today
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Meals for \(formattedDate(selectedDate))")
//                        .font(.headline)
//                    
//                    if let meals = mealPlans[dateKey(selectedDate)], !meals.isEmpty {
//                        List {
//                            ForEach(meals, id: \.self) { meal in
//                                HStack {
//                                    Text(meal)
//                                    Spacer()
//                                    Menu {
//                                        Button("Edit Meal") {
//                                            editMeal(meal: meal, date: selectedDate)
//                                        }
//                                        Button("Delete Meal", role: .destructive) {
//                                            deleteMeal(meal: meal, date: selectedDate)
//                                        }
//                                    } label: {
//                                        Image(systemName: "ellipsis")
//                                            .rotationEffect(.degrees(90))
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                            }
//                        }
//                        .frame(height: 200)
//                    } else {
//                        Text("No meals planned for \(formattedDate(selectedDate)).")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding()
//                
//                // Custom Calendar View
//                Text("Pick a day to view or plan meals:")
//                    .font(.headline)
//                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
//                    ForEach(daysInCurrentMonth, id: \.self) { date in
//                        Button(action: {
//                            selectedDate = date
//                        }) {
//                            Text("\(Calendar.current.component(.day, from: date))")
//                                .frame(width: 40, height: 40)
//                                .background(
//                                    mealPlans.keys.contains(dateKey(date))
//                                        ? Color.green.opacity(0.7) // Highlight planned days
//                                        : Color.gray.opacity(0.2)
//                                )
//                                .foregroundColor(.black)
//                                .cornerRadius(8)
//                        }
//                    }
//                }
//                .padding()
//                
//                Spacer()
//
//                // Add Meal Button
//                Button(action: {
//                    addMeal(for: selectedDate)
//                }) {
//                    Text("Add Meal")
//                        .fontWeight(.bold)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.green)
//                        .cornerRadius(10)
//                        .foregroundColor(.white)
//                }
//                .padding()
//            }
//            .navigationTitle("Meal Planner")
//        }
//    }
//    
//    // MARK: - Helper Functions
//    
//    /// Converts a Date to a user-friendly string
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long // Example: "Saturday, December 14, 2024"
//        return formatter.string(from: date)
//    }
//    
//    /// Converts a Date to a string key (YYYY-MM-DD)
//    private func dateKey(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: date)
//    }
//    
//    // MARK: - Actions
//    
//    private func addMeal(for date: Date) {
//        let dateKey = dateKey(date)
//        if mealPlans[dateKey] == nil {
//            mealPlans[dateKey] = []
//        }
//        mealPlans[dateKey]?.append("New Meal")
//        print("Added meal for \(formattedDate(date))")
//    }
//
//    private func editMeal(meal: String, date: Date) {
//        print("Editing meal '\(meal)' on \(formattedDate(date))")
//    }
//
//    private func deleteMeal(meal: String, date: Date) {
//        let dateKey = dateKey(date)
//        if let index = mealPlans[dateKey]?.firstIndex(of: meal) {
//            mealPlans[dateKey]?.remove(at: index)
//        }
//        print("Deleted meal '\(meal)' on \(formattedDate(date))")
//    }
//}
//
//// MARK: - Preview
//
//struct MealPlannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealPlannerView()
//    }
//}
