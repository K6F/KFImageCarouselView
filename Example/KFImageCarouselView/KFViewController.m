//
//  KFViewController.m
//  KFImageCarouselView
//
//  Created by K6F on 05/28/2015.
//  Copyright (c) 2014 K6F. All rights reserved.
//

#import "KFViewController.h"
#import "KFImageCarouselView.h"

@interface KFViewController ()<KFImageCarouselViewDataSource,KFImageCarouselViewDelegate>{
    NSArray *imageNames;
}

@property (weak, nonatomic) IBOutlet KFImageCarouselView *imageCarouseView;

@end

@implementation KFViewController
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // init
    imageNames = @[@"image1",@"image2",@"image3"];
    
    // set datasource
    _imageCarouseView.dataSource = self;
    _imageCarouseView.delegate   = self;
    
     _imageCarouseView.kfDisplayDuration = 2;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}

#pragma mark - KFImageCarouseViewDataSource
- (NSInteger)kf_countOfImages{
    NSLog(@"KFImageCarouseView count");
    return imageNames.count;
}
- (void)kf_imageView:(UIImageView *)imageView loadImageAtIndex:(NSInteger)index{
    imageView.image = [UIImage imageNamed:imageNames[index]];
}

#pragma mark - KFImageCarouselViewDelegate
- (void)kf_didTapImageAtIndex:(NSInteger)index{
    NSLog(@"%@",@(index));
}

@end
