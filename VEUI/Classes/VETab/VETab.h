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

@property(nonatomic, assign, readonly)NSInteger selectedIndex;

- (instancetype)initWithStyle:(VETabStyle)style;

- (void)reloadTab;
- (void)reloadContent;

- (void)setSelectedIndex:(NSInteger)selectedIndex animate:(BOOL)animate;

- (VETabItem *)tabItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
