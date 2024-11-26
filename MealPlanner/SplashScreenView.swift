import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var logoSize = 0.8
    @State private var logoOpacity = 0.5
    @State private var textOpacity = 0.0 // Initially hide the text
    
    var body: some View {
        if isActive {
            // Move to ContentView after the splash screen
            ContentView()
        } else {
            VStack {
                VStack {
                    // Logo that will appear first
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .opacity(logoOpacity)
                        .scaleEffect(logoSize)
                    
                    // Text that will appear after the logo
                    Text("Welcome to MealPlanner!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .opacity(textOpacity)
                        .padding(.top, 20)
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.logoSize = 1.0
                        self.logoOpacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeIn(duration: 1.0)) {
                            self.textOpacity = 1.0
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

