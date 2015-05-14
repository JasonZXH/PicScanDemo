//
//  ZXHPicScan.m
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 大毛集团. All rights reserved.
//

#import "ZXHPicScan.h"
#import <UIKit/UIKit.h>

#import "ZXHPicScanViewController.h"

@interface ZXHPicScan () <ZXHPicScanViewControllerDelegate>{
    
    ZXHPicScanViewController *_picScanVC;
    UIView *_scanBackView;
    UIImageView *_scanImageView;
}

@property (strong, nonatomic) NSArray *originImageViewArr;

@end

@implementation ZXHPicScan

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 黑色背景
    _scanBackView = [[UIView alloc] initWithFrame:window.bounds];
    _scanBackView.backgroundColor = [UIColor blackColor];
    _scanBackView.alpha = 0.0F;
    [window addSubview:_scanBackView];
    
    // 要展示的图片的替身
    _scanImageView = [[UIImageView alloc] init];
    [_scanBackView addSubview:_scanImageView];
}

- (void)showPicScanWithCurrentPage:(NSInteger)currPage andOriginImageViewArray:(NSArray *)theOriginImageViewArray {
    [self showPicScanWithCurrentPage:currPage andOriginImageViewArray:theOriginImageViewArray andImageURLArray:nil];
}

- (void)showPicScanWithCurrentPage:(NSInteger)currPage andOriginImageViewArray:(NSArray *)theOriginImageViewArray andImageURLArray:(NSArray *)theImageURLArray {

    self.originImageViewArr = [theOriginImageViewArray copy];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIImageView *theImageView = self.originImageViewArr[currPage];
    CGRect rectToWindow = [theImageView convertRect:theImageView.bounds toView:window];
    CGRect oldRect = rectToWindow;
    
    // 设置替身图片的位置
    _scanImageView.frame = oldRect;
    _scanImageView.image = theImageView.image;

    // 计算展示出来后的位置
    CGRect newRect = (CGRect)[ZXHPicScanViewController calculateRectWithTheImage:theImageView.image];
    
    [UIView animateWithDuration:0.3 animations:^{
        _scanBackView.alpha = 1.0;
        _scanImageView.frame = newRect;
    } completion:^(BOOL finished) {
        
        // 动画效果结束后  将其替身图片隐藏  替换成ZXHPicScanViewController的view
        _scanBackView.alpha = 0.0F;
        
        if (nil == _picScanVC) {
            
            if (nil == theImageURLArray) {
                // 注：currentPage 从0开始
                _picScanVC = [[ZXHPicScanViewController alloc] initWithTotalPageCount:theImageURLArray.count andCurrentPage:currPage andImageArray:[theOriginImageViewArray mutableCopy]];
                _picScanVC.delegate = self;
                
            } else {
                // 注：currentPage 从0开始
                _picScanVC = [[ZXHPicScanViewController alloc] initWithTotalPageCount:theImageURLArray.count andCurrentPage:currPage andImageURLArray:[theImageURLArray mutableCopy]];
                _picScanVC.delegate = self;
            }
        }
        [window addSubview:_picScanVC.view];
    }];
}

// 退出展示
- (void)disappearThisViewWithCurrentPage:(NSInteger)currPage {
    
    _picScanVC.view.alpha = 0;// 隐藏 picScanVC 的 View
    _scanBackView.alpha = 1.0F;// 显示替身图片 scanBackView
    
    // 获取 相对于window的原始位置
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIImageView *theImageView = self.originImageViewArr[currPage];
    
    CGRect rectToWindow = [theImageView convertRect:theImageView.bounds toView:window];
    
    CGRect oldRect = rectToWindow;
    
    _scanImageView.image = theImageView.image;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _scanBackView.alpha = 0.0;
        _scanImageView.frame = oldRect;
    } completion:^(BOOL finished) {
        [_scanBackView removeFromSuperview];
        
        [_picScanVC.view removeFromSuperview];
        _picScanVC = nil;
        
        if ([self.delegate respondsToSelector:@selector(disappearThePicScan)]) {
            [self.delegate disappearThePicScan];
        }
    }];
}

@end

