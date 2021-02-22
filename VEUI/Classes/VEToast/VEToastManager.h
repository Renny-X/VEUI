//
//  VEToastManager.h
//  VEUI
//
//  Created by Coder on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEToastManager : NSObject

@property(nonatomic, assign)CGFloat duration;

+ (instancetype)manager;

- (void)show:(UIView *)view toView:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
