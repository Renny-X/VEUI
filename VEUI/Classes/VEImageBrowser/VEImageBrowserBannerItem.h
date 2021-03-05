//
//  VEImageBrowserBannerItem.h
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VEImageBrowserBannerItem;
@protocol VEImageBrowserBannerItemDelegate <NSObject>

@optional
// 单击
- (void)bannerItemOnSingleTap;
// dismiss
- (void)bannerItemShouldDismiss;
// set superView alpha && contentView frame
- (void)bannerItemShouldChangeSuperAlpha:(CGFloat)alpha inContentFrame:(CGRect)frame;

@end

@interface VEImageBrowserBannerItem : UIView

@property(nonatomic, weak)id<VEImageBrowserBannerItemDelegate> delegate;

@property(nonatomic, assign)BOOL canZoomIn;

- (instancetype)initWithContentView:(UIView *)contentView;

@end

NS_ASSUME_NONNULL_END
