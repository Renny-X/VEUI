//
//  UITabBarItem+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (VEUI)

/**
 * 小红点颜色
 */
@property(nonatomic, strong)UIColor *badgeDotColor;
/**
 * 小红点宽度
 */
@property(nonatomic, assign)CGFloat badgeDotWidth;
/**
 * 小红点是否显示，badgeValue 不为nil 时 设置无效
 */
@property(nonatomic, assign)BOOL showBadgeDot;

/**
 * 仅支持选中状态的 tabBarItem
 * @param images 序列帧动画图集
 * @param duration 动画时长
 */
- (void)animateWithImages:(NSArray<UIImage *> *)images duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
