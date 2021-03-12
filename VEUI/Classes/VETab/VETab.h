//
//  VETab.h
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "VETabItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VETabDelegate <NSObject>

@optional
/**
 * 返回 VETabItem 子类 用于自定义tabItem样式，返回nil时使用默认item
 */
- (VETabItem *)tabItemAtIndex:(NSInteger)index title:(NSString *)title tabItem:(VETabItem *)tabItem;
/**
 * 返回 tabItem 宽度，== 0 时，返回默认宽度 60
 */
- (CGFloat)tabItemWidthAtIndex:(NSInteger)index title:(NSString *)title;
/**
 * 返回 tabItem 关联的subView，nil时 返回默认页面
 */
- (UIView *)tabContentViewAtIndex:(NSInteger)index;

- (void)didSelectAtIndex:(NSInteger)index;

@end

@interface VETab : UIView

@property(nonatomic, weak)id<VETabDelegate> delegate;
/**
 * tab 能否滚动 默认为NO
 */
@property(nonatomic, assign)BOOL tabScrollEnable;
/**
 * content 能否滚动 默认为NO
 */
@property(nonatomic, assign)BOOL contentScrollEnable;
/**
 * 高亮颜色 默认 #0099ff
 */
@property(nonatomic, strong)UIColor *activeColor;
/**
 * 正常颜色 默认 #000000
 */
@property(nonatomic, strong)UIColor *inactiveColor;
/**
 * item 高度，剩余高度给subView，默认高度为40
 */
@property(nonatomic, assign)CGFloat itemHeight;
/**
 * title font 默认为16
 */
@property(nonatomic, strong)UIFont *titleFont;

@property(nonatomic, assign, readonly)NSInteger selectedIndex;

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles contentViews:(NSArray<UIView *> * __nullable)contentViews;

- (void)reloadTab;
- (void)reloadContent;

- (void)setSelectedIndex:(NSInteger)selectedIndex animate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
