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

@property (weak, nonatomic) IBOutlet KFImageCarouselView *imageCarouselView;
@property (weak, nonatomic) IBOutlet KFImageCarouselView *scaledImageCarouselView;

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
    _imageCarouselView.dataSource = self;
    _imageCarouselView.delegate   = self;
    
     _imageCarouselView.kfDisplayDuration = 2.f;
    
    _scaledImageCarouselView.dataSource = self;
    _scaledImageCarouselView.delegate = self;
    
    _scaledImageCarouselView.kfDisplayDuration = 2.f;
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

#pragma mark - KFimageCarouselViewDataSource
- (NSInteger)kf_countOfImages{
    NSLog(@"KFimageCarouselView count");
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
