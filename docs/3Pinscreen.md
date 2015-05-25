# 3. How to customize native PIN screen

In order to change UI elements, like buttons or background image you have to modify/override drawables accordingly. To change texts, check [How to change in-app messages](2Messages.md)

## Android
Drawables for android are located in 
  - `./src/android/res/drawable` for 9-patch drawables that can be scaled for different screens
  - `./src/android/res/drawable-mdpi` for drawables that should be used on medium-density screens
  - `./src/android/res/drawable-xhdpi` for drawables that should be used on (extra)high-density screens

## iOS
Drawables for ios are located in 
`./src/ios/OneginiCordovaPlugin/Resources`