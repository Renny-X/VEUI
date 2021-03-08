//
//  VESwitch.h
//  TestDemo
//
//  Created by Drake on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VESwitchClickBlock)(BOOL on);

@interface VESwitcher : UIView

@property(nullable, nonatomic, strong) UIColor *onTintColor;
@property(nullable, nonatomic, strong) UIColor *thumbTintColor;

@property(nullable, nonatomic, strong) UIImage *onImage;
@property(nullable, nonatomic, strong) UIImage *offImage;

@property(nonatomic,getter=isOn) BOOL on;
@property(nonatomic,copy)VESwitchClickBlock clickBlock;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

- (void)setSwitchFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
