//
//  VETabItem.h
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VETabItem : UICollectionViewCell

@property(nonatomic, strong, readonly)UILabel *label;
/**
 * tabitem标题
 */
@property(nonatomic, strong)NSString *title;
/**
 * 正常颜色
 */
@property(nonatomic, strong)UIColor *inactiveColor;
/**
 * 高亮颜色
 */
@property(nonatomic, strong)UIColor *activeColor;
/**
 * 字体名称
 */
@property(nonatomic, strong)NSString *fontName;
/**
 * 高亮 title 字体 默认为16
 */
@property(nonatomic, assign)CGFloat activeFontSize;
/**
 * 正常 title 字体 默认为16
 */
@property(nonatomic, assign)CGFloat inactiveFontSize;
/**
 * 选中进度 用来调整高亮和非高亮的变化
 */
@property(nonatomic, assign)CGFloat selectProgress;
/**
 * 文字标题宽度 用于给线条设置宽度
 */
@property(nonatomic, assign, readonly)CGFloat textWidth;

@end

NS_ASSUME_NONNULL_END
