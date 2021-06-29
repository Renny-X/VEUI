//
//  UIAlertController+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (VEUI)

@property (nonatomic,strong) UIColor *tintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

+ (void)showAlertWithTitle:(NSString * __nullable)title message:(NSString * __nullable)message leftTitle:(NSString * __nullable)leftTitle leftTitleColor:(UIColor * __nullable)leftTitleColor rightTitle:(NSString * __nullable)rightTitle rightTitleColor:(UIColor * __nullable)rightTitleColor leftAction:(void(^ __nullable)(void))leftAction rightAction:(void (^ __nullable)(void))rightAction;

+ (UIAlertController *)alertWithTitle:(NSString * __nullable)title message:(NSString * __nullable)message leftTitle:(NSString * __nullable)leftTitle leftTitleColor:(UIColor * __nullable)leftTitleColor rightTitle:(NSString * __nullable)rightTitle rightTitleColor:(UIColor * __nullable)rightTitleColor leftAction:(void(^ __nullable)(void))leftAction rightAction:(void (^ __nullable)(void))rightAction;

@end

@interface UIAlertAction (VEUI)

@property (nonatomic,strong) UIColor *textColor; /**< 按钮title字体颜色 */

@end

NS_ASSUME_NONNULL_END
