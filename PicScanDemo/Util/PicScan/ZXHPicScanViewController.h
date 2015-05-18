//
//  ZXHPicScanViewController.h
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 大毛集团. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  此类为内部调用
 */

@protocol ZXHPicScanViewControllerDelegate <NSObject>

- (void)disappearThisViewWithCurrentPage:(NSInteger)currPage;

@end

@interface ZXHPicScanViewController : UIViewController

@property(nonatomic, weak) id<ZXHPicScanViewControllerDelegate>delegate;

+ (CGRect)calculateRectWithTheImage:(UIImage*)theImage;

// currentPage从0开始
- (instancetype)initWithTotalPageCount:(NSInteger)theTotalPageCount andCurrentPage:(NSInteger)theCurrentPage andImageViewArray:(NSMutableArray*)theImageViewArray;

- (instancetype)initWithTotalPageCount:(NSInteger)theTotalPageCount andCurrentPage:(NSInteger)theCurrentPage andImageURLArray:(NSMutableArray*)theImageURLArray;


@end
