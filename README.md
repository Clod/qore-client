# Qore Client Application

This is a Flutter application designed to manage patient data, including their medical history, diagnoses, and associated genetic syndromes. It provides a user-friendly interface for healthcare professionals to access and update patient information.

## Functionality

The application provides the following key features:

*   **Patient Management:** Add, edit, and view patient records.
*   **Diagnosis Tracking:** Record and manage patient diagnoses, including associated genetic syndromes.
*   **User Authentication:** Secure login and password recovery functionality.
*   **Data Persistence:** Utilizes Firebase for data storage and synchronization.
*   **Responsive Design:** Adapts to different screen sizes and devices.

## Architecture

The application follows a layered architecture:

*   **UI Layer:** Built using Flutter widgets, providing a responsive and intuitive user interface.
*   **Model Layer:** Defines the data structures for patients, diagnoses, and genetic syndromes.
*   **Data Access Layer:** Implements data access logic using REST and WebSocket APIs.
*   **Utility Layer:** Provides helper functions and services for authentication and data handling.
*   **Routing Layer:** Manages navigation between different screens using a custom router.

## How it Works

The application uses the following technologies and libraries:

*   **Flutter:** For building the user interface and cross-platform compatibility.
*   **Firebase:** For user authentication, data storage, and real-time synchronization.
*   **Provider:** For state management and data sharing between widgets.
*   **Form Builder Validators:** For form validation and error handling.
*   **Flutter DotEnv:** For loading environment variables from a `.env` file.
*   **AutoRoute:** For navigation and routing.

The application's main entry point is `lib/main.dart`, which initializes Firebase, loads environment variables, and sets up the application's root widget. The `lib/routes/app_router.dart` file defines the application's routing logic, including route guards for authentication. The `lib/util/auth_service.dart` file handles user authentication and authorization. The `lib/model` directory contains the data models for patients, diagnoses, and genetic syndromes. The `lib/screens` directory contains the UI components for different screens.

## How to Run

To run the application, follow these steps:

1.  **Install Flutter:** Make sure you have Flutter installed on your machine. You can find instructions on how to install Flutter on the official Flutter website: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2.  **Clone the Repository:** Clone the repository to your local machine.
3.  **Install Dependencies:** Navigate to the project directory and run `flutter pub get` to install the required dependencies.
4.  **Configure Firebase:** Create a Firebase project and configure the application with your Firebase credentials. You will need to download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files and place them in the appropriate directories. You will also need to configure the `firebase_options.dart` file with your Firebase project's configuration.
5.  **Set Environment Variables:** Create a `.env` file in the root directory of the project and add the required environment variables, such as the Firebase API key and the server IP address.
6.  **Run the Application:** Run the application using `flutter run`.

## Additional Notes

*   The application uses a `.env` file to store environment variables. Make sure to create this file and add the required variables before running the application.
*   The application uses Firebase for data storage and synchronization. Make sure to configure Firebase correctly before running the application.
*   The application uses a custom router for navigation. Make sure to understand the routing logic before making changes to the application's navigation.
*   The application uses a layered architecture. Make sure to understand the different layers before making changes to the application's code.

This README provides a comprehensive overview of the application's functionality, architecture, and how to run it. If you have any questions, please refer to the project's documentation or contact the development team.
