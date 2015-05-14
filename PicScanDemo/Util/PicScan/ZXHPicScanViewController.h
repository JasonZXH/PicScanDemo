//
//  ZXHPicScanViewController.h
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXHPicScanViewControllerDelegate <NSObject>

- (void)disappearThisViewWithCurrentPage:(NSInteger)currPage;

@end

@interface ZXHPicScanViewController : UIViewController

@property(nonatomic, weak) id<ZXHPicScanViewControllerDelegate>delegate;

+ (CGRect)calculateRectWithTheImage:(UIImage*)theImage;

// currentPage从0开始
- (instancetype)initWithTotalPageCount:(NSInteger)theTotalPageCount andCurrentPage:(NSInteger)theCurrentPage andImageArray:(NSMutableArray*)theImageArray;

- (instancetype)initWithTotalPageCount:(NSInteger)theTotalPageCount andCurrentPage:(NSInteger)theCurrentPage andImageURLArray:(NSMutableArray*)theImageURLArray;


@end
