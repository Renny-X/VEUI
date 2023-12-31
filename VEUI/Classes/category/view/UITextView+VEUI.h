//
//  UITextView+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (VEUI)

/**
 * maxLength: 最大输入长度
 */
@property(nonatomic, assign)NSInteger maxLength;

@property(nonatomic, copy)void(^textDidChange)(void);

@end

NS_ASSUME_NONNULL_END
