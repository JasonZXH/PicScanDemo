![Alt Text](https://github.com/JasonZXH/PicScanDemo/blob/master/ppppp.gif?raw=true)
# Usage
1、copy 
ZXHPicScan.h
ZXHPicScan.m
ZXHPicScanViewController.h
ZXHPicScanViewController.m
2、Add the following import to the top of the file:
```
#import "ZXHPicScan.h"
@interface RootViewController ()<ZXHPicScanDelegate>
{
    ZXHPicScan *_zxhPicScan;
}

- (void)xxxxx {

    if (nil == _zxhPicScan) {
        _zxhPicScan = [[ZXHPicScan alloc] init];
        _zxhPicScan.delegate = self;
    }
/**
 *  <浏览的图片是本地，或者已经下载完成，不需要网络下载>
 *  currentPage 从0开始计算
 *  @param currPage 当前要显示的图片在图集中是第几个
 *  @param theOriginImageViewArray 将要展示的图片的imageVeiw数组
 */
    [_zxhPicScan showPicScanWithCurrentPage:0 andOriginImageViewArray:@[imageView]];
}

- (void)xxxxxxxx {

    if (nil == _zxhPicScan) {
        _zxhPicScan = [[ZXHPicScan alloc] init];
        _zxhPicScan.delegate = self;
    }
/**
 *  <浏览的图片需要通过网络下载>
 *  currentPage 从0开始计算
 *  @param currPage 当前点击的要显示的图片在图集中是第几个
 *  @param theOriginImageViewArray 要展示的图片的imageVeiw数组(屏幕上的imageView，
 *         为了找到imageView在屏幕上的位置，实现 点哪个 就从哪个开始放大 的动画)
 *  @param theImageURLArray 要展示的图片的URL数组，
 */
    [_zxhPicScan showPicScanWithCurrentPage:currPage andOriginImageViewArray:[theImageViewArray copy] andImageURLArray:imageURLArr];
}

#pragma mark - ZXHPicScanDelegate 
- (void)disappearThePicScan {
    _zxhPicScan = nil;
}
```
