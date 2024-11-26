
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    
                   
                    Text("MealPlanner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.bottom, 10)

                    Text("Plan your week, save your time!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .opacity(0.8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 30)

                    Spacer()
                    
                  
                    NavigationLink(destination: MainPlannerView()) {
                        Text("Get Started")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                Color.green
                            )
                            .cornerRadius(12)
                            .shadow(color: .green, radius: 5, x: 0, y: 4)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 20)
                    }
                    
                    Spacer()
                    
                    
                    Text("• Plan meals for the week\n• Generate shopping lists\n• Save your favorite recipes")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .padding(.bottom, 30)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true) 
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
