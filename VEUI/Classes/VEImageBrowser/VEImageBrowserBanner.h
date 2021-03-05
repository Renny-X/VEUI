//
//  VEImageBrowserBanner.h
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import <UIKit/UIKit.h>
#import "VEBanner.h"

NS_ASSUME_NONNULL_BEGIN

@class VEImageBrowserBanner;
@protocol VEImageBrowserBannerDelegate <NSObject>

@optional
// 单击
- (void)bannerOnSingleTap;
// dismiss
- (void)bannerShouldDismiss;
// set superView alpha
- (void)bannerShouldChangeSuperAlpha:(CGFloat)alpha inContentFrame:(CGRect)frame;

@end

@interface VEImageBrowserBanner : UIView

@property(nonatomic, weak)id<VEImageBrowserBannerDelegate> delegate;

@property(nonatomic, strong)VEBanner *banner;

- (instancetype)initWithDataSource:(NSArray<UIView *> *)dataSource;

- (instancetype)initWithDataSource:(NSArray<UIView *> *)dataSource selectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
