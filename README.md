# Flutter Test Mobile App

## Description

This is a test mobile application built using Flutter. The app uses a localhost api for user authentication.

## Features

- User Login
- User Register
- User Delete
- Mobile Page
- Advanced Security Measure, Password Encryption and Token Authentication.
- Comically Ugly UI

## Getting Started
After installation open two visual studio instances, with one select FlutterTest folder and run 'node .' in the terminal to start the server. With the other open the flutter_application1 folder (inside FlutterApp) and run 'flutter run' in the terminal. IF YOU WANT TO RUN THE APP ON AN EMULATOR OR A PHONE YOU NEED TO CHANGE THE IP FROM LOCALHOST TO YOUR PRIVATE IP. http://localhost:8080 ----> http://192.168.1.32:8080
### Prerequisites

- Flutter SDK
- Dart
- An IDE like VS Code or Android Studio
- Node.js

### Installation

1. Clone the repo: `gh repo clone Zaidoudou/fluttertest`
2. Start the server by running 'node .' in the IDE terminal, Or 'node /YOURFILEPATH/index.js' in the CMD
3. /!\CHANGE THE IP OF THE SERVER IF YOU RUN THE APP ON AN EMULATOR, CURRENTLY IT IS LOCALHOST YOU MAY NEED TO INPUT YOUR PRIVATE IP./!\
## Usage

## API Reference

The APP interacts with the given API to validate user authentication. The API is comprised of three main endpoints.
POST /register taking username and password in body as an input.

POST /login same thing as register but verify the passwords, I could merge the two endpoints but I prefere to keep them seperate to be able to modify the credentials without deleting the account.

DELETE /user deletes the user, does not have any particular security aside from the token authentication.

GET /user Debug endpoint used to check if the app is correctly interacting with the API.


## Contributing

nuh uh.

## License

https://www.youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUIcmlja3JvbGw%3D