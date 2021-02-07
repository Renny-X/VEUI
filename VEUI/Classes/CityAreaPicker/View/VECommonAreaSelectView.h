//
//  VECommonAreaSelectView.h
//  Vedeng
//
//  Created by Drake on 2020/11/3.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEProvinceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AShowBlock)(void);
typedef void(^ADismissBlock)(void);
typedef void(^AConfirmBlock)(NSArray <VEProvinceModel *> *currentProvinceArray);//点击确定返回所有选中的行号
typedef void(^AResetBlock)(NSArray <VEProvinceModel *>   *currentProvinceArray);//点击重置按钮
typedef void(^ACancelBlock)(NSArray <VEProvinceModel *>  *currentProvinceArray);//点击确定返回所有选中的行号

#pragma mark - <通用的> 省+市选中控件

@interface VECommonAreaSelectView : UIView

@property (nonatomic,copy) AShowBlock            showBlock;
@property (nonatomic,copy) ADismissBlock         dismissBlock;
@property (nonatomic,copy) AConfirmBlock         confirmBlock;
@property (nonatomic,copy) AResetBlock           resetBlock;
@property (nonatomic,copy) ACancelBlock          cancelBlock;

//显示带蒙层的view
- (void)showOverScreen:(CGFloat)contentHeight withAnimation:(BOOL)animation;

- (void)dismissWithAnimation:(BOOL)animation;

- (void)setRowHeight:(CGFloat)rowHeight;

- (void)reloadData:(NSArray <VEProvinceModel *>*)provinceArray;//省选中的市id在省model里一个id数组

- (void)selectProvinceIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
