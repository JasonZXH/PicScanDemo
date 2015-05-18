//
//  ZXHPicScan.h
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 大毛集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZXHPicScanDelegate <NSObject>

- (void)disappearThePicScan;

@end

@interface ZXHPicScan : NSObject

@property(nonatomic, weak) id<ZXHPicScanDelegate>delegate;

/**
 *  currentPage 从0开始计算
 *  展示的图片是本地，或者已经下载完成，不需要网络下载
 *  @param currPage 当前要显示的图片在图集中是第几个
 *  @param theOriginImageViewArray 要展示的图片的imageVeiw数组
 */
- (void)showPicScanWithCurrentPage:(NSInteger)currPage andOriginImageViewArray:(NSArray *)theOriginImageViewArray;

/**
 *  currentPage 从0开始计算
 *  展示的图片需要通过网络下载
 *  @param currPage 当前点击的要显示的图片在图集中是第几个
 *  @param theOriginImageViewArray
 *  要展示的图片的imageVeiw数组(屏幕上的imageView，
 *  为了找到imageView在屏幕上的位置，实现 点哪个 就从哪个开始放大 的动画)
 *  @param theImageURLArray 要展示的图片的URL数组，
 */
- (void)showPicScanWithCurrentPage:(NSInteger)currPage andOriginImageViewArray:(NSArray*)theOriginImageViewArray andImageURLArray:(NSArray*)theImageURLArray;

@end
