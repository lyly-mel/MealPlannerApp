🍽️ Meal Planner App

Description
Meal Planner is a SwiftUI-based iOS application that allows users to plan meals, manage grocery lists, and organize recipes efficiently. The app includes features for planning meals for multiple days, creating meal plans, and automatically generating a grocery list based on planned recipes. It uses Core Data to persistently store user data like recipes, plans, and ingredients.

🚀 Key Features

1- Create and Manage Recipes
  - Add recipes with ingredients, quantities, and preparation steps.
  - View a list of all available recipes.
2- Plan Meals for Multiple Days
  - Select recipes and assign them to specific days.
  - Save meal plans and view them later.

3- Automatic Grocery List Generation
  - Ingredients from planned meals are automatically added to a grocery list.
  - Manage the grocery list with functionalities to mark items as done, increase/decrease quantities, or delete them. (will fix potential bugs in future updates)
4- Interactive Calendar View
  - View and manage meals for a specific day by interacting with the calendar.
5- Persistent Storage
All data, including recipes, meal plans, and days are stored using Core Data for seamless persistence.

🛠️ Technologies Used

SwiftUI: Modern user interface framework for building the app.
Core Data: Persistent storage for recipes, meal plans, and grocery lists.
FSCalendar: Calendar integration to visually represent planned days.
Xcode: Developed and tested using Xcode.
Swift: Primary programming language.

📂 App Structure

The app follows a modular structure with key components:

Views: 
  HomeView.swift: Main screen with navigation to all features.
  MealPlannerView.swift: Allows users to plan meals for specific days.
  GroceriesView.swift: Displays the automatically generated grocery list.
  RecipeView.swift: Displays recipe details with ingredients and preparation steps.
  CustomCalendarView.swift: Calendar integration for planning meals.
Models: 
  Plan, Day, Meal, PersonalRecipe, and Ingredient.
Managers: 
  RecipeManager.swift: Handles CRUD operations for recipes.
  PlanManager.swift: Manages plans, days, and meals.
  
📥 How to Run the App

Clone the Repository.
Open it in Xcode
Open the .xcodeproj or .xcworkspace file.
Install Dependencies (if using Swift Package Manager):
Ensure FSCalendar is properly installed.
Run the App:
Select an iOS simulator or a physical device and press CMD + R.

📝 Future Improvements

  - Highlight days with planned meals.
  - Add search functionality for recipes and plans.
  - Allow customization of grocery categories.
  - Add reminders for planned meals.
  - integrate API to allow users to serach for specific recipes , and save them
  - improve the functionality of grocerie, and save it to CoreData to improve user experience
  - upload images for recipes
  - improve the UI of the application
  
🧑‍💻 Developer

Lyly Mel

