//
//  CustomCalendarView.swift
//  MealPlanner
//
//  Created by lylia melahi on 12/15/24.
//

import SwiftUI
import FSCalendar

struct CustomCalendar: View {
    @Binding var selectedDate: Date
    @State private var mealPlans: [String: [String]] = [:] // Meal plans fetched from Core Data
    var onDateSelected: ((Date) -> Void)? 

    var body: some View {
        VStack {
            FSCalendarWrapper(
                selectedDate: $selectedDate,
                mealPlans: mealPlans,
                onDateSelected: { date in
                    selectedDate = date
                    onDateSelected?(date) // Trigger the callback if provided
                }
            )
            .frame(height: 350)
            .padding()
        }
        .onAppear(perform: fetchMealPlans)
    }

    // Fetch meal plans from Core Data
    private func fetchMealPlans() {
        var tempMealPlans: [String: [String]] = [:]
        let plans = PlanManager.shared.fetchAllPlans()

        for plan in plans {
            let days = PlanManager.shared.fetchDays(for: plan)

            for day in days {
                let meals = PlanManager.shared.fetchMeals(for: day)
                let formattedDate = formatDate(day.date ?? Date())

                if !meals.isEmpty {
                    tempMealPlans[formattedDate] = meals.flatMap { meal in
                        (meal.recipes as? Set<PersonalRecipe>)?.compactMap { $0.name } ?? []
                    }
                }
            }
        }
        mealPlans = tempMealPlans
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// FSCalendarWrapper for integrating FSCalendar with SwiftUI
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
        calendar.appearance.eventDefaultColor = .systemGreen // Event color for planned meals
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData() // Refresh the calendar
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate, mealPlans: mealPlans, onDateSelected: onDateSelected)
    }

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
            return mealPlans[formattedDate]?.isEmpty == false ? 1 : 0
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            let formattedDate = formatDate(date)
            return mealPlans[formattedDate]?.isEmpty == false ? [.systemGreen] : nil
        }

        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    }
}







