# JSQSystemSoundPlayer 
[![Build Status](https://secure.travis-ci.org/jessesquires/JSQSystemSoundPlayer.svg)](http://travis-ci.org/jessesquires/JSQSystemSoundPlayer) [![Version Status](http://img.shields.io/cocoapods/v/JSQSystemSoundPlayer.png)][docsLink] [![license MIT](http://img.shields.io/badge/license-MIT-orange.png)][mitLink]

A fancy Obj-C wrapper for iOS [System Sound Services](https://developer.apple.com/library/ios/documentation/AudioToolbox/Reference/SystemSoundServicesReference/Reference/reference.html).

This class is a light-weight, drop-in component to play sound effects, or other short sounds in your iOS app. 
To determine your audio needs, see [Best Practices for iOS Audio](https://developer.apple.com/library/ios/DOCUMENTATION/AudioVideo/Conceptual/MultimediaPG/UsingAudio/UsingAudio.html#//apple_ref/doc/uid/TP40009767-CH2-SW10).
Or, read the tl;dr version:

>*When your sole audio need is to play alerts and user-interface sound effects, use Core Audio’s System Sound Services.*
>
>Your sound files must be:
>
>* No longer than 30 seconds in duration
>* In linear PCM or IMA4 (IMA/ADPCM) format
>* Packaged in a `.caf`, `.aif`, or `.wav` file

If this does not fit your needs, then this control is not for you! 
See [AVAudioPlayer](https://developer.apple.com/library/ios/DOCUMENTATION/AVFoundation/Reference/AVAudioPlayerClassReference/Reference/Reference.html), instead.

![JSQSystemSoundPlayer Screenshot][imgLink] 

## Features

* Play sound effects and alert sounds with a single line of code
* "Play" vibration (if available on device)
* Block-based completion handlers
* Integration with `NSUserDefaults` to globally toggle sound effects in your app
* Sweet and efficient memory management
* Caches sounds (`SystemSoundID` objects) and purges on memory warning

## Requirements

* iOS 6.0+ 
* ARC

## Installation

````
pod 'JSQSystemSoundPlayer'
````
Otherwise, drag the `JSQSystemSoundPlayer/` folder to your project, and add `AudioToolbox.framework`.

## Getting Started

````objective-c
[[JSQSystemSoundPlayer sharedPlayer] playSoundWithName:@"mySoundFile"
                                             extension:kJSQSystemSoundTypeAIF
                                            completion:^{
                                                // completion block code
                                            }];
````

And that's all! 

String constants for file extensions provided for you: 
* `kJSQSystemSoundTypeCAF`
* `kJSQSystemSoundTypeAIF`
* `kJSQSystemSoundTypeAIFF`
* `kJSQSystemSoundTypeWAV`

Need a setting in your app's preferences to toggle sound effects on/off? `JSQSystemSoundPlayer` can do that, too! There's no need to ever check the saved settings (`[JSQSystemSoundPlayer sharedPlayer].on`) before you play a sound effect. Just play a sound like in the example above. `JSQSystemSoundPlayer` respects whatever setting has been previously saved.

````objective-c
[[JSQSystemSoundPlayer sharedPlayer] toggleSoundPlayerOn:YES];
````

Also see the included demo project: `SoundPlayerDemo.xcodeproj`

_**For a good time:**_
````objective-c
while (1) {
    [[JSQSystemSoundPlayer sharedPlayer] playVibrateSound];
}
````

## Documentation

Read the fucking docs, [available here][docsLink] via [@CocoaDocs](https://twitter.com/CocoaDocs).

## Contribute

Please follow these sweet [contribution guidelines](https://github.com/jessesquires/HowToContribute).

## Donate

Support the development of this **free**, open-source library! 

> *Donations made via [Square Cash](https://square.com/cash)*
> <h4><a href="mailto:jesse.squires.developer@gmail.com?cc=cash@square.com&subject=$1&body=Thanks for developing JSQSystemSoundPlayer!">Send $1</a> <em>Just saying thanks!</em></h4>
> <h4><a href="mailto:jesse.squires.developer@gmail.com?cc=cash@square.com&subject=$5&body=Thanks for developing JSQSystemSoundPlayer!">Send $5</a> <em>This control is great!</em></h4>
> <h4><a href="mailto:jesse.squires.developer@gmail.com?cc=cash@square.com&subject=$10&body=Thanks for developing JSQSystemSoundPlayer!">Send $10</a> <em>This totally saved me time!</em></h4>

## Credits

Created by [**@jesse_squires**](https://twitter.com/jesse_squires), a [programming-motherfucker](http://programming-motherfucker.com).

Many thanks to [**the contributors**](https://github.com/jessesquires/JSQSystemSoundPlayer/graphs/contributors) of this project.

## Apps using this library

* [Hemoglobe](http://bit.ly/hemoglobeapp)
* [iPaint uPaint](http://bit.ly/ipupappstr)
* [MUDRammer](https://itunes.apple.com/us/app/mudrammer-a-modern-mud-client/id597157072?mt=8)

## License

`JSQSystemSoundPlayer` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2013 Jesse Squires.**

*Please provide attribution, it is greatly appreciated.*

[docsLink]:http://cocoadocs.org/docsets/JSQSystemSoundPlayer
[mitLink]:http://opensource.org/licenses/MIT
[imgLink]:https://raw.github.com/jessesquires/JSQSystemSoundPlayer/master/Screenshots/screenshot.png
