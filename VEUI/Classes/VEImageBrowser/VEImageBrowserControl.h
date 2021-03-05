//
//  VEImageBrowserControl.h
//  VEUI
//
//  Created by Coder on 2021/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VEImageBrowserControlBtnType) {
    VEImageBrowserControlBtnTypeClose = 0,
    VEImageBrowserControlBtnTypeMore,
};

@protocol VEImageBrowserControlDelegate <NSObject>

@optional
- (void)funcBtnClicked:(VEImageBrowserControlBtnType)btnType;

@end

@interface VEImageBrowserControl : UIView

@property(nonatomic, weak)id<VEImageBrowserControlDelegate> delegate;

@property(nonatomic, strong)UIColor *tintColor;
@property(nonatomic, strong)UIColor *coverColor;

@property(nonatomic, assign)BOOL showHeaderRightBtn;
@property(nonatomic, strong)UIImage *headerRightBtnImage;

- (instancetype)initWithTintColor:(UIColor *)tintColor;

- (instancetype)initWithTintColor:(UIColor *)tintColor coverColor:(UIColor *)coverColor;

- (void)show:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
