//
//  VEBanner.h
//  Pods
//
//  Created by Coder on 2021/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VEBanner;

@protocol VEBannerDelegate <NSObject>

@optional
- (void)vebanner:(VEBanner *)banner didScrollAtIndex:(NSInteger)index;

- (void)vebanner:(VEBanner *)banner didSelectAtIndex:(NSInteger)index;

@required
- (NSInteger)numberOfItemsForVEBanner:(VEBanner *)banner;

- (__kindof UIView *)vebanner:(VEBanner *)banner viewForItemAtIndex:(NSInteger)index;

@end

@interface VEBanner : UIView

@property(nonatomic, weak)id<VEBannerDelegate> delegate;
/**
 * 当前选中的index
 */
@property(nonatomic, assign)NSInteger selectIndex;
/**
 * 自动轮播 间隔时长，为0时 < 0.5时 不执行
 */
@property(nonatomic, assign)NSTimeInterval autoPlayTimeInterval;
/**
 * 循环滚动 默认为 true
 */
@property(nonatomic, assign)BOOL scrollCycled;

@property(nonatomic, assign)BOOL scrollEnabled;

@property(nonatomic, assign)BOOL showPageControl;

@property(nonatomic, assign)CGFloat pageControlBottomOffset;

@property(nonatomic, assign)UIColor *tintColor;
/**
 * 嵌套 当前响应手势后 禁用super scrollView的滚动，默认为 false
 */
@property(nonatomic, assign)BOOL disableSuperScrollViewEnabledWhenDragging;

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
