//
//  UIImage+Resize.m
//  averagecolor
//
//  Created by Sroik on 2/17/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)imageResizedToSize:(CGSize)toSize {
    UIGraphicsBeginImageContextWithOptions(toSize, NO, 0);
    [self drawInRect:(CGRect){CGPointZero, toSize}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
