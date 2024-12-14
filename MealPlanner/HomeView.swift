
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Plan smarter, eat better!")
                            .font(.title)
                            .foregroundColor(.black.opacity(0.8))
                            .shadow(radius: 5)
                        Spacer()
                    }
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Spacer()
                        FeatureCard(title: "Plan Your Meals", icon: "calendar")
                        FeatureCard(title: "Discover Recipes", icon: "book")
                        FeatureCard(title: "Track Groceries", icon: "cart")
                        Spacer()
                    }
                    .padding(.horizontal)
                    Spacer()
                    VStack{
                        HStack() {
                            Spacer()
                            
                            NavigationLink(destination: CreateRecipeView()) {
                                Text("Create a new recipe")
                                    .fontWeight(.bold)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        Spacer()
                        Spacer()
                        
                        HStack() {
                            Spacer()
                            NavigationLink(destination: MealPlannerView()) {
                                Text("Plan your meals")
                                    .fontWeight(.bold)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            
                        }
                    }
                    
                }
            }
            .navigationTitle("Meal Planner")
        }
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

struct RecipeCard: View {
    var recipeName: String
    var calories: Int
    
    var body: some View {
        HStack {
            Image("recipe_image")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(recipeName)
                    .font(.headline)
                Text("\(calories) calories")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {}) {
                Text("Cook Now")
                    .padding(10)
                    .background(Color.green)
                    .cornerRadius(5)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
