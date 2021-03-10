//
//  VETabItem.h
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VETabItemStyle) {
    VETabItemStyleDefault = 0, // 默认效果 选中文字高亮
    VETabItemStyleShortLine, // 高亮文字下方 显示与文字等宽的线条
    VETabItemStyleFullLine, // 高亮文字下方 显示与点击区域等宽的线条
};

@interface VETabItem : UICollectionViewCell
/**
 * tabItem 样式
 */
@property(nonatomic, assign)VETabItemStyle style;
/**
 * tabitem标题
 */
@property(nonatomic, strong)NSString *title;
/**
 * 高亮颜色
 */
@property(nonatomic, strong)UIColor *activeColor;
/**
 * 正常颜色
 */
@property(nonatomic, strong)UIColor *inactiveColor;
/**
 * title font 默认为16
 */
@property(nonatomic, strong)UIFont *titleFont;

@property(nonatomic, assign)CGFloat lineHeight;

@end

NS_ASSUME_NONNULL_END
