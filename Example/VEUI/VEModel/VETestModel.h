//
//  VETestModel.h
//  VEUI_Example
//
//  Created by Coder on 2021/3/9.
//  Copyright © 2021 Coder. All rights reserved.
//

#import <VEUI/VEUI.h>
#import "VETestSubModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VETestModel : VEModel

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subTitle;
@property(nonatomic, strong)NSString *des;

@property(nonatomic, strong)VETestSubModel *subModel;

@end

NS_ASSUME_NONNULL_END
