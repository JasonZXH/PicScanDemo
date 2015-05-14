![http://teacher.3xy.com.cn/sxyAdminData/images/resource/jpg/200805/200805201507101075.jpg]
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

......
- (void)xxxxxxxx {
    ..........
    if (nil == _zxhPicScan) {
        _zxhPicScan = [[ZXHPicScan alloc] init];
        _zxhPicScan.delegate = self;
    }
    [_zxhPicScan showPicScanWithCurrentPage:currPage andOriginImageViewArray:[theImageViewArray copy] andImageURLArray:imageURLArr];
    ............
}
- (void)disappearThePicScan {
    _zxhPicScan = nil;
}
```
