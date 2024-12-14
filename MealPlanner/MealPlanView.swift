import SwiftUI

struct MealPlanView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Hero Section
                    ZStack {
                        Image("")
                            .resizable()
                                .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            
                        VStack {
//                            Text("Your Personalized Meal Planner")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(.black)
                            Spacer()
                            Text("Plan smarter, eat better!")
                                .font(.title)
                                .foregroundColor(.black.opacity(0.8))
                                .shadow(radius: 5)

                        }
                    }
                    Spacer()
                    
                    
                    // Quick Access Features
                    Text("What You Can Do")
                        .font(.headline)
                        .padding(.horizontal)
                    HStack(spacing: 20) {
                        FeatureCard(title: "Plan Your Meals", icon: "calendar")
                        FeatureCard(title: "Discover Recipes", icon: "book")
                        FeatureCard(title: "Track Groceries", icon: "cart")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        //Button(action: {}) {
                        NavigationLink(destination: CreateRecipeView()) {
                            Text("Start Planning Now")
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }

//                        Button(action: {}) {
//                            Text("Explore Recipes")
//                                .fontWeight(.bold)
//                                .padding()
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                                .foregroundColor(.white)
//                        }
                        Spacer()
                    }

                    
                     //Featured Recipe
//                    VStack(alignment: .leading) {
//                        Text("Featured Recipe of the Day")
//                            .font(.headline)
//                            .padding(.horizontal)
//                        RecipeCard(recipeName: "Avocado Salad", calories: 350)
//                    }
                    
                     //How It Works
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("How It Works")
//                            .font(.headline)
//                            .padding(.horizontal)
//                        ForEach(1...3, id: \.self) { step in
//                            Text("Step \(step): Description of the step.")
//                                .padding(.horizontal)
//                                .font(.subheadline)
//                        }
//                    }
                }
            }
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

struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView()
    }
}
