import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Meal Plan Tab
            HomeView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Meal Plan")
                }
                .tag(0)
            
            // Calendar Tab
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planner")
                }
                .tag(2)
            
            // Groceries Tab
            GroceriesView()
                //.badge(1)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Groceries")
                }
                .tag(1)
            
            // Recipes Tab
            RecipesListView()
                .tabItem {
                    Image(systemName: "frying.pan")
                    Text("My Recipes")
                }
                .tag(3)
            
            //TODO: implement sittings
//            SettingsView()
//                .tabItem {
//                    Image(systemName: "gearshape.fill")
//                    Text("Setting")
//                }
//                .tag(4)
        }
        .accentColor(.green)
        .navigationBarBackButtonHidden(true)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}


