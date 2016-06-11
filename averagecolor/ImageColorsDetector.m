//
//  ImageColorsDetector.m
//  averagecolor
//
//  Created by Sroik on 2/8/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import "ImageColorsDetector.h"
#import "UIImage+Resize.h"
#import "UIColor+InfoAddition.h"
#import "CountedColor.h"

static CGFloat const kScaledDownImageWidth = 300.0f;
static NSInteger const kColorsCountThreshold = 3;

@interface ImageColorsDetector()
@property (nonatomic, strong, readwrite) UIColor *detectedBackgroundColor;
@property (nonatomic, strong, readwrite) UIColor *detectedPrimaryColor;
@property (nonatomic, strong, readwrite) UIColor *detectedSecondaryColor;
@property (nonatomic, strong, readwrite) UIColor *detectedDetailColor;

@property (nonatomic, strong) NSCountedSet *leftEdgeColors;
@property (nonatomic, strong) NSCountedSet *imageColors;
@end

@implementation ImageColorsDetector

+ (ImageColorsDetector *)detector {
    return [[self alloc] init];
}

- (void)detectColorsForImage:(UIImage *)image {
    [self setupImageColorsForImage:image];
    [self detectBackgroundColor];
    [self detectTextsColors];
}

- (void)setupImageColorsForImage:(UIImage *)image {
    CGFloat imageRatio = image.size.width/image.size.height;
    CGSize imageSize = (CGSize){kScaledDownImageWidth, kScaledDownImageWidth/imageRatio};
   
    CGImageRef cgImage = [image imageResizedToSize:imageSize].CGImage;
    
    CGFloat width = CGImageGetWidth(cgImage);
    CGFloat height = CGImageGetHeight(cgImage);
    
    NSInteger bytesPerPixel = 4;
    NSInteger bytesPerRow = width * bytesPerPixel;
    NSInteger bitsPerComponent = 8;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, (CGRect){CGPointZero, (CGSize){width, height}}, cgImage);
    unsigned char* data = CGBitmapContextGetData(context);
    
    self.imageColors = [NSCountedSet set];
    self.leftEdgeColors = [NSCountedSet set];
    
    for ( int x = 0; x < width; x++ ) {
        for ( int y = 0; y < height; y++ ) {
            NSInteger pixel = ((width*y) + x)*bytesPerPixel;
            
            UIColor *color = [UIColor colorWithRed:((CGFloat)data[pixel + 0])/255.0f
                                             green:((CGFloat)data[pixel + 1])/255.0f
                                              blue:((CGFloat)data[pixel + 2])/255.0f
                                             alpha:((CGFloat)data[pixel + 3])/255.0f];
            
            /** We need to ignore the first few pixels, because a lot of albums have white or black edges */
            BOOL isLeftEdgeColor = ( x > 5 && x < 15 );
            if (isLeftEdgeColor)
                [self.leftEdgeColors addObject:color];
            
            [self.imageColors addObject:color];
        }
    }
    
    CGContextRelease(context);
}

- (void)detectBackgroundColor {
    NSEnumerator *enumenator = [self.leftEdgeColors objectEnumerator];
    NSMutableArray *sortedColors = [NSMutableArray array];
    UIColor *currentColor = nil;
    
    while ((currentColor = [enumenator nextObject]) != nil) {
        NSUInteger colorCount = [self.leftEdgeColors countForObject:currentColor];
        
        if (colorCount > kColorsCountThreshold) {
            CountedColor *countedColor = [[CountedColor alloc] initWithColor:currentColor count:colorCount];
            [sortedColors addObject:countedColor];
        }
    }
    
    [sortedColors sortUsingSelector:@selector(compare:)];
    
    CountedColor *proposedBackgroundColor = sortedColors.firstObject;
    if (!proposedBackgroundColor) {
        self.detectedBackgroundColor = [UIColor blackColor];
        return;
    }
    
    if ([proposedBackgroundColor.color isBlackOrWhite]) {
        for ( int i = 1; i < [sortedColors count]; i++ ) {
            CountedColor *nextColor = [sortedColors objectAtIndex:i];
            
            /** make sure the second choice color is 30% as common as the first choice */
            if (((CGFloat)nextColor.count)/((CGFloat)proposedBackgroundColor.count) > 0.3f) {
                if (![nextColor.color isBlackOrWhite]) {
                    proposedBackgroundColor = nextColor;
                    break;
                }
            } else {
                break;
            }
        }
    }
    
    self.detectedBackgroundColor = proposedBackgroundColor.color;
}


- (void)detectTextsColors {
    NSAssert(self.imageColors != nil, @"detect image colors at first");
    
    BOOL needDarkTextColors = ![self.detectedBackgroundColor isDarkColor];
    
    NSEnumerator *enumenator = [self.imageColors objectEnumerator];
    NSMutableArray *sortedColors = [NSMutableArray array];
    UIColor *currentColor = nil;
    
    while ((currentColor = [enumenator nextObject]) != nil) {
        
        /* color shouldn't be too pale or washed out */
        currentColor = [currentColor colorWithMinimumSaturation:0.15f];
        
        if ([currentColor isDarkColor] == needDarkTextColors) {
            
            NSUInteger count = [self.imageColors countForObject:currentColor];

            CountedColor *color = [[CountedColor alloc] initWithColor:currentColor count:count];
            
            [sortedColors addObject:color];
        }
    }
    
    [sortedColors sortUsingSelector:@selector(compare:)];
    
    for (CountedColor *countedColor in sortedColors) {
        currentColor = countedColor.color;
        
        BOOL moreContrastThenBack = [currentColor isContrastingColor:self.detectedBackgroundColor];
        if (!moreContrastThenBack) {
            continue;
        }
        
        if (self.detectedPrimaryColor == nil) {
            self.detectedPrimaryColor = currentColor;
            
        } else if (self.detectedSecondaryColor == nil) {
            
            if ([self.detectedPrimaryColor isDistinct:currentColor]){
                self.detectedSecondaryColor = currentColor;
            }
            
        } else if (self.detectedDetailColor == nil) {
            
            if ([self.detectedSecondaryColor isDistinct:currentColor] && [self.detectedPrimaryColor isDistinct:currentColor]) {
                self.detectedDetailColor = currentColor;
                break;
            }
        }
    }
    
}

@end

