//
//  VETab.h
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "VETabItem.h"
#import "VETabProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VETabStyle) {
    VETabStyleDefault = 0,
    VETabStyleLineEqual,
};

@interface VETab : UIView

@property(nonatomic, assign, readonly)VETabStyle style;

@property(nonatomic, weak)id<VETabDelegate> delegate;
@property(nonatomic, weak)id<VETabDataSource> dataSource;
/**
 * tab 能否滚动 默认为NO
 */
@property(nonatomic, assign)BOOL tabScrollEnabled;
/**
 * content 能否滚动 默认为NO
 */
@property(nonatomic, assign)BOOL contentScrollEnabled;
/**
 * item 高度，剩余高度给subView，默认高度为40
 */
@property(nonatomic, assign)CGFloat itemHeight;
/**
 * 选中tab 下面的线条高度
 */
@property(nonatomic, assign)CGFloat lineHeight;
/**
 * tab 两边留空宽度
 */
@property(nonatomic, assign)CGFloat tabVerticalGap;
/**
 * tab tabItem 间隔
 */
@property(nonatomic, assign)CGFloat tabItemGap;
/**
 * tab 能否滚动 默认为NO
 */
@property(nonatomic, strong)UIColor *tabBarBackgroundColor;
/**
 * tab 能否滚动 默认为NO
 */
@property(nonatomic, strong)UIColor *contentBackgroundColor;

@property(nonatomic, assign, readonly)NSInteger selectedIndex;

- (instancetype)initWithStyle:(VETabStyle)style;

- (void)reloadTab;
- (void)forceReloadTab;

- (void)reloadContent;
- (void)forceReloadContent;

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

- (VETabItem *)tabItemAtIndex:(NSInteger)index;

// 子类使用
- (__kindof VETabItem *)tabItemAtIndex:(NSInteger)index withReuseIdentifier:(NSString *)identifier;

- (void)registerTabItemClass:(nullable Class)itemClass forItemWithReuseIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
