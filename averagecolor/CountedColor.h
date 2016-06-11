//
//  CountedColor.h
//  averagecolor
//
//  Created by Sroik on 2/8/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountedColor : NSObject

@property (nonatomic) UIColor *color;
@property (nonatomic) NSUInteger count;

- (id)initWithColor:(UIColor*)color count:(NSUInteger)count;

@end
