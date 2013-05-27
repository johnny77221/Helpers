//
//  UILabel+JOExtension.h
//
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JOExtension)
// Creates transparent UILabel object with specified properties
// Default is text color is black, font is system default
// You should call sizeToFit manually
+(UILabel *)labelWithText:(NSString *)text;
+(UILabel *)labelWithText:(NSString *)text color:(UIColor *)color;
+(UILabel *)labelWithText:(NSString *)text font:(UIFont *)font;
+(UILabel *)labelWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;
@end
