//
//  YNKViewController.h
//  yumenokawa
//
//  Created by John Hsu on 13/8/3.
//  Copyright (c) 2013年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface YNKViewController : UIViewController
{
    AVAudioPlayer *bgmPLayer;
    AVAudioPlayer *vocalPlayer;
    
    IBOutlet UISlider *bgmVolSlider;
    IBOutlet UISlider *vocalVolSlider;
    BOOL isPaused;
}
@end
