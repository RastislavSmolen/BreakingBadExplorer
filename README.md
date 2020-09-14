# BrBa - Breaking Bad Explorer

## Requirements
1. Built with Xcode 11.7
2. iOS 13 and up

## How to run the app?
1. Clone the repo on a macOS with Xcode 11.7 installed
2. Open the 'BreakingBadExplorer.xcodeproj' file on a macOS with Xcode 
3. Use CMD + R or Product -> Run.

## Notes
1. The app caches the API response and uses it on subsequent API calls.
2. Used SPM to manage Alamofire, AlamofireImage and Mocker dependencies.
3. Used MVVM pattern.
4. Adapts to Light/Dark mode with a breeze.

## Future Improvements
1. Show results count in footer of the characters screen for user to not just see a blank screen but rather an informative label at least.
2. Add UI tests for each individual use cases.
3. Adapt Accessibility
4. Adapt Dynamic Type