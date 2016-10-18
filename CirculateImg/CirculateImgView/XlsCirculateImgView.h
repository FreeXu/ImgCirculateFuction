//
//  XlsCirculateImgView.h
//  CirculateImg
//
//  Created by 56tg on 2016/10/17.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KHSourceType){
    KHSourceInternetType = 0,
    KHSourceLocalType = 1
};

typedef NS_ENUM(NSInteger, KHScrollDirection){
    KHScrollDirectionFromRight = 0,
    KHScrollDirectionFromLeft = 1
};

@protocol XlsCirculateImgViewDelegate <NSObject>

@optional
- (void)contentWhenSelectView:(id)content andSourceType:(KHSourceType)type;

@end

@interface XlsCirculateImgView : UIView

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) UIColor *bottomViewColor;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, assign) CGFloat bottomViewHeight;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) BOOL hideBottomView;
@property (nonatomic, assign) BOOL hidePageControl;
@property (nonatomic, assign) BOOL isAutoCircle;
/** Scroll Direction */
@property (nonatomic, assign) KHScrollDirection direction;
@property (nonatomic, weak) id<XlsCirculateImgViewDelegate> delegate;

- (void)setDataSource:(NSArray<NSString *> *)dataSource WithSourceType:(KHSourceType)sourceType;

- (void)invalidateTimer;

@end
