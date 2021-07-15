//
//  VENoticeBar.h
//  VEUI
//
//  Created by Coder on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * VEHeaderTipStyleText 纯文字 没有左边icon
 * VEHeaderTipStyleInfo 蓝屏的钙 好喝的钙
 * VEHeaderTipStyleWarning 黄色的
 * VEHeaderTipStyleInfoSuccess 绿油油的
 */
typedef NS_ENUM(NSInteger, VENoticeBarStyle) {
    VENoticeBarStyleText = 0,
    VENoticeBarStyleInfo,
    VENoticeBarStyleWarning,
    VENoticeBarStyleSuccess,
};

@interface VENoticeBar : UIView

/**
 * 类型 默认为 VENoticeBarStyleInfo
 */
@property(nonatomic, assign)VENoticeBarStyle style;

/**
 * bgColor: 背景色
 * VEHeaderTipStyleText:        #FFEACC
 * VEHeaderTipStyleInfo:        #CCE5FF ==> #0099FF
 * VEHeaderTipStyleWarning: #FFEECC ==> #FF9900
 * VEHeaderTipStyleSuccess: #DDFFCC ==> #00CC00
 */
@property(nonatomic, strong)UIColor *bgColor;

#pragma mark - 文字
/**
 * info: 文字信息
 */
@property(nonatomic, strong)NSString *info;
/**
 * infoColor: 文字信息 字体颜色 默认VEHeaderTipStyleText 时颜色为#FA8900，其他为#000000
 */
@property(nonatomic, strong)UIColor *infoColor;
/**
 * infoLines: 文字信息 文字行数，默认为0，及不限制行数
 */
@property(nonatomic, assign)NSInteger infoLines;

/**
 * iconIsHidden: 是否隐藏左边icon，默认为NO，style不为Text时生效
 */
@property(nonatomic, assign)BOOL iconIsHidden;
/**
 * iconString: 左边的icon 字体
 */
@property(nonatomic, strong)NSString *iconString;
/**
 * btnTitle: 右侧功能按钮标题，不设置不显示，设置后默认close按钮不隐藏
 */
@property(nonatomic, strong)NSString *btnTitle;
/**
 * closeIsHidden: 右侧关闭按钮，默认设置moreBtn后为NO，其他为YES
 */
@property(nonatomic, assign)BOOL closeIsHidden;

@property(nonatomic, copy, nullable) void(^onBtnClicked)(void);
@property(nonatomic, copy, nullable) void(^onCloseClicked)(void);

#pragma mark - INIT
- (instancetype)initWithStyle:(VENoticeBarStyle)style;
- (instancetype)initWithStyle:(VENoticeBarStyle)style info:(NSString *)info;
- (instancetype)initWithStyle:(VENoticeBarStyle)style info:(NSString *)info btnTitle:(NSString *)btnTitle;

- (void)layoutWithWidth:(CGFloat)width;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
