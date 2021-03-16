//
//  VEModelController.m
//  VEUI_Example
//
//  Created by Coder on 2021/3/9.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEModelController.h"
#import "VETestModel.h"

@interface VEModelController ()

@end

@implementation VEModelController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *dict = @{
        @"title":@"this is title",
        @"subtitle":@"this is sub title",
        @"test":@"this is des",
        @"subModel":@{
            @"subtitle": @"this is subModel subTitle",
            @"son": @"son",
        },
        @"sonModel":@{
            @"subtitle": @"this is subModel subTitle",
            @"son": @"son",
        },
        @"dataArr":@[
            @{
                @"subtitle": @"this is subModel subTitle",
                @"son": @"son",
            }, @{
                @"subtitle": @"this is subModel subTitle",
                @"son": @"son",
            }, @{
                @"subtitle": @"this is subModel subTitle",
                @"son": @"son",
            },
        ]
    };
    VETestModel *model = [[VETestModel alloc] initWithDictionary:dict];
    NSLog(@"========================================\n%@", model);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VEModel";
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
