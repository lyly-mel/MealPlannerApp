import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var mealPlans: [String: [String]] = [
        "2024-12-14": ["Pancakes", "Grilled Chicken Salad", "Soup", "Bread", "Rice", "Pizza", "Salad", "Dessert","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A"],
        "2024-12-15": ["Spaghetti Bolognese"]
    ]
    @State private var showingMealsForToday: Bool = true

    var body: some View {
        VStack {
            Text(showingMealsForToday ? "Meals for Today: \(formattedDate(Date()))" : "Meals for: \(formattedDate(selectedDate))")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            // Meals for Selected Day
            if let meals = mealPlans[formattedDate(selectedDate)], !meals.isEmpty {
                DisclosureGroup("Planned Meals (\(meals.count))") {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(meals, id: \.self) { meal in
                                Text(meal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 5)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .frame(maxHeight: 150)
                }
                //.padding()
                //.background(Color(UIColor.systemGray5))
                .cornerRadius(6)
                .padding(.horizontal)
            } else {
                Text("No meals planned.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            // Calendar View (Static Height)
            FSCalendarWrapper(
                selectedDate: $selectedDate,
                mealPlans: mealPlans,
                onDateSelected: { date in
                    selectedDate = date
                    showingMealsForToday = isSameDay(date1: date, date2: Date())
                }
            )
            .frame(height: 350)
            .padding()
        }
        .navigationTitle("Meal Planner")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // Utility to check if two dates are the same
        private func isSameDay(date1: Date, date2: Date) -> Bool {
            let calendar = Calendar.current
            return calendar.isDate(date1, inSameDayAs: date2)
        }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

