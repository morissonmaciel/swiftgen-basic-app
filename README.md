# swiftgen-basic-app

A simple and easy understanding structural iOS project using SwiftUI and Scene Delegate to handle scenes.

<img width="1422" alt="image" src="https://user-images.githubusercontent.com/11509104/217132334-82359899-f3a7-460a-ba0a-a2310f33e04b.png">

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
5. Replace `BeagleApp` text entries with `MyIOSApp` to futher proper generate targets for your app
6. Remove the `.git` folder, preventing any source control conflict: `rm -rf .git`

Obs: the final results expected for the file would be...

``` yml
name: MyIOSApp
packages:
    ViewInspector:
        url: https://github.com/nalexn/ViewInspector
        version: "0.9.5"
    SnapshotTesting:
        url: https://github.com/pointfreeco/swift-snapshot-testing.git
        version: "1.11.0"
targets:
    MyIOSBasicApp:
        type: application
        platform: iOS
        deploymentTarget: "14.0"
        sources: [App]
        settings:
            base:
                INFOPLIST_FILE: App/Info.plist
                ENTITLEMENTS_FILE: App/App.entitlements
                PRODUCT_BUNDLE_IDENTIFIER: com.codename.ios.basic.app
        scheme:
            testTargets:
                - MyIOSBasicTests
            gatherCoverageData: true
    MyIOSBasicTests:
        type: bundle.unit-test
        platform: iOS
        deploymentTarget: "14.0"
        sources:
            - path: AppTests
              excludes:
                - ReferenceImages/**
        settings:
            base:
                INFOPLIST_FILE: AppTests/Info.plist
        dependencies:
            - target: BasicApp
            - package: ViewInspector
            - package: SnapshotTesting

```

7. Run `xcodegen` command and wait for project generation
8. Open your project using `open MyIOSApp.xcodeproj/`

## Remarks

This project is a basic `iOS app` with `both executable and tests targets configured with minimal setup` for your project. Feel free to add `cocoapods` `carthage` or any `swift package` to your project.
