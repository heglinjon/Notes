# Note App

Note App is a simple iOS application built with Swift and SwiftUI, utilizing Firebase Firestore for data storage. It allows users to create, read, update, and delete notes in real-time.

## Features

- Create new notes with a title and content
- View a list of all notes
- Edit existing notes
- Delete notes
- Real-time synchronization across multiple devices

## Installation

1. Clone the repository:
 git clone https://github.com/heglinjon/Notes.git

2. Install dependencies using Cocoapods:

cd note-app
pod install

3. Open the `Flaxlabs.xcworkspace` file in Xcode.

4. Build and run the app on the iOS Simulator or a physical device.


## Unit Testing

To run the unit tests for the Note App, I utilize a local mock Firestore server running on port 8080. This allows me to write tests for fetching and adding data from/to Firestore.

To set up the local mock Firestore server:

1. Install the Firestore Emulator by following the instructions in the Firebase documentation.

2. Start the Firestore Emulator and make sure it's running on port 8080:

 gcloud beta emulators firestore start --host-port=localhost:8080

3. Run the unit tests in Xcode, and they will interact with the local mock Firestore server.

