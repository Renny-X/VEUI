//
//  VETagDisplayComponent.h
//  Vedeng
//
//  Created by Drake on 2020/10/30.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    StateNormal,//普通状态
    StateShowCheck,//显示勾√
    StateShowClose,//显示叉号
} VEKeywordButtonState;

@interface VEKeywordItem : NSObject

@property(nonatomic,copy)NSString               *text;//文字
@property (nonatomic,assign)VEKeywordButtonState  state; //⚠️这可以设置不同按钮 不同状态

- (instancetype)copyModel;

@end


#pragma mark - <通用的> 关键词 展示通用组件

typedef void(^ItemClickBlock) (NSInteger itemIndex);
typedef void(^ItemCloseBlock) (NSInteger itemIndex);

typedef void(^GetHeightBlock) (CGFloat totalHeight);

@interface VETagDisplayComponent : UIView

@property(nonatomic,strong)UIFont                           *itemTextFont;//⚠️默认12
@property(nonatomic,strong)UIColor                          *itemBgColor;//按钮的背景颜色 ⚠️默认白色

@property(nonatomic,assign)CGFloat                          itemHeight;//标签行高 ⚠️默认28
@property(nonatomic,assign)CGFloat                          itemTextLeftPadding;//标签内 (左间距) ⚠️默认15
@property(nonatomic,assign)CGFloat                          itemTextRightPadding;//标签内(右间距) ⚠️默认15

@property(nonatomic,assign)CGFloat                          itemVerticalSpace;//垂直方向 两行间距 ⚠️默认10
@property(nonatomic,assign)CGFloat                          itemHorizontalSpace;//水平方向 标签间距 ⚠️默认10

@property(nonatomic,assign)CGFloat                          containerEdgeSpace;//整个区域左右边距 ⚠️默认0

@property(nonatomic,copy)ItemClickBlock                     itemClickBlock;//关键词点击
@property(nonatomic,copy)ItemCloseBlock                     itemCloseBlock;//关键词关闭

@property(nonatomic,copy)GetHeightBlock                     getHeightBlock;//获取高度成功

@property(nonatomic,assign,readonly)CGFloat                 totalHeight; //返回总高度

@property(nonatomic,strong)NSArray <VEKeywordItem *>   *keyModelArray;//搜索关键词


@property(nonatomic,strong)UIColor                          *itemTextColorOnNormal;//按钮的文字颜色 ⚠️普通状态下
@property(nonatomic,strong)UIColor                          *itemBorderColorOnNormal;//按钮的边框颜色  ⚠️普通状态下
@property(nonatomic,strong)UIColor                          *itemTextColorOnHighlight;//按钮的文字颜色 ⚠️高亮状态
@property(nonatomic,strong)UIColor                          *itemBorderColorOnHighlight;//按钮的边框颜色  ⚠️高亮状态

@end

NS_ASSUME_NONNULL_END
