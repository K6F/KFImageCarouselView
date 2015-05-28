//
//  KFImageCarouselView.h
//  XBAdPageView
//
//  Created by K6F on 15/5/27.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KFImageCarouselViewDataSource;
@protocol KFImageCarouselViewDelegate;

@interface KFImageCarouselView : UIView
/**
 *  @author Khiyuan.Fan, 2015-22[3]
 *
 *  Duration must >= 1 second, or would be ignored.
 */
@property (nonatomic,assign) NSTimeInterval                    kfDisplayDuration;
@property (nonatomic,assign) id<KFImageCarouselViewDataSource> dataSource;
@property (nonatomic,assign) id<KFImageCarouselViewDelegate>   delegate;

@property (nonatomic,strong) UIPageControl                     *pageControl;

- (void)reloadData;
@end

@protocol KFImageCarouselViewDataSource <NSObject>
/**
 *  @author K6F, 2015-22[3]
 *
 *  @return count of images
 */
- (NSInteger)kf_countOfImages;
/**
 *  @author K6F, 2015-22[3]
 *
 *  Load image to imageView.
 *  You can use SDWebImage or NSData to load image from Internet.
 *  Or just load local image with path or name.
 *
 *  @param imageView UIImageView to Show
 *  @param index     index of image
 */
- (void)kf_imageView:(UIImageView *)imageView loadImageAtIndex:(NSInteger)index;
@end

@protocol KFImageCarouselViewDelegate <NSObject>
/**
 *  @author K6F, 2015-22[3]
 *
 *  Tap action.
 *
 *  @param index Index of image which is tapped
 */
- (void)kf_didTapImageAtIndex:(NSInteger)index;
@end