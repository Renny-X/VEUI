//
//  VETabProtocol.h
//  VEUI
//
//  Created by Coder on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VEUI/VEUI.h>

NS_ASSUME_NONNULL_BEGIN

@class VETab, VETabItem, VETabContentItem;

@protocol VETabDelegate <NSObject>

@optional

- (void)didSelectAtIndex:(NSInteger)index;

@end



@protocol VETabDataSource <NSObject>

/**
 * 返回 tabItem 总数，默认 0
 */
- (NSInteger)numberOfTabItems;
/**
 * 返回 tabItem 宽度，== 0 时，返回默认宽度 60
 */
- (CGFloat)tab:(VETab *)tab tabItemWidthAtIndex:(NSInteger)index;
/**
 * 返回 VETabItem 用于自定义tabItem样式，返回nil时使用默认item
 */
- (__kindof VETabItem *)tab:(VETab *)tab tabItemAtIndex:(NSInteger)index;

@optional
/**
 * 返回 tabItem 关联的subView，nil时 返回默认页面
 */
- (UIView * _Nullable)tab:(VETab *)tab contentViewAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
