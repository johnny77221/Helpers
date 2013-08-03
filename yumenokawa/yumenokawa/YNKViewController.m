//
//  YNKViewController.m
//  yumenokawa
//
//  Created by John Hsu on 13/8/3.
//  Copyright (c) 2013年 test. All rights reserved.
//

#import "YNKViewController.h"

@interface YNKViewController ()

@end


@implementation YNKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!vocalPlayer) {
        NSURL *vocalURL = [[NSBundle mainBundle] URLForResource:@"vocal" withExtension:@"mp3"];
        vocalPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:vocalURL error:nil];
    }
    if (!bgmPLayer) {
        NSURL *bgmURL = [[NSBundle mainBundle] URLForResource:@"bgm" withExtension:@"mp3"];
        bgmPLayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgmURL error:nil];
    }
    isPaused = YES;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setVocalTimeAccordingToBGMTime) userInfo:nil repeats:YES];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setRemoteControllable];

}

-(IBAction)volumeAction:(id)sender
{
    [bgmPLayer setVolume:bgmVolSlider.value];
    [vocalPlayer setVolume:vocalVolSlider.value];
}


-(IBAction)plus3SecAction:(id)sender
{
    if (bgmPLayer.duration - bgmPLayer.currentTime > 3.00) {
        [bgmPLayer setCurrentTime:bgmPLayer.currentTime + 3.0f];
    }
    else {
//        [bgmPLayer setCurrentTime:0];
    }
    [self setVocalTimeAccordingToBGMTime];
}

-(IBAction)minus3SecAction:(id)sender
{
    if (bgmPLayer.currentTime - 3.0 > 0) {
        [bgmPLayer setCurrentTime:bgmPLayer.currentTime - 3.0f];
    }
    else {
        [bgmPLayer setCurrentTime:0];
    }

    [self setVocalTimeAccordingToBGMTime];
}

-(IBAction)playPauseAction:(id)sender
{
    if (isPaused) {
//        [vocalPlayer play];
        [bgmPLayer play];
    }
    else {
        [vocalPlayer pause];
        [bgmPLayer pause];
    }
    isPaused = !isPaused;
    [self setVocalTimeAccordingToBGMTime];
}
-(IBAction)backToBeginningAction:(id)sender
{
    [bgmPLayer setCurrentTime:0];
    [self setVocalTimeAccordingToBGMTime];
}

-(void)setVocalTimeAccordingToBGMTime
{
    const double timeDiff = 17.82;
    [NSObject cancelPreviousPerformRequestsWithTarget:vocalPlayer selector:@selector(play) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setVocalTimeAccordingToBGMTime) object:nil];
    if (bgmPLayer.currentTime >= timeDiff) {
        [vocalPlayer setCurrentTime:bgmPLayer.currentTime - timeDiff];
        if (!isPaused) {
            [vocalPlayer play];
        }
    }
    else {
        [vocalPlayer setCurrentTime:0];
        [vocalPlayer pause];
        if (!isPaused) {
            NSLog(@"timeDiff - bgmPLayer.currentTime:%f",timeDiff - bgmPLayer.currentTime);
            [vocalPlayer performSelector:@selector(play) withObject:nil afterDelay:timeDiff - bgmPLayer.currentTime];
            [self performSelector:@selector(setVocalTimeAccordingToBGMTime) withObject:nil afterDelay:timeDiff - bgmPLayer.currentTime];
        }
    }
   
}
-(void)setRemoteControllable
{
    AudioSessionInitialize (NULL, NULL, NULL, NULL);
//    AudioSessionSetActive(true);

	UInt32 category = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
	AudioSessionSetActive(true);
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    NSLog(@"remoteControlReceivedWithEvent");
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            /*
			if ([[multimediaPlayerViewController moviePlayer] playbackState] == MPMoviePlaybackStatePaused) {
				ZSLog(@"set to play...");
				[[multimediaPlayerViewController moviePlayer] play];
			}
			else if ([[multimediaPlayerViewController moviePlayer] playbackState] == MPMoviePlaybackStatePlaying) {
				ZSLog(@"set to pause...");
				[[multimediaPlayerViewController moviePlayer] pause];
			}
			ZSLog(@"playbackState: %d",[[multimediaPlayerViewController moviePlayer] playbackState]);
             */
            [self playPauseAction:nil];
            break;
//        case UIEventSubtypeRemoteControlNextTrack:
//            ZSLog(@"Next");
//            break;
//		case UIEventSubtypeRemoteControlPreviousTrack:
//            ZSLog(@"Prev");
//			[[multimediaPlayerViewController moviePlayer] setCurrentPlaybackTime:0];
//            break;
        default:
            break;
    }
}
@end
