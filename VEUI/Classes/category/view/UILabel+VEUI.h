//
//  UILabel+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (VEUI)

/**
 * 两端对齐
 */
- (void)textAlignmentLeftAndRight;
/**
 * 指定Label以最后的冒号对齐的width两端对齐
 */
- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;

@end

NS_ASSUME_NONNULL_END
