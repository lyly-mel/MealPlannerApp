import SwiftUI
import FSCalendar

struct CalendarView: View {
    @State private var selectedDate: Date = Date() // Selected day, default to today
    @State private var mealPlans: [String: [String]] = [
        "2024-12-14": ["Pancakes", "Grilled Chicken Salad", "Soup", "Bread", "Rice", "Pizza", "Salad", "Dessert","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A"],
        "2024-12-15": ["Spaghetti Bolognese"]
    ]
    @State private var showingMealsForToday: Bool = true // Flag to toggle title text

    var body: some View {
        VStack {
            // Top Text
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

    // Utility to format a date as "yyyy-MM-dd"
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

// FSCalendarWrapper to integrate FSCalendar with SwiftUI
struct FSCalendarWrapper: UIViewRepresentable {
    @Binding var selectedDate: Date
    var mealPlans: [String: [String]]
    var onDateSelected: (Date) -> Void

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 16)
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14)
        calendar.appearance.selectionColor = .systemBlue
        calendar.appearance.todayColor = .systemOrange
        calendar.appearance.eventDefaultColor = .systemGreen // Color for events
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData() // Refresh the calendar
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedDate: $selectedDate, mealPlans: mealPlans, onDateSelected: onDateSelected)
    }

    // Coordinator to handle FSCalendar delegate methods
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        @Binding var selectedDate: Date
        var mealPlans: [String: [String]]
        var onDateSelected: (Date) -> Void

        init(selectedDate: Binding<Date>, mealPlans: [String: [String]], onDateSelected: @escaping (Date) -> Void) {
            _selectedDate = selectedDate
            self.mealPlans = mealPlans
            self.onDateSelected = onDateSelected
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            selectedDate = date
            onDateSelected(date)
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let formattedDate = formatDate(date)
            return mealPlans[formattedDate] != nil ? 1 : 0
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            let formattedDate = formatDate(date)
            return mealPlans[formattedDate] != nil ? [.systemGreen] : nil
        }

        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

