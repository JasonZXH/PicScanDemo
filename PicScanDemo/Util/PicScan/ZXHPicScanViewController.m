//
//  ZXHPicScanViewController.m
//  PicScanDemo
//
//  Created by ZXH on 15/5/14.
//  Copyright (c) 2015年 大毛集团. All rights reserved.
//

#import "ZXHPicScanViewController.h"
#import "UIImageView+WebCache.h"

#define IOS7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IMAGE_SCR_TAG_BEGIN     2000
#define IMAGE_VIEW_TAG_BEGIN    1234567

@interface ZXHPicScanViewController ()<UIScrollViewDelegate,UIAlertViewDelegate> {
    
    NSInteger window_Width;
    NSInteger window_Hight;
    
    NSInteger currPage;
    NSInteger totalImageCount;
    
    BOOL _isImage;
    BOOL _isImageURL;
    BOOL _willDisappear;
    
    UIPageControl *_pageControl;    
}
@property(nonatomic, strong)NSArray *imageViewArray;// 存放图片对象的数组
@property(nonatomic, strong)NSArray *imageUrlArray; // 存放image的URL

@property(nonatomic, strong)UIScrollView *bgBigScroll;// 存放小ScrollView的 大ScrollView

@end

@implementation ZXHPicScanViewController

- (void)dealloc {
    
    NSLog(@"PicScanViewController dealloc");
}

- (instancetype)initWithTotalPageCount:(NSInteger)theTotalPageCount
                        andCurrentPage:(NSInteger)theCurrentPage
                     andImageViewArray:(NSMutableArray *)theImageViewArray {
    
    if ((self = [super init])) {
        // 取宽、高
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window_Width = window.frame.size.width;
        window_Hight = window.frame.size.height;
        currPage = theCurrentPage;
        totalImageCount = theTotalPageCount;
        self.imageViewArray = [theImageViewArray copy];
        _isImage = YES;
        _isImageURL = NO;
        _willDisappear = NO;
    }
    return self;
}

- (instancetype)initWithTotalPageCount:(NSInteger)theTotalPageCount
                        andCurrentPage:(NSInteger)theCurrentPage
                      andImageURLArray:(NSMutableArray *)theImageURLArray {
    
    if ((self = [super init])) {
        // 取宽、高
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window_Width = window.frame.size.width;
        window_Hight = window.frame.size.height;
        currPage = theCurrentPage;
        totalImageCount = theTotalPageCount;
        self.imageUrlArray = [theImageURLArray copy];
        _isImageURL = YES;
        _isImage = NO;
        _willDisappear = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 创建大scrollview
    [self setupbgBigScrollView];
    // 创建存放图片的小scrollviewImageView
    [self setupScollviewImageView];
    // 创建工具条
    [self setupPageControl];
}

// 创建大scrollview
- (void)setupbgBigScrollView {
    // 设置scrollview的内容contentsize
    self.bgBigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     window_Width,
                                                                     window_Hight)];
    self.bgBigScroll.backgroundColor = [UIColor blackColor];
    self.bgBigScroll.contentSize = CGSizeMake(totalImageCount * window_Width,
                                              self.bgBigScroll.frame.size.height);
    self.bgBigScroll.contentOffset = CGPointMake(window_Width * currPage, 0);
    // 允许整屏翻动
    self.bgBigScroll.pagingEnabled = YES;
    // 设置代理对象
    self.bgBigScroll.delegate = self;
    [self.view addSubview:self.bgBigScroll];
}

+ (CGRect)calculateRectWithTheImage:(UIImage*)theImage {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat window_Width = window.bounds.size.width;
    CGFloat window_Height = window.bounds.size.height;
    
    CGRect theRect;
    
    CGFloat scaleX = window_Width / theImage.size.width;
    CGFloat scaleY = window_Height / theImage.size.height;
    if (scaleX > scaleY) {// 优先照顾Y轴
        
        CGFloat height = window_Height; // scaleY
        CGFloat width = scaleY * theImage.size.width;
        CGFloat x = (window_Width - width)/2;
        theRect = CGRectMake(x, 0, width, height);
    } else {
        CGFloat width = window_Width; // scaleX
        CGFloat height = scaleX * theImage.size.height;
        CGFloat y = (window_Height - height)/2;
        theRect = CGRectMake(0, y, width, height);
    }
    
    return theRect;
}

// 创建存放图片的小 Scrollview 和 ImageView
- (void)setupScollviewImageView {
    
    for(int i = 0; i < totalImageCount; i++) {
        UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0 + i * window_Width,
                                                                                   0,
                                                                                   window_Width,
                                                                                   window_Hight)];
        // 设置内容大小
        imageScroll.contentSize = CGSizeMake(window_Width, window_Hight);
        imageScroll.zoomScale = 1.0;
        // 设置scrollPictures的最大最小缩放比例
        imageScroll.maximumZoomScale = 2.0;
        imageScroll.minimumZoomScale = 1.0;
        imageScroll.bouncesZoom = YES;
        imageScroll.delegate = self;
        imageScroll.tag = IMAGE_SCR_TAG_BEGIN + i;
        [self.bgBigScroll addSubview:imageScroll];
        
        // 单击
        UITapGestureRecognizer *tapOnceGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleOnceClickAction:)];
        tapOnceGesture.numberOfTapsRequired = 1;
        [imageScroll addGestureRecognizer:tapOnceGesture];
        
        // 双击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleClickAction:)];
        tapGesture.numberOfTapsRequired = 2;
        [imageScroll addGestureRecognizer:tapGesture];
        
        // 关联 两个手势
        [tapOnceGesture requireGestureRecognizerToFail:tapGesture];
        
        
        // 传Image时
        if (_isImage) {
            
            UIImageView *theImageView = self.imageViewArray[i];
            UIImage *theImage = theImageView.image;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            
            imageView.image = theImage;
            
            imageView.frame = [ZXHPicScanViewController calculateRectWithTheImage:theImage];
            
            [imageScroll addSubview:imageView];
        }
        
        // 传Url时
        if (_isImageURL) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            
            NSURL *url = [NSURL URLWithString:self.imageUrlArray[i]];
            UIImage *image = [UIImage imageNamed:@"placeholderImage.png"];
            [imageView sd_setImageWithURL:url placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                imageView.frame = [ZXHPicScanViewController calculateRectWithTheImage:imageView.image];
            }];
            
            [imageScroll addSubview:imageView];
        }
    }
}

// 创建PageControl
- (void)setupPageControl {
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, window_Hight - 30, window_Width, 20)];
    
    _pageControl.numberOfPages = totalImageCount;
    _pageControl.currentPage = currPage;
    _pageControl.userInteractionEnabled = NO;
    [self.view addSubview:_pageControl];
}

// 单击手势响应的方法
-(void)handleOnceClickAction:(UIGestureRecognizer *)sender{
    
    _willDisappear = YES;
    UIScrollView *scrollView = (UIScrollView *)sender.view;
    
    if (scrollView.zoomScale != scrollView.minimumZoomScale) {
        [scrollView setZoomScale:1.0 animated:YES];
    } else {
        [self.delegate disappearThisViewWithCurrentPage:currPage];
    }
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    // 消失
    if (_willDisappear) {
        _willDisappear = NO;
        [self.delegate disappearThisViewWithCurrentPage:currPage];
    }
}

// 双击手势的响应方法
-(void)handleDoubleClickAction:(UIGestureRecognizer *)sender{
    UIScrollView *scrollView = (UIScrollView *)sender.view;
    if (scrollView.zoomScale == scrollView.minimumZoomScale) {
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
    }else{
        [scrollView setZoomScale:1.0 animated:YES];
    }
}

// 给图片添加缩放方法，允许缩放
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != self.bgBigScroll) {
        
        return scrollView.subviews.firstObject;// imageView
    }
    return nil;
}

// 图片缩放完成时触发的方法
// 代理方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView != self.bgBigScroll) {
        UIImageView *imageView = [scrollView.subviews firstObject];// 得到 imageView
        
        CGFloat x = 0;
        CGFloat y = 0;
        
        if (imageView.frame.size.width > self.bgBigScroll.frame.size.width) {
            x = imageView.frame.size.width / 2;
        } else {
            x = self.bgBigScroll.frame.size.width / 2;
        }
        
        if (imageView.frame.size.height > self.bgBigScroll.frame.size.height) {
            y = imageView.frame.size.height / 2;
        } else {
            y = self.bgBigScroll.frame.size.height / 2;
        }
        
        imageView.center = CGPointMake(x, y);
    }
}

// 完成拖拽的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 如果scrollView为大的scrollView时，则响应拖拽完成的方法，
    if (scrollView == self.bgBigScroll) {
        // 得到整屏偏移量的个数
        currPage = self.bgBigScroll.contentOffset.x / self.bgBigScroll.bounds.size.width;
        // 添加
        // 遍历scrollView上的子视图，得到UIScrollview类型的视图
        for (UIView* tempView in scrollView.subviews) {
            if ([tempView isKindOfClass:[UIScrollView class]]) {
                // 如果此时的视图不等于拖拽之后的视图，则把之前的视图缩放成原来的大小
                if (tempView != (UIScrollView *)[self.bgBigScroll viewWithTag:IMAGE_SCR_TAG_BEGIN + currPage]) {
                    
                    [(UIScrollView*)tempView setZoomScale:1.0 animated:YES];
                    
                    _pageControl.currentPage = currPage;
                }
            }
        }
    }
}


/************保存图片*******暂未用到*************/
// 保存图片到本地
- (void)saveBtnClick {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存照片" message:@"是否保存照片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 下标为1的就是确定，此时把图片保存到手机中
    if (buttonIndex == 1) {
        NSInteger index =( self.bgBigScroll.contentOffset.x )/ self.bgBigScroll.bounds.size.width;
        UIScrollView *scrollview = (UIScrollView *)[self.bgBigScroll viewWithTag:IMAGE_SCR_TAG_BEGIN + index];
        UIImageView *imageView = (UIImageView *)[[scrollview subviews]firstObject];
        //保存图片到手机中
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    //    [MessageShow showMessageView:0 code:1 msg:@"保存成功" autoClose:1 time:1];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MemoryWarningMemoryWarningMemoryWarningMemoryWarningMemoryWarningMemoryWarning");
}

@end
