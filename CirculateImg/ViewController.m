//
//  ViewController.m
//  CirculateImg
//
//  Created by 56tg on 2016/10/17.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import "ViewController.h"
#import "XlsCirculateImgView.h"

#define kInterfaceOne @"http://imgsrc.baidu.com/forum/w%3D580/sign=6b99730dbb0e7bec23da03e91f2fb9fa/3c2beea20cf431ad9977243b4836acaf2fdd98a3.jpg"
#define kInterfaceTwo @"http://imgsrc.baidu.com/forum/w%3D580/sign=01924beabf3eb13544c7b7b3961fa8cb/032df513495409235ccc047c9158d109b2de49a3.jpg"
#define kInterfaceThree @"http://imgsrc.baidu.com/forum/w%3D580/sign=af757c4188d4b31cf03c94b3b7d7276f/041e87014a90f6039615fb453a12b31bb151edac.jpg"
#define kInterfaceFour @"http://imgsrc.baidu.com/forum/w%3D580/sign=e9917a0a1c30e924cfa49c397c096e66/7685b818367adab4a4747c4188d4b31c8601e4ad.jpg"
#define kInterfaceFive @"http://imgsrc.baidu.com/forum/w%3D580/sign=f99dafc8ac51f3dec3b2b96ca4eff0ec/b84d112eb9389b502b4987508635e5dde6116e9e.jpg"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XlsCirculateImgView *view = [[XlsCirculateImgView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
    NSArray *urlArr = @[kInterfaceOne, kInterfaceTwo];
    [view setDataSource:urlArr WithSourceType:KHSourceInternetType];
    [self.view addSubview:view];
    view.timeInterval = 3.f;
    view.isAutoCircle = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
