//
//  UIImage+InfoAddition.m
//  averagecolor
//
//  Created by Sroik on 2/8/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import "UIColor+InfoAddition.h"

@implementation UIColor (InfoAddition)

- (BOOL)isDarkColor {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    return (0.2126 * rgba[0] + 0.7152 * rgba[1] + 0.0722 * rgba[2]) < 0.5;
}

- (BOOL)isBlackOrWhite {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    return (rgba[0] > 0.91 && rgba[1] > 0.91 && rgba[2] > 0.91) || (rgba[0] < 0.09 && rgba[1] < 0.09 && rgba[2] < 0.09);
}

- (BOOL)isDistinct:(UIColor *)compareColor {
    const CGFloat *bg = CGColorGetComponents(self.CGColor);
    const CGFloat *fg = CGColorGetComponents(compareColor.CGColor);
    CGFloat threshold = 0.25f;
    
    if (fabs(bg[0] - fg[0]) > threshold || fabs(bg[1] - fg[1]) > threshold || fabs(bg[2] - fg[2]) > threshold) {
        if (fabs(bg[0] - bg[1]) < 0.03 && fabs(bg[0] - bg[2]) < 0.03) {
            if (fabs(fg[0] - fg[1]) < 0.03 && fabs(fg[0] - fg[2]) < 0.03) {
                return NO;
            }
        }
        
        return YES;
    }
    return NO;
}

- (UIColor *)colorWithMinimumSaturation:(CGFloat)minSaturation {
    CGFloat hue = 0.0;
    CGFloat saturation = 0.0;
    CGFloat brightness = 0.0;
    CGFloat alpha = 0.0;
    
    [self getHue:&hue
      saturation:&saturation
      brightness:&brightness
           alpha:&alpha];
    
    if (saturation < minSaturation) {
        return [UIColor colorWithHue:hue
                          saturation:saturation
                          brightness:brightness
                               alpha:alpha];
    } else {
        return self;
    }
}

- (BOOL)isContrastingColor:(UIColor *)color {
    const CGFloat *bg = CGColorGetComponents(self.CGColor);
    const CGFloat *fg = CGColorGetComponents(color.CGColor);
    
    CGFloat bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2];
    CGFloat fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2];
    CGFloat contrast = (bgLum > fgLum) ? (bgLum + 0.05)/(fgLum + 0.05):(fgLum + 0.05)/(bgLum + 0.05);
    
    return 1.6 < contrast;
}

@end
