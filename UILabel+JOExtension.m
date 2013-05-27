//
//  UILabel+JOExtension.m
//
//  Copyright (c) 2012. All rights reserved.
//

#import "UILabel+JOExtension.h"

@implementation UILabel (JOExtension)
+(UILabel *)labelWithText:(NSString *)text
{
    return [self labelWithText:text color:nil font:nil];
}

+(UILabel *)labelWithText:(NSString *)text color:(UIColor *)color
{
    return [self labelWithText:text color:color font:nil];

}

+(UILabel *)labelWithText:(NSString *)text font:(UIFont *)font
{
    return [self labelWithText:text color:nil font:font];
}

+(UILabel *)labelWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    if (font) {
        label.font = font;
    }
    if (color) {
        label.textColor = color;
    }
    label.text = text;
    return label;
}

@end
