# Demo App - Authentication Flow

## Overview
This demo showcases the authentication flow of the app, explaining how users log in and how their profile information is managed. Below, you'll find a step-by-step guide along with screenshots and videos demonstrating the functionality.

## Features
- **Phone Number Authentication** (Firebase Authentication)
- **Firestore Integration** (User data storage)
- **Personalized Home Screen** (Fetches and displays user details)
- **First-Time User Prompt** (Requests user name if not available)

## Flow Diagram
```mermaid
graph TD;
    A[User Opens App] -->|Logged In| B[Home Screen];
    A -->|Not Logged In| C[Login Screen];
    B --> D[Fetch User Name from Firestore];
    C -->|User Enters Phone Number| E[Authenticate via OTP];
    E -->|Success| F[First-Time Login Check];
    F -->|First-Time| G[Show Dialog to Enter Name];
    F -->|Returning User| H[Proceed to Home Screen];
    G -->|User Saves Name| I[Store in Firestore and Go to Home Screen];
```

## App Flow
### 1. **Launching the App**
- If the user is **already logged in**, they are redirected to the **Home Screen**.
- If not, they are taken to the **Login Screen**.

**Screenshot:**
![App Launch](screenshots/app_launch.png)

### 2. **Login Screen**
- The user enters their **phone number**.
- OTP authentication via Firebase is triggered.

**Screenshot:**
![Login Screen](screenshots/login_screen.png)

### 3. **Home Screen** (Returning Users)
- The user's **name is fetched from Firestore** (`Users/uid/`) and displayed on the home screen.

**Screenshot:**
![Home Screen](screenshots/home_screen.png)

### 4. **First-Time Users**
- If the user logs in for the **first time**, a **dialog box** appears prompting them to enter their name.
- The entered name is **saved to Firestore**, and the user is redirected to the Home Screen.

**Screenshot:**
![User Name Dialog](screenshots/user_name_dialog.png)

### 5. **Authentication Video Demo**
📽️ [Watch Demo Video](videos/auth_demo.mp4)

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/demo-auth-app.git
   ```
2. Navigate to the project folder:
   ```bash
   cd demo-auth-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Technologies Used
- **Flutter** (Framework)
- **Firebase Authentication** (Phone number login)
- **Firestore** (User data storage)
- **GetX** (State management)

## Conclusion
This demo highlights the authentication process, ensuring a smooth user experience with Firebase authentication and Firestore integration. If you have any questions or need modifications, feel free to reach out!

---
📌 **Repository:** [GitHub Repo](https://github.com/your-repo/demo-auth-app)

