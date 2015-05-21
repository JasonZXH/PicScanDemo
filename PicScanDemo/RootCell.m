//
//  RootCell.m
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 大毛集团. All rights reserved.
//

#import "RootCell.h"
#import "UIImageView+WebCache.h"

@interface RootCell ()

@property(nonatomic, strong) UIView *backView;
@property(nonatomic, strong) UIView *lineView;

@property(nonatomic, strong) NSMutableArray *imageArr;

@end

@implementation RootCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageArr = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadCellSubViews];
    }
    return self;
}

// Reload cell with data
- (void)reloadCellSubViewsWithData:(NSDictionary *)dataDic forRow:(NSInteger)row {
//    _sayID = dataDic[@"say_id"];
//    _row = row;
    
    CGFloat size_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat kImageWidth = ((size_width - 20) - 10*4) / 3;      // 图片宽度
    // 图片
    NSArray *picArr = dataDic[@"pic"];
    
    NSInteger imageCount = picArr.count;
    
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = self.imageArr[i];
        if (imageCount > i) {
            imageView.hidden = NO;
            
            imageView.frame = CGRectMake(10 + i % 3 * (kImageWidth + 10),
                                         10 + i/3*(kImageWidth + 10),
                                         kImageWidth,
                                         kImageWidth);
            
            imageView.tag = (row + 1) * 10000 + i;
            imageView.image = nil;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:picArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
        } else {
            imageView.image = nil;
            imageView.hidden = YES;
        }
    }
    
    // 图片行数
    NSInteger imageLineCount = 0 != imageCount%3 ? (imageCount / 3 + 1) : imageCount / 3;

    self.backView.frame = CGRectMake(10, 5, size_width - 20, (kImageWidth + 10) * imageLineCount);

    // 底部 横线
    self.lineView.frame = CGRectMake(10,
                                     self.backView.frame.origin.y + self.backView.frame.size.height + 4.5,
                                     size_width - 20,
                                     0.5);
    
}

- (void)loadCellSubViews {
    // Back View
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:1] CGColor];
    self.backView.layer.borderWidth = 0.3;
    [self.contentView addSubview:self.backView];
    
    // 图片
    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageArr addObject:imageView];
        [self.backView addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *enlargeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEnlarge:)];
        [imageView addGestureRecognizer:enlargeTap];
    }
    
    // 底部 横线
    self.lineView = [[UIView alloc] init];
    //    self.lineView.backgroundColor = [UIColor redColor];
    [self.backView addSubview:self.lineView];
}

- (void)touchEnlarge:(UITapGestureRecognizer*)tap {
    NSInteger tag = tap.view.tag;
    NSInteger row = tag / 10000 - 1;
    NSInteger currPage = tag % 10000;
    
    [self.delegate imageViewTouchEnlargeWithRow:row andCurrentPage:currPage andImageViewArray:self.imageArr];
    
    NSLog(@"row = %ld, currPage = %ld", (long)row, (long)currPage);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
