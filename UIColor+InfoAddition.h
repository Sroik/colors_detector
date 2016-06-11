//
//  UIImage+InfoAddition.h
//  averagecolor
//
//  Created by Sroik on 2/8/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (InfoAddition)

- (BOOL)isDarkColor;

- (BOOL)isBlackOrWhite;

- (BOOL)isDistinct:(UIColor *)compareColor;

- (UIColor *)colorWithMinimumSaturation:(CGFloat)minSaturation;

- (BOOL)isContrastingColor:(UIColor *)color;

@end
