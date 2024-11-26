import SwiftUI

struct MealCalendarView: View {
    var body: some View {
        VStack {
            Text("Meal Calendar")
                .font(.largeTitle)
                .padding()
            
            Text("Here you'll see your meals for the week.")
                .padding()
        }
    }
}

struct MealCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MealCalendarView()
    }
}

