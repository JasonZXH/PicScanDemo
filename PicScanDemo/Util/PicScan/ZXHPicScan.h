//
//  ZXHPicScan.h
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZXHPicScanDelegate <NSObject>

- (void)disappearThePicScan;

@end

@interface ZXHPicScan : NSObject

@property(nonatomic, weak) id<ZXHPicScanDelegate>delegate;

- (void)showPicScanWithCurrentPage:(NSInteger)currPage andOriginImageViewArray:(NSArray *)theOriginImageViewArray;

- (void)showPicScanWithCurrentPage:(NSInteger)currPage andOriginImageViewArray:(NSArray*)theOriginImageViewArray andImageURLArray:(NSArray*)theImageURLArray;

@end
