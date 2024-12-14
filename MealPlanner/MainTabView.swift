import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Meal Plan Tab
            MealPlanView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Meal Plan")
                }
                .tag(0)
            
            // Groceries Tab
            GroceriesView()
                .badge(1)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Groceries")
                }
                .tag(1)
            
            // Calendar Tab
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(2)
            
            // Favorite Tab
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }
                .tag(3)
            
            // Setting Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Setting")
                }
                .tag(4)
        }
        .accentColor(.green)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}


