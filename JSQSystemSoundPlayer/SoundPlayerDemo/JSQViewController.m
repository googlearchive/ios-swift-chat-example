//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "JSQViewController.h"
#import "JSQSystemSoundPlayer.h"

@implementation JSQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.soundSwitch.on = [JSQSystemSoundPlayer sharedPlayer].on;
}

- (IBAction)playSystemSoundPressed:(UIButton *)sender
{
    JSQSystemSoundPlayer *sharedPlayer = [JSQSystemSoundPlayer sharedPlayer];
    
    [sharedPlayer playSoundWithName:@"Basso"
                          extension:kJSQSystemSoundTypeAIF
                         completion:^{
                             NSLog(@"Sound finished playing. Executing completion block...");
                             
                             [sharedPlayer playAlertSoundWithName:@"Funk"
                                                        extension:kJSQSystemSoundTypeAIFF];
                         }];
}

- (IBAction)playAlertSoundPressed:(UIButton *)sender
{
    [[JSQSystemSoundPlayer sharedPlayer] playAlertSoundWithName:@"Funk"
                                                      extension:kJSQSystemSoundTypeAIFF];
}

- (IBAction)playVibratePressed:(UIButton *)sender
{
    [[JSQSystemSoundPlayer sharedPlayer] playVibrateSound];
}

- (IBAction)playLongSoundPressed:(UIButton *)sender
{
    NSLog(@"Playing long sound...");
    [[JSQSystemSoundPlayer sharedPlayer] playSoundWithName:@"BalladPiano"
                                                 extension:kJSQSystemSoundTypeCAF
                                                completion:^{
                                                    NSLog(@"Long sound complete!");
                                                }];
}

- (IBAction)stopPressed:(UIButton *)sender
{
    [[JSQSystemSoundPlayer sharedPlayer] stopAllSounds];
    
    //  Stop playing specific sound
    //  [[JSQSystemSoundPlayer sharedPlayer] stopSoundWithFilename:@"BalladPiano"];
}

- (IBAction)toggleSwitch:(UISwitch *)sender
{
    [[JSQSystemSoundPlayer sharedPlayer] toggleSoundPlayerOn:sender.on];
}

@end
