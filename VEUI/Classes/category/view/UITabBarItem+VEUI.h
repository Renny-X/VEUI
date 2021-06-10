//
//  UITabBarItem+VEUI.h
//  VEUI
//
//  Created by Coder on 2021/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (VEUI)

@property(nonatomic, strong)UIColor *badgeDotColor;
@property(nonatomic, assign)CGFloat badgeDotWidth;
@property(nonatomic, assign)BOOL showBadgeDot;

@end

NS_ASSUME_NONNULL_END
