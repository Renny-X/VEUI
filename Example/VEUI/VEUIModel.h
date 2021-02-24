//
//  VEUIModel.h
//  VEUI_Example
//
//  Created by Coder on 2021/2/23.
//  Copyright © 2021 Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - VEUI Cell Model
@interface VEUICellModel : NSObject

@property(nonatomic, strong)NSString *title;

@property(nonatomic, strong)UIViewController *controller;

+ (instancetype)modelWithTitle:(NSString *)title controller:(UIViewController *)vc;

@end

#pragma mark - VEUI Group Model
@interface VEUIGroupModel : NSObject

@property(nonatomic, strong)NSString *title;

@property(nonatomic, strong)NSArray<VEUICellModel *> *cellArr;

+ (instancetype)modelWithTitle:(NSString *)title cellArr:(NSArray<VEUICellModel *> *)cellArr;

@end

NS_ASSUME_NONNULL_END
