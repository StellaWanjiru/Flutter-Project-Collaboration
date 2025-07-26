**Vroom: Car Hire Application

**Vroom is a modern Flutter application designed to connect users looking to hire cars with car owners (listers). It provides a seamless experience for browsing available vehicles, viewing detailed car information, and directly contacting car listers. Car owners can also easily list their vehicles through a dedicated form.

**Features**

User Authentication: Secure user registration and login using Firebase Authentication.

Dynamic Car Listings: Browse a real-time list of available cars with essential details.

Car Details View: Tap on any car to see more comprehensive information.

Direct Lister Contact: Users can directly call or email car listers from the car details page.

Add New Car: Car owners can easily list their vehicles by filling out a form, including image upload to Firebase Storage.

Responsive UI: Designed with Flutter's adaptive widgets for a consistent experience across devices.

Firebase Integration: Leverages Firestore for data storage and Firebase Storage for image assets.

**Technologies Used
**Flutter: UI Toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

Dart: The programming language used by Flutter.

Firebase Authentication: For user registration and login.

Cloud Firestore: NoSQL cloud database for storing car and user data.

Firebase Storage: Cloud storage for uploading car images.

Provider: For state management, making AuthService accessible throughout the app.

image_picker: Flutter plugin for picking images from the device gallery.

url_launcher: Flutter plugin for launching URLs (phone dialer, email client).

**Usage**

Login/Register:

The app will start on the Login page. You can register a new account or log in with existing credentials.

During registration, you can specify your name, phone number, and select user roles (e.g., Buy/Rent Vehicles, Sell Vehicles, Provide Services).

Browse Cars:

After logging in (or if you launch the app and are already logged in), you'll see a list of available cars on the Home page.

If no cars are listed, you can add some using the "List your car on Vroom" button.

View Car Details:

Tap on any car card to view its detailed information.

If you are not logged in and try to view car details, you will be prompted to log in first. Upon successful login, you will be redirected to the car's details.

Contact Lister:

On the "Car Details" page, click the "Contact Lister" button. This will take you to a page with the lister's name, phone number, and email.

You can tap the "Call Lister" or "Email Lister" buttons to initiate a call or open your email client, respectively.

Add New Car:

From the Home page, click the "List your car on Vroom" button in the AppBar.

Fill out the form with car details and lister information.

Tap the "Tap to select car image" area to upload an image from your device.

Click "Add Car" to save the listing to Firestore.

**Future Enhancements

**User Profiles: Allow users to view and edit their profiles.

Booking System: Re-implement a full booking system with date selection, payment integration, and booking history.

Search and Filters: Add functionality to search for cars by make, model, price, etc.

User Reviews and Ratings: Enable users to leave reviews and ratings for cars and listers.

Admin Panel: A dedicated section for administrators to manage users, cars, and bookings.

Push Notifications: Notify users about booking confirmations, new messages, etc.

Map Integration: Show car locations on a map.

### Deploying to Firebase Hosting (Web)

Firebase Hosting is another robust and free option for Flutter web apps, especially useful if your app uses other Firebase services.

... (existing deployment steps) ...

5.  **Deploy to Firebase Hosting:**
    ```bash
    firebase deploy --only hosting
    ```
    The CLI will provide the Hosting URL (e.g., `https://vroom-1dcf4.web.app`) once the deployment is complete.

    **Hosting Details:**
    This application is deployed on Firebase Hosting. You can view the live application at:
    **Live URL:** [https://vroom-1dcf4.web.app](https://vroom-1dcf4.web.app)

    To manage this project within Firebase (check deployments, usage, etc.), access the **Firebase Console** here:
    **Firebase Console:** [https://console.firebase.google.com/project/vroom-1dcf4/overview](https://console.firebase.com/project/vroom-1dcf4/overview)

---
