//
//  UIAlertController+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/6/29.
//

#import "UIAlertController+VEUI.h"
#import <objc/runtime.h>
#import "UIViewController+VEUI.h"

@implementation UIAlertController (VEUI)

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
     if (self.tintColor) {
       for (UIAlertAction *action in self.actions) {
           if (!action.textColor || action.style != UIAlertActionStyleDestructive) {
               action.textColor = self.tintColor;
           }
       }
   }
}

#pragma mark - tintColor
- (UIColor *)tintColor {
    return objc_getAssociatedObject(self, @selector(tintColor));
}

- (void)setTintColor:(UIColor *)tintColor {
    objc_setAssociatedObject(self, @selector(tintColor), tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - titleColor
- (UIColor *)titleColor {
    return objc_getAssociatedObject(self, @selector(titleColor));
}

- (void)setTitleColor:(UIColor *)titleColor {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        //标题颜色
        if ([ivarName isEqualToString:@"_attributedTitle"] && self.title && titleColor) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.title attributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}];
            [self setValue:attr forKey:@"attributedTitle"];
        }
    }
    free(ivars);
    objc_setAssociatedObject(self, @selector(titleColor), titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - messageColor
- (UIColor *)messageColor {
    return objc_getAssociatedObject(self, @selector(messageColor));
}

- (void)setMessageColor:(UIColor *)messageColor {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
    
        //描述颜色
        if ([ivarName isEqualToString:@"_attributedMessage"] && self.message && messageColor) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName:messageColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
            [self setValue:attr forKey:@"attributedMessage"];
        }
    }
    free(ivars);
    objc_setAssociatedObject(self, @selector(messageColor), messageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)showAlertWithTitle:(NSString * __nullable)title
                   message:(NSString * __nullable)message
                 leftTitle:(NSString * __nullable)leftTitle
            leftTitleColor:(UIColor * __nullable)leftTitleColor
                rightTitle:(NSString * __nullable)rightTitle
           rightTitleColor:(UIColor * __nullable)rightTitleColor
                leftAction:(void(^ __nullable)(void))leftAction
               rightAction:(void (^ __nullable)(void))rightAction {
    UIAlertController *alert = [self alertWithTitle:title
                                            message:message
                                          leftTitle:leftTitle
                                     leftTitleColor:leftTitleColor
                                         rightTitle:rightTitle
                                    rightTitleColor:rightTitleColor
                                         leftAction:leftAction
                                        rightAction:rightAction];
    [[UIViewController currentController] presentViewController:alert animated:YES completion:nil];
}

+ (UIAlertController *)alertWithTitle:(NSString * __nullable)title
                              message:(NSString * __nullable)message
                            leftTitle:(NSString * __nullable)leftTitle
                       leftTitleColor:(UIColor * __nullable)leftTitleColor
                           rightTitle:(NSString * __nullable)rightTitle
                      rightTitleColor:(UIColor * __nullable)rightTitleColor
                           leftAction:(void(^ __nullable)(void))leftAction
                          rightAction:(void (^ __nullable)(void))rightAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *left = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        return leftAction ? leftAction() : nil;
    }];
    if (leftTitleColor) {
        left.textColor = leftTitleColor;
    }
    [alert addAction:left];
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        return rightAction ? rightAction() : nil;
    }];
    if (rightTitleColor) {
        right.textColor = rightTitleColor;
    }
    [alert addAction:right];
    
    return alert;
}

@end

@implementation UIAlertAction (VEUI)

- (UIColor *)textColor {
    return objc_getAssociatedObject(self, @selector(textColor));
}

//按钮标题的字体颜色
- (void)setTextColor:(UIColor *)textColor {
    if (self.style == UIAlertActionStyleDestructive) {
        return;
    }
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
    for(int i =0;i < count;i ++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        if ([ivarName isEqualToString:@"_titleTextColor"]) {
            [self setValue:textColor forKey:@"titleTextColor"];
        }
    }
    free(ivars);
    objc_setAssociatedObject(self, @selector(textColor), textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
