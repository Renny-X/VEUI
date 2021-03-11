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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VEModel";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = @{
        @"title":@"this is title",
        @"subtitle":@"this is sub title",
        @"test":@"this is des",
        @"subModel":@{
                @"subtitle": @"this is subModel subTitle",
        },
    };
    VETestModel *model = [[VETestModel alloc] initWithDictionary:dict];
    NSLog(@"%@", model);
    NSLog(@"%@", model.subModel);
}

@end
