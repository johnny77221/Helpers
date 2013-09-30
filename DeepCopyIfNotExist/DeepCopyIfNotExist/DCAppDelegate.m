//
//  DCAppDelegate.m
//  DeepCopyIfNotExist
//
//  Created by John Hsu on 13/9/29.
//
//

#import "DCAppDelegate.h"

@implementation DCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(IBAction)selectSrcAction:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    
    if ( [panel runModal] == NSFileHandlingPanelOKButton )
    {
        self.srcURL = [[panel URLs] lastObject];
        [[srcTextField cell] setTitle:[self.srcURL path]];
    }
}

-(IBAction)selectDestinationAction:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    
    if ( [panel runModal] == NSFileHandlingPanelOKButton )
    {
        self.dstURL = [[panel URLs] lastObject];
        [[dstTextField cell] setTitle:[self.dstURL path]];
    }
}

-(IBAction)startCopyAction:(id)sender
{
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:self.srcURL includingPropertiesForKeys:nil options:0 errorHandler:^BOOL(NSURL *url, NSError *error) {
        if (error) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
            return YES;
        }
        return NO;
    }];
    NSString *sourceBaseURLString = [self.srcURL path];
    NSURL *sourceURL = nil;
    while ((sourceURL = [enumerator nextObject])) {
        NSString *sourceString = [sourceURL path];

        // ignore if source is purely a dir
        BOOL isDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:sourceString isDirectory:&isDir];
        if (isDir) {
            continue;
        }

        
        NSString *pathComponentDiff = [sourceString stringByReplacingOccurrencesOfString:sourceBaseURLString withString:@""];
        NSString *destinationString = [[self.dstURL path] stringByAppendingPathComponent:pathComponentDiff];
        
        BOOL destinationIsDir = NO;
        BOOL destinationExist = [[NSFileManager defaultManager] fileExistsAtPath:destinationString isDirectory:&destinationIsDir];
        if (!destinationExist && !destinationIsDir) {
            NSError *mkdirError = nil;
            NSError *copyError = nil;
            NSString *copyToDir = [destinationString stringByDeletingLastPathComponent];
            [[NSFileManager defaultManager] createDirectoryAtPath:copyToDir withIntermediateDirectories:YES attributes:nil error:&mkdirError];
            [[NSFileManager defaultManager] copyItemAtPath:sourceString toPath:destinationString error:&copyError];
            if (mkdirError) {
                NSLog(@"mkdirError : %@", [mkdirError localizedDescription]);
            }
            if (copyError) {
                NSLog(@"copyError : %@", [copyError localizedDescription]);
            }
        }
    }
    [[NSAlert alertWithMessageText:@"Done" defaultButton:@"Done" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
}
@end
