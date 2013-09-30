//
//  DCAppDelegate.h
//  DeepCopyIfNotExist
//
//  Created by John Hsu on 13/9/29.
//
//

#import <Cocoa/Cocoa.h>

@interface DCAppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSTextField *srcTextField;
    IBOutlet NSTextField *dstTextField;
}
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, copy) NSURL *srcURL;
@property (nonatomic, copy) NSURL *dstURL;

@end
