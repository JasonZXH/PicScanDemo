//
//  RootCell.h
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 大毛集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RootCellDelegate <NSObject>

- (void)imageViewTouchEnlargeWithRow:(NSInteger)row andCurrentPage:(NSInteger)currPage andImageViewArray:(NSMutableArray*)theImageViewArray;

@end

@interface RootCell : UITableViewCell

@property(nonatomic, weak) id<RootCellDelegate>delegate;

- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row;

@end
