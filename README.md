# DAPageControlView

[![Version](https://img.shields.io/cocoapods/v/DAPageControlView.svg?style=flat)](http://cocoadocs.org/docsets/DAPageControlView)
[![License](https://img.shields.io/cocoapods/l/DAPageControlView.svg?style=flat)](http://cocoadocs.org/docsets/DAPageControlView)
[![Platform](https://img.shields.io/cocoapods/p/DAPageControlView.svg?style=flat)](http://cocoadocs.org/docsets/DAPageControlView)

![Alt text](DAPageControlView.gif)


## Abstract

I just love `UIPageControl`, don’t you? It’s simple and intuitive, a perfect choice when you have a fullscreen `UIScrollView` with `pagingEnabled` and you want to encourage your users to “swipe to see more”.  
So why use a scrollable `UIPageControl,` if its essence is to indicate the *current* page of *total number of* pages? Say, you have this screen where you display books for the current author. And usually there are just 5-6 books to display, but there is this one very productive author who has written 37 books. You do not want to change your design because of this one author, but the native `UIPageControl` will not look nice just for this one case. That’s when `DAPageControlView` comes to rescue: **it behaves exactly like `UIPageControl` when page indicators fit its width and handles nicely the case when they don’t**.   
Besides if you want to use pagination to load those 37 books from your server, `DAPageControlView` knows how to handle that nicely too – it will animate the right-hand page indicator view when appropriate letting users know there is more data loading.

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DAPageControlView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "DAPageControlView"

## Author

Daria Kopaliani, daria.kopaliani@gmail.com

## License

DAPageControlView is available under the MIT license. See the LICENSE file for more info.

