//
//  RootViewController.m
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 大毛集团. All rights reserved.
//

#import "RootViewController.h"
#import "RootCell.h"
#import "ZXHPicScan.h"

#define BACK_COLOR      [UIColor colorWithRed:239/255.0F green:243/255.0F blue:241/255.0F alpha:1.0F]
/**
 *  用法:
 *  #import "RootCell.h"
 *
 *  @interface RootViewController () <ZXHPicScanDelegate> {
 *
 *      ZXHPicScan *_zxhPicScan;
 *  }
 *
 *  调用方法参见 90--103 行代码
 *
 *
 */
@interface RootViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
RootCellDelegate,
ZXHPicScanDelegate
>
{
    ZXHPicScan *_zxhPicScan;
}

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataListArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"图片浏览";

    [self loadData];
    [self loadSubviews];
}

- (void)loadSubviews {
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[RootCell class] forCellReuseIdentifier:@"RootCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat kWindow_Width = window.bounds.size.width;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindow_Width, 100)];
    self.tableView.tableHeaderView = headView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWindow_Width - 80)/2, 20, 80, 60)];
    imageView.image = [UIImage imageNamed:@"E.jpg"];
    imageView.userInteractionEnabled = YES;
    [headView addSubview:imageView];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)sender {
 
/*******  调用方法方法1 **********/
    // 点击放大查看本地图片，不需要进行网络请求
    UIImageView *imageView = (UIImageView*)sender.view;
    if (nil == _zxhPicScan) {
        _zxhPicScan = [[ZXHPicScan alloc] init];
        _zxhPicScan.delegate = self;
    }
    [_zxhPicScan showPicScanWithCurrentPage:0 andOriginImageViewArray:@[imageView]];

}
/*******************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TalkingListCellDelegate
- (void)imageViewTouchEnlargeWithRow:(NSInteger)row
                      andCurrentPage:(NSInteger)currPage
                   andImageViewArray:(NSMutableArray *)theImageViewArray {
    
    
    NSArray *imageURLArr = [[NSArray alloc] initWithArray:self.dataListArray[row][@"pic"]];
/*******  调用方法方法2 **********/
    // 点击放大查看，需要网络请求，传URL
    if (nil == _zxhPicScan) {
        _zxhPicScan = [[ZXHPicScan alloc] init];
        _zxhPicScan.delegate = self;
    }
    [_zxhPicScan showPicScanWithCurrentPage:currPage
                    andOriginImageViewArray:[theImageViewArray copy]
                           andImageURLArray:imageURLArr];
}

#pragma mark - ZXHPicScanDelegate
- (void)disappearThePicScan {
    if (_zxhPicScan) {
        _zxhPicScan = nil;
    }
}
/*******************************/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    RootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BACK_COLOR;
    NSDictionary *dic = [self.dataListArray objectAtIndex:row];
    [cell reloadCellSubViewsWithData:dic forRow:row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSDictionary *dataDic = [self.dataListArray objectAtIndex:row];
    
    CGFloat size_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat kImageWidth = ((size_width - 20) - 10*4) / 3;      // 图片宽度
    
    // 图片个数
    NSInteger imageCount = [dataDic[@"pic"] count];
    
    // 图片行数
    NSInteger imageLineCount = 0 != imageCount%3 ? (imageCount / 3 + 1) : imageCount / 3;

    // 图片占用高度
    CGFloat imageTotalHeight = (kImageWidth + 10) * imageLineCount;
    
    return  5 + imageTotalHeight + 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)loadData {
    
    self.dataListArray = @[@{@"pic" : @[@"http://121.199.38.85/houseclient/uploads/say/user_50/2015041511/552dd8fd8453b.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041511/552dd8fd84697.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041511/552dd8fd84745.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041511/552dd8fd8480a.png",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041511/552dd8fd848c7.png"]
                             },
                           @{@"pic" : @[@"http://121.199.38.85/houseclient/uploads/say/user_50/2015041309/552b1ba3cf8f1.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041309/552b1ba3cf9fd.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041309/552b1ba3cfac8.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041309/552b1ba3cfb78.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041309/552b1ba3cfc1e.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041309/552b1ba3cfcb9.jpg"]
                             },
                           @{@"pic" : @[@"http://121.199.38.85/houseclient/uploads/say/user_50/2015041018/5527ab6b2e92f.png",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041018/5527ab6b2ea97.png",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041018/5527ab6b2ebb5.png",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041018/5527ab6b2ec7d.png",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041018/5527ab6b2ed3c.png",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_50/2015041018/5527ab6b2edfb.png"]
                             },
                           @{@"pic" : @[@"http://121.199.38.85/houseclient/uploads/say/user_46/2015041015/55277e2f837a2.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_46/2015041015/55277e2f838d9.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_46/2015041015/55277e2f83970.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_46/2015041015/55277e2f83a14.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_46/2015041015/55277e2f83a9b.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_46/2015041015/55277e2f83b1c.jpg"]
                             },
                           @{@"pic" : @[@"http://121.199.38.85/houseclient/uploads/say/user_1/2015032115/550d1c5262120.jpeg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015032115/550d1c526220e.jpeg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015032115/550d1c52622d7.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015032115/550d1c526239d.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015032115/550d1c526245c.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015032115/550d1c5262514.jpg"]
                             },
                           
                           @{@"pic" : @[@"http://121.199.38.85/houseclient/uploads/say/user_1/2015031011/54fe622e2fd74.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015031011/54fe622e2fe5c.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015031011/54fe622e2feea.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015031011/54fe622e2ff71.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015031011/54fe622e30007.jpg",
                                        @"http://121.199.38.85/houseclient/uploads/say/user_1/2015031011/54fe622e3008a.jpg"]
                             },
                           ];
}

@end
