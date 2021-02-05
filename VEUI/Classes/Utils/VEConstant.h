
#import <Foundation/Foundation.h>

#define VD_IsIOS7OrLater ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define VD_IsIOS8OrLater ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define VD_IsIOS9OrLater ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define VD_IsIOS9_1OrLater ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

#define VD_IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define VD_IsStringEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""])||([(_ref)isEqualToString:@"(null)"]))
//数组是否为空
#define VD_IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
//返回非空""字符串
#define VD_NotNilString(__str) (([(__str) isKindOfClass:[NSString class]]) ? (VD_IsStringEmpty((__str)) ? @"" : ((__str))) : @"")

//跳转系统隐私
#define VD_GO_APP_PRIVACY       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

extern NSString     *VD_EncodeStringFromDic(NSDictionary *dic, NSString *key);
extern NSNumber     *VD_EncodeNumberFromDic(NSDictionary *dic, NSString *key);
extern BOOL         VD_EncodeBoolFromDic(NSDictionary *dic, NSString *key);
extern NSDictionary *VD_EncodeDicFromDic(NSDictionary *dic, NSString *key);
extern NSArray      *VD_EncodeArrayFromDic(NSDictionary *dic, NSString *key);
extern NSArray      *VD_EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(id innerDic));
extern id VD_EncodeObjectFromDic(NSDictionary *dic, NSString *key,Class objectClass);
extern NSArray *VD_ParseArrayWithBlock(NSArray *tempList,
                                       id(^parseBlock)(id innerDic));

extern UIColor *VE_ColorWithHexString(NSString *color,CGFloat alpha);
extern UIColor *colorWithHexString(NSString *color);

#define kScreen_Height  ([[UIScreen mainScreen] bounds].size.height)
#define kScreen_Width   ([[UIScreen mainScreen] bounds].size.width)

#define Get375Height(h)  ((h) * (kScreen_Height) / 667.0)
#define Get375Width(w)   ((w) * (kScreen_Width) / 375.0)

#define NetworkError    (@"网络异常，请检查网络")
//颜色创建
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef    HEX_RGB
#define HEX_RGB(hexValue)      ({\
UIColor *color = [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0];\
color;\
})


#define VD_IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define VD_IsStringEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""])||([(_ref)isEqualToString:@"(null)"]))
//数组是否为空
#define VD_IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
//返回非空""字符串
#define VD_NotNilString(__str) (([(__str) isKindOfClass:[NSString class]]) ? (VD_IsStringEmpty((__str)) ? @"" : ((__str))) : @"")

#define VD_EMPTYSTRING(emptyString) ((emptyString) != nil ? [NSString stringWithFormat:@"%@",(emptyString)] : @"")

#define VD_Weakify(oriInstance, weakInstance) __weak typeof(oriInstance) weakInstance = oriInstance;
#define VD_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define VD_Strongify(weakInstance, strongInstance) __strong typeof(weakInstance) strongInstance = weakInstance;

#define VD_SafeObjectAtIndex(array, index) ((index) >= ((array).count) ?nil:[(array) objectAtIndex:(index)])

// iPhoneX 设置
#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define Device_Is_iPhoneX_Or_Later (Device_Is_iPhoneX?YES:((([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)&&([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0f))))//表示iPhone X及之后的屏幕（带刘海）


#define VD_UserDefault ([NSUserDefaults standardUserDefaults])

//缓存数据
#define VD_UserDefault_Set(key,value) ({\
if ([(key) isKindOfClass:NSString.class]) {\
if ((value) == nil) {\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:(key)];\
} else {\
[[NSUserDefaults standardUserDefaults] setObject:(value) forKey:(key)];\
}\
[[NSUserDefaults standardUserDefaults] synchronize];\
} else {\
printf("%s,%d 参数错误%s %s",__FUNCTION__,__LINE__,object_getClassName((key)),object_getClassName((value)));\
}\
})

//缓存数据
#define VD_UserDefault_Get(key) ({\
id value = nil;\
if ([(key) isKindOfClass:NSString.class]) {\
value = [[NSUserDefaults standardUserDefaults] objectForKey:(key)];\
} else {\
printf("%s,%d 参数错误%s",__FUNCTION__,__LINE__,object_getClassName((key)));\
}\
value;\
})

//toast提示
#define VD_MakeToast(text,view) ({\
CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];\
style.cornerRadius = 3;\
[((view)?(view):([UIApplication sharedApplication].keyWindow)) makeToast:(text) duration:2 position:CSToastPositionCenter style:style];\
})

#pragma mark - GCD in block
//normal queue block
typedef void(^EMCommonVoidBlock)(void);
typedef void(^EMCommonBoolBlock)(BOOL reuslt);
typedef void(^EMCommonStringBlock)(NSString *reuslt);
typedef void(^EMCommonNumberBlock)(NSNumber *reuslt);
typedef void(^EMCommonIntBlock)(int reuslt);
typedef void(^EMCommonObjectBlock)(id reuslt);

//全局队列
#define Get_GCD_Global_Queue                (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
//主队列
#define Get_GCD_Main_Queue                  (dispatch_get_main_queue())
//global queue excute
#define GCD_Global_Queue_Excute(block)  (dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (block)))
//main queue excute
#define GCD_Main_Queue_Excute(block)    (dispatch_async(dispatch_get_main_queue(), (block)))
//main queue after excute
#define GCD_Main_Queue_Excute_AfterSecond(seconds, block)    (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((seconds) * NSEC_PER_SEC)), dispatch_get_main_queue(), (block)))

//全局 获取视图下 安全区域
#define VD_ViewSafeAreaInsetsBottom ({\
CGFloat bottom = 0;\
if (@available(iOS 11.0, *)) {\
bottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;\
} else if ([VDGlobal instance].isIphoneX) {\
bottom = 34;\
}\
bottom;\
})

@interface VDConstant : NSObject


@end
