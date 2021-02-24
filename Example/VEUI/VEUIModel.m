//
//  VEUIModel.m
//  VEUI_Example
//
//  Created by Coder on 2021/2/23.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEUIModel.h"

@implementation VEUICellModel

+ (instancetype)modelWithTitle:(NSString *)title controller:(UIViewController *)vc {
    return [[VEUICellModel alloc] initWithTitle:title controller:vc];
}

- (instancetype)initWithTitle:(NSString *)title controller:(UIViewController *)vc {
    if (self = [super init]) {
        self.title = title;
        self.controller = vc;
    }
    return self;
}

@end

@implementation VEUIGroupModel

+ (instancetype)modelWithTitle:(NSString *)title cellArr:(NSArray<VEUICellModel *> *)cellArr {
    return [[VEUIGroupModel alloc] initWithTitle:title cellArr:cellArr];
}

- (instancetype)initWithTitle:(NSString *)title cellArr:(NSArray<VEUICellModel *> *)cellArr {
    if (self = [super init]) {
        self.title = title;
        self.cellArr = [NSArray arrayWithArray:cellArr];
    }
    return self;
}

@end
