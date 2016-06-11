//
//  CountedColor.m
//  averagecolor
//
//  Created by Sroik on 2/8/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import "CountedColor.h"

@implementation CountedColor

- (id)initWithColor:(UIColor*)color count:(NSUInteger)count {
    self = [super init];
    if ( self ) {
        self.color = color;
        self.count = count;
    }
    return self;
}

- (NSComparisonResult)compare:(CountedColor *)color {
    if (self.count == color.count)
        return NSOrderedSame;

    return ( self.count < color.count ? NSOrderedDescending : NSOrderedAscending );
}

@end
