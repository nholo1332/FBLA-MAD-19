<div align="center">
  <img width="200" height="200" src="https://user-images.githubusercontent.com/17395049/52447704-23f41c00-2af7-11e9-90c2-0e87363bdf17.png">
  <h1>Down to Business</h1>
  <p>FBLA Mobile Application Development 2019</p>
</div>

> Noah Holoubek and Mitchel Beeson's project for the FBLA MAD 2019.  Submitted for Nebraska State FBLA (SLC) and National FBLA (NLC).

This app allows you to quiz youself about FBLA and reserve some FBLA books.  Along with being able to quiz yourself over FBLA information, you can rank up on the leaderboard!
<br><br>
To view more screenshots with a brief description of each app view, please open the `Screenshots.pdf` PDF file.
<br> <br>
<div>
<img title="Onboarding" align="center" src="https://user-images.githubusercontent.com/17395049/52497409-a0403b00-2b9b-11e9-9959-f228d789e716.png" width="200" height="425" />
  <img title="Home" align="center" src="https://user-images.githubusercontent.com/17395049/52437119-ad95f080-2adb-11e9-8b1f-7b9d659281db.PNG" width="200" height="425" />
  <img title="Books" align="center" src="https://user-images.githubusercontent.com/17395049/52437400-6fe59780-2adc-11e9-9180-ae676cfaa538.PNG" width="200" height="425" />
  <img title="Settings" align="center" src="https://user-images.githubusercontent.com/17395049/52437759-5002a380-2add-11e9-97c0-8bbedf6f836c.PNG" width="200" height="425" />
</div>

## Features

- [x] Login, singup, and reset password
- [x] Quiz (5 topics to chose from)
- [x] FBLA book reserve
- [x] Integrated Facebook share (for you perfect quiz score)
- [x] Clear and easy navigation
- [x] Custom graphics
- [x] Secure using secure database rules

## Requirements

- iOS 11.0+
- Xcode 10.1

## Opening Project
To open the project, unzip the download and find the `FBLA.xcworkspace`.  Open that with Xcode.  If Xcode can't find the import statements or dependencies, use the installation guide below.

## Installation

#### CocoaPods
Once you have the app downloaded, all the required CocoaPods should already be there.  If they are not, you will need to install them.
In Terminal, type `cd Downloads` (supposing the app is in your Download folder).  Then type `cd FBLA-MAD-19`, and hit enter (make sure to have the download unzipped before running the commands in Terminal).  Once in that folder, type `pod install` to install the CocoaPods.  If you don't have CocoaPods CLI installed, install it by running `sudo gem install cocoapods`.

## Built with
- Xcode 10
- Swift 4
- [Firebase](https://firebase.google.com)

And other [dependencies](https://github.com/nholo1332/FBLA-MAD-19/blob/master/Podfile)...
