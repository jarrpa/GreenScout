
**GreenScout** is a FIRST™ Robotics scouting app made by the "The Green Machine" that aims to provide a framework for large and small scouting activites. 

We host the website statically, so if you want to take a quick peak you can head over to https://thegreenmachine.github.io/GreenScout/ and login as a guest.

# Getting Started

It's expected that you at least know basic programming principles and practices. Additionally, knowing the [Dart Programming Language](https://dart.dev/guides) will be neccessary when contributing to the app, which uses the [Flutter Framework](https://flutter.dev/) made by Google.

To get started, you'll first need the [Flutter SDK](https://docs.flutter.dev/get-started/install), [Git](https://git-scm.com/downloads), and [VS Code (Optional)](https://code.visualstudio.com/Download).

Once you have all that installed, open up your terminal and enter this command
```bash
git clone https://github.com/TheGreenMachine/GreenScout.git
```

This will download the repository onto your computer and to move into it type this
```bash
cd GreenScout
```

To run the application on your computer, execute this command
```bash
flutter run
```

This should present you with a few options for building, for example on windows you can get this
```
Windows (desktop) • windows • windows-x64    • Microsoft Windows [Version 10.0.19045.4291]
Chrome (web)      • chrome  • web-javascript • Google Chrome 124.0.6367.60
Edge (web)        • edge    • web-javascript • Microsoft Edge 124.0.2478.51
[1]: Windows (windows)  <-Changes depending on what device is used
[2]: Chrome (chrome)
[3]: Edge (edge)
```

Choose whichever target you would like to build for and run the app.

If you are building to the web, add the argument `--web-browser-flag=--disable-web-security`, as the backend CORS compatibility does not extend to localhost.

P.S: If you are using VS Code, I highly recommend installing the [Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) and [Dart Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) as they provide code highlighting, code suggestions, an integrated build system, and debug console into the editor.

Also, any additional documentation can be found [here](./docs/).

# Important setup information
Make sure to set serverHostName in app_state.dart to the address of the actual server you'll be using as the backend.

# Roadmap (Things for future developers to add)
  * Admin Features
    * Impersonation of other users.
    * Removing assigned matches from users. (Mutable schedules - talk to Lydia for specifics of what she wants)
    * Public shaming (requested by Lydia)

  * Settings
    * Match Form Builder 
    * More menus for customizing the app further.
    * Theme changing
  
  * Pit Scouting - Already implemented on the backend

  * Videos
    * Link to the video of a specified match to make rescouting easier
    * Stream/link to stream of the event
    * Stream timberwolves games

# Contributers

- [Michael P](https://github.com/mp768)
- [Tag C](https://github.com/TagCiccone)
