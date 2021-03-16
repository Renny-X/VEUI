//
//  VETestModel.h
//  VEUI_Example
//
//  Created by Coder on 2021/3/9.
//  Copyright © 2021 Coder. All rights reserved.
//

#import <VEUI/VEUI.h>
#import "VETestSubModel.h"
#import "VETestSonSubModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VETestModel : VEModel

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subTitle;
@property(nonatomic, strong)NSString *des;

@property(nonatomic, strong)VETestSubModel *subModel;
@property(nonatomic, strong)VETestSonSubModel *sonModel;

@property(nonatomic, strong)NSArray<VETestSubModel *> *dataArr;

@end

NS_ASSUME_NONNULL_END
