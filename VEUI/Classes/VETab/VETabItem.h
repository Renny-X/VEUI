//
//  VETabItem.h
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VETabItem : UICollectionViewCell
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
 * 高亮 title 字体 默认为16
 */
@property(nonatomic, strong)UIFont *activeFont;
/**
 * 正常 title 字体 默认为16
 */
@property(nonatomic, strong)UIFont *inactiveFont;
/**
 * 选中进度 用来调整高亮和非高亮的变化
 */
@property(nonatomic, assign)CGFloat selectProgress;

@end

NS_ASSUME_NONNULL_END
