//
//  VETabContentView.h
//  VEUI_Example
//
//  Created by Coder on 2021/3/17.
//  Copyright © 2021 Coder. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VETabContentView : UIView

@property(nonatomic, copy)void (^clickBack)(BOOL begin);

@end

NS_ASSUME_NONNULL_END
