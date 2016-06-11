//
//  ImageColorsDetector.h
//  averagecolor
//
//  Created by Sroik on 2/8/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageColorsDetector : NSObject

@property (nonatomic, strong, readonly) UIColor *detectedBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *detectedPrimaryColor;
@property (nonatomic, strong, readonly) UIColor *detectedSecondaryColor;
@property (nonatomic, strong, readonly) UIColor *detectedDetailColor;

+ (ImageColorsDetector *)detector;

- (void)detectColorsForImage:(UIImage *)image;

@end

