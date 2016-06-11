//
//  ViewController.m
//  averagecolor
//
//  Created by Sroik on 2/8/16.
//  Copyright © 2016 Sroik. All rights reserved.
//

#import "ViewController.h"
#import "ImageColorsDetector.h"

@interface ViewController ()
@property (nonatomic, strong) ImageColorsDetector *colorsDetector;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:@"img.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    self.colorsDetector = [[ImageColorsDetector alloc] init];
    [self.colorsDetector detectColorsForImage:image];
    
    NSArray *colors = @[self.colorsDetector.detectedBackgroundColor, self.colorsDetector.detectedPrimaryColor, self.colorsDetector.detectedSecondaryColor, self.colorsDetector.detectedDetailColor];
    
    for (int i = 0; i < colors.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){i*70, 0.0f, 70.0f, 70.0f}];
        view.backgroundColor = colors[i];
        [self.view addSubview:view];
    }
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
