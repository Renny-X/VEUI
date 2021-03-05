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
- (void)didScrollAtIndex:(NSInteger)index;

@end

@interface VEBanner : UIView

@property(nonatomic, strong)NSArray<UIView *> *dataSource;

@property(nonatomic, weak)id<VEBannerDelegate> delegate;

@property(nonatomic, assign)NSInteger selectIndex;

@property(nonatomic, assign)BOOL scrollEnabled;

@property(nonatomic, assign)BOOL showPageControl;

@property(nonatomic, assign)UIColor *tintColor;

@property(nonatomic, assign)BOOL disableSuperScrollViewEnabledWhenDragging;

- (instancetype)initWithDataSource:(NSArray<UIView *> *)dataSource;

- (instancetype)initWithFrame:(CGRect)frame DataSource:(NSArray<UIView *> *)dataSource;

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
