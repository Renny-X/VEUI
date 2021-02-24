//
//  VEToastLabel.m
//  VEUI
//
//  Created by Coder on 2021/2/22.
//

#import "VEToastLabel.h"
#import "VEToastManager.h"

@implementation VEToastLabel

- (instancetype)initWithCode:(NSString *)codeString size:(CGSize)size {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.text = codeString;
        self.font = [UIFont VEFontWithSize:MIN(size.width, size.height)];
        self.textColor = [VEToastManager manager].tintColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.textVerticalAlignment = VELabelTextVerticalAlignmentDefault;
    }
    return self;
}

@end
