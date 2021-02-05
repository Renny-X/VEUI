//
//  VECommonSelectView.h
//  Vedeng
//
//  Created by Drake on 2020/11/3.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CShowBlock)(void);
typedef void(^CDismissBlock)(void);
typedef void(^CSelectBlock)(NSInteger selectIndex);
typedef void(^CConfirmBlock)(NSArray <NSString *>   *selectedIndexArray);//点击确定返回所有选中的行号
typedef void(^CCancelBlock)(NSArray <NSString *>    *originalSelectedIndexArray);//点击确定返回所有选中的行号

#pragma mark - <通用的> 单行选择 左侧单行文字+右侧选择圆圈 控件

@interface VECommonSelectView : UIView

@property (nonatomic,copy) CShowBlock            showBlock;
@property (nonatomic,copy) CDismissBlock         dismissBlock;
@property (nonatomic,copy) CSelectBlock          selectBlock;
@property (nonatomic,copy) CConfirmBlock         confirmBlock;
@property (nonatomic,copy) CCancelBlock          cancelBlock;

- (void)setHideConfirmButton:(BOOL)hideConfirmButton;

- (void)setOnlyShowSelectedCheckIcon:(BOOL)showCheckIcon;

- (void)setRowHeight:(CGFloat)rowHeight;

/**
 *allTitleArray 所有的标题 selectedIndexArray 表示选中的下标
 */
- (void)reloadData:(NSArray <NSString *>*)allTitleArray selectedIndexArray:(NSArray *)selectedIndexArray;//是否多选是外部通过这个数组 控制的 单选或者多选 也是外部记录

//显示带蒙层的view
- (void)showOverScreen:(CGFloat)contentHeight withAnimation:(BOOL)animation;

- (void)dismissWithAnimation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
