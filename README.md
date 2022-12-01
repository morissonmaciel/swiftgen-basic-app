# swiftgen-basic-app

A simple and easy understanding structural iOS project intended to be used as a template for starter Swift projects.

## Pre-requisites

To start using this project as template you need at least this three pre-requisites in your macOS machine:

1. Any `git` client instaled, as `git cli` or `Github Desktop` 
2. `Xcode` 11.x or earlier installed and `command line tools` proper initiated
3. `XcodeGen` installed through `brew install xcodegen` command. More intructions at https://github.com/yonaskolb/XcodeGen

## Usage

1. Simple clone this repository using `git clone https://github.com/morissonmaciel/swiftgen-basic-app.git ~/.swiftgen-basic-app`
2. Create a structural copy for your project folder using `cp -R ~/.swiftgen-basic-app ./MyIOSApp`
3. Enter your project folder using `cd ./MyIOSApp`
4. Open the `project.yml` file using either one of following commands: `nano project.yml` or `open project.yml`
5. Replace `iOSApp` text entries with `MyIOSApp` to futher proper generate targets for your app
6. Remove the `.git` folder, preventing any source control conflict: `rm -rf .git`

Obs: the final results expected for the file would be...

``` yml
name: MyIOSApp
packages:
    ViewInspector:
        url: https://github.com/nalexn/ViewInspector
        from: "0.9.2"
targets:
    MyIOSApp:
        type: application
        platform: iOS
        deploymentTarget: "13.0"
        sources: [MyIOSApp]
        settings:
            base:
                INFOPLIST_FILE: MyIOSApp/Info.plist
                ENTITLEMENTS_FILE: MyIOSApp/App.entitlements
                PRODUCT_BUNDLE_IDENTIFIER: com.codename.ios.app
        scheme:
            testTargets:
                - MyIOSAppTests
    MyIOSAppTests:
        type: bundle.unit-test
        platform: iOS
        deploymentTarget: "13.0"
        sources: [MyIOSAppTests]
        settings:
            base:
                INFOPLIST_FILE: MyIOSAppTests/Info.plist
        dependencies:
            - target: MyIOSApp
            - package: ViewInspector
```

7. Run `xcodegen` command and wait for project generation
8. Open your project using `open MyIOSApp.xcodeproj/`

## Remarks

This project is a basic `iOS app` with `both executable and tests targets configured with minimal setup` for your project. Feel free to add `cocoapods` `carthage` or any `swift package` to your project.
