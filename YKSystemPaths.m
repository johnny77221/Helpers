//
//  YKSystemPaths.m
//
//  Copyright (c) 2012 Yueks Inc. All rights reserved.
//

#import "YKSystemPaths.h"
#include <sys/xattr.h>

NSString* criticalDataPath()
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

NSString* cacheDataPath()
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
}

NSString* tempDataPath()
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

NSString* offlineDataPath()
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Private Documents"];
}

// last update: 2012 Aug 16
// reference http://developer.apple.com/library/ios/#qa/qa1719/_index.html
// reference was in 2012-04-23 version
BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL)
{
    NSString *versionString = [[UIDevice currentDevice] systemVersion];
    NSArray *parts = [versionString componentsSeparatedByString:@"."];
    NSString *majorVersionString = [parts objectAtIndex:0];
    NSString *minorVersionString = [parts count] >= 2 ? [parts objectAtIndex:1] : @"0";
    NSString *subMinorVersionString = [parts count] >= 3 ? [parts objectAtIndex:2] : @"0";

    int majorVersion = [majorVersionString intValue];
    int minorVersion = [minorVersionString intValue];
    int subMinorVersion = [subMinorVersionString intValue];
    
    if (majorVersion < 5 || (majorVersion == 5 && minorVersion == 0 && subMinorVersion == 0)) {
        NSLog(@"not possible to set 'do not backup' property on older OS or 5.0.0");
        return NO; // not possible to set on older OS or 5.0.0
    }
    else if (majorVersion == 5 && minorVersionString == 0 && subMinorVersion == 1) {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }

    
}