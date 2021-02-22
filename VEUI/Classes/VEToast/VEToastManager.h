//
//  VEToastManager.h
//  VEUI
//
//  Created by Coder on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEToastManager : NSObject

@property(nonatomic, assign)NSTimeInterval animateDuration;
@property(nonatomic, assign)NSTimeInterval duration;
@property(nonatomic, assign)CGSize imgSize;
@property(nonatomic, assign)CGFloat textFont;
@property(nonatomic, strong)UIColor *toastColor;
@property(nonatomic, strong)UIColor *tintColor;

+ (instancetype)manager;

- (void)show:(UIView *)view duration:(NSTimeInterval)duration;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
