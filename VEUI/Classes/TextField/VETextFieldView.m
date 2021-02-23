//
//  VETextFieldView.m
//  TestDemo
//
//  Created by Drake on 2021/2/22.
//

#import "VETextFieldView.h"
#import <Masonry/Masonry.h>


#define kVETextViewMaxLength    (200)

@interface VETextView () <UITextViewDelegate>
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UILabel *textLengthLabel;
@property (nonatomic,strong)UILabel *placeholdLabel;
@property (nonatomic,assign)NSInteger maxTextLength;
@end

@implementation VETextView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setup
{
    self.maxTextLength = kVETextViewMaxLength;
    self.textLengthLabel.text = [NSString stringWithFormat:@""];
    self.placeholdLabel.text = @"默认最低3行高度，内容输入高度自适应，最多显示5行高度，内容输入自适应高度超出可局部滚动";
}

#pragma mark - public
- (void)hideTextCountLabel:(BOOL)hide
{
    self.textLengthLabel.hidden = hide;
    __weak typeof(self) ws = self;
    if (hide) {
        [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-14);
            make.height.mas_equalTo(0);
            CGFloat width = [ws.textLengthLabel.text boundingRectWithSize:CGSizeMake(ws.textLengthLabel.bounds.size.width, INT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:ws.textLengthLabel.font} context:nil].size.width;
            width = ceil(width);
            make.width.mas_equalTo(width);
        }];
    } else {
        [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-14);
            make.height.mas_equalTo(14);
            CGFloat width = [ws.textLengthLabel.text boundingRectWithSize:CGSizeMake(ws.textLengthLabel.bounds.size.width, INT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:ws.textLengthLabel.font} context:nil].size.width;
            width = ceil(width);
            make.width.mas_equalTo(width);
        }];
    }
    [self layoutIfNeeded];
}

#pragma mark - private
- (void)addConstraint
{
    [self addSubview:self.placeholdLabel];
    [self addSubview:self.textView];
    [self addSubview:self.textLengthLabel];
    __weak typeof(self) ws = self;
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
    }];
    [self.placeholdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(14);
        CGFloat height = [ws.placeholdLabel.text boundingRectWithSize:CGSizeMake(ws.placeholdLabel.bounds.size.width, INT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:ws.placeholdLabel.font} context:nil].size.height;
        height = ceil(height);
        make.height.mas_equalTo(height);
    }];
    [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-14);
        make.height.mas_equalTo(14);
        CGFloat width = [ws.textLengthLabel.text boundingRectWithSize:CGSizeMake(ws.textLengthLabel.bounds.size.width, INT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:ws.textLengthLabel.font} context:nil].size.width;
        width = ceil(width);
        make.width.mas_equalTo(width);
    }];
}

#pragma mark - delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.textView) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
        if (!text.length) {
            //删除
            return YES;
        }
        if (textView.text.length + text.length > self.maxTextLength && range.length == 0 ) {
            //增加
            return NO;
        }
        if (textView.text.length - range.length + text.length > self.maxTextLength && range.length && range.location != NSNotFound) {
            //替换
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.textView) {
        self.textLengthLabel.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,self.maxTextLength];
        if (textView.text.length <= 0) {
            self.placeholdLabel.hidden = NO;
        } else {
            self.placeholdLabel.hidden = YES;
        }
    }
}

#pragma mark - view
- (UILabel *)placeholdLabel
{
    if (!_placeholdLabel) {
        _placeholdLabel = ({
            UILabel *lb = [[UILabel alloc] init];
            lb.backgroundColor = [UIColor clearColor];
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = [UIColor colorWithRed:194 green:198 blue:204 alpha:1];
            lb;
        });
    }
    return _placeholdLabel;
}

- (UILabel *)textLengthLabel
{
    if (!_textLengthLabel) {
        _textLengthLabel = ({
            UILabel *lb = [[UILabel alloc] init];
            lb.backgroundColor = [UIColor clearColor];
            lb.textColor = UIColor.blackColor;
            lb.font = [UIFont systemFontOfSize:14];
            lb;
        });
    }
    return _textLengthLabel;
}

@end

@interface VETextFieldView () <UITextFieldDelegate>

@end

@implementation VETextFieldView

+ (UIColor *)HEX_RGB:(long)hexValue
{
    UIColor *color = [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                     green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                      blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0];
    return color;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.clipsToBounds = true;
        self.backgroundColor = UIColor.clearColor;
        [self addConstraint];
    }
    return self;
}

- (void)dealloc
{
    _rightIconClickBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addConstraint];
}

#pragma mark - property

#pragma mark - public
- (void)setMaxTextLength:(NSInteger)maxTextLength
{
    _maxTextLength = maxTextLength;
}

- (void)setIsSecureTextEntry:(BOOL)isSecureTextEntry
{
    self.textField.secureTextEntry = isSecureTextEntry;
}

#pragma mark - private
- (void)setup
{
    self.isSecureTextEntry = NO;
    self.keyboardType = UIKeyboardTypeDefault;
    self.maxTextLength = kVETextViewMaxLength;
}

- (void)addConstraint
{
    [self addSubview:self.leftIcon];
    [self addSubview:self.textLabel];
    [self addSubview:self.textField];
    [self addSubview:self.line];
    [self addSubview:self.rightIcon];
    
    __block __weak typeof(self) ws = self;
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 17));
        make.left.mas_equalTo(15);
        make.centerY.mas_offset(0);
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.leftIcon.mas_right).offset(5);
        CGFloat width = [ws.textLabel.text boundingRectWithSize:CGSizeMake(INT_MAX, ws.textLabel.bounds.size.height)
                                                        options:(NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName:ws.textLabel.font}
                                                        context:nil].size.width;
        width = ceil(width);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.textLabel.mas_right).offset(15);
        make.right.mas_offset(-15);
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
    }];
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_offset(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(16, 17));
    }];
}

- (void)rightIconClickAction
{
    if (_rightIconClickBlock) {
        _rightIconClickBlock();
    }
}

#pragma mark - view
- (UIImageView *)leftIcon
{
    if (!_leftIcon) {
        _leftIcon = ({
            UIImageView *icon = [UIImageView new];
            icon.contentMode = UIViewContentModeScaleToFill;
            icon.backgroundColor = [UIColor clearColor];
            icon;
        });
    }
    return _leftIcon;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = ({
            UILabel *lb = [[UILabel alloc] init];
            lb.backgroundColor = [UIColor clearColor];
            lb.textColor = UIColor.blackColor;
            lb.font = [UIFont systemFontOfSize:14];
            lb;
        });
    }
    return _textLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = ({
            UITextField *tf = [UITextField new];
            tf.delegate = self;
            tf.backgroundColor = [UIColor clearColor];
            tf.textColor = UIColor.blackColor;
            tf.font = [UIFont systemFontOfSize:14];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"请输入文本"];
            [attri addAttribute:NSForegroundColorAttributeName value:[self.class HEX_RGB:0xC2C6CC] range:NSMakeRange(0, attri.length)];
            [attri addAttribute:NSFontAttributeName value:tf.font range:NSMakeRange(0, attri.length)];
            tf.attributedPlaceholder = attri;
            tf.tintColor = [self.class HEX_RGB:0x0099FF];
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf.autocorrectionType = UITextAutocorrectionTypeNo;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.returnKeyType = UIReturnKeyDone;
            tf.keyboardType = UIKeyboardTypeDefault;
            tf;
        });
    }
    return _textField;
}

- (VETextView *)textView
{
    if (!_textView) {
        _textView = ({
            VETextView *tx = [VETextView new];
            tx.backgroundColor = UIColor.clearColor;
            tx;
        });
    }
    return _textView;
}

- (UIView *)line
{
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [self.class HEX_RGB:0xEDF0F2];
        _line = view;
    }
    return _line;
}

- (UIView *)rightIcon
{
    if (!_rightIcon) {
        _rightIcon = ({
            UIView *view = [UIView new];
            view.backgroundColor = UIColor.clearColor;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightIconClickAction)];
            [view addGestureRecognizer:tap];
            view;
        });
    }
    return _rightIcon;
}

@end
