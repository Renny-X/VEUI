//
//  VETextFieldView.h
//  TestDemo
//
//  Created by Drake on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VETextViewRightIconClickBlock)(void);

@interface VETextView : UIView

@end

@interface VETextFieldView : UIView

@property (nonatomic,assign) NSInteger      maxTextLength;

@property (nonatomic,strong)UIImageView     *leftIcon;
@property (nonatomic,strong)UIView          *rightIcon;
@property (nonatomic,strong)UILabel         *textLabel;
@property (nonatomic,strong)UITextField     *textField;
@property (nonatomic,strong)VETextView      *textView;
@property (nonatomic,strong)UIView          *line;
@property (nonatomic,assign)BOOL            isSecureTextEntry;//是否密码
@property (nonatomic,assign)UIKeyboardType  keyboardType;//键盘样式

@property (nonatomic,copy)VETextViewRightIconClickBlock rightIconClickBlock;

@end

NS_ASSUME_NONNULL_END
