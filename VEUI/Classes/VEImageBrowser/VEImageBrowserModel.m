//
//  VEImageBrowserModel.m
//  VEUI
//
//  Created by Coder on 2021/2/25.
//

#import "VEImageBrowserModel.h"
#import "UIScreen+VEUI.h"

@implementation VEImageBrowserModel

- (instancetype)initWithImage:(UIImage *)image {
    return [self initWithImage:image originFrame:CGRectZero];
}
- (instancetype)initWithImage:(UIImage *)image originFrame:(CGRect)frame {
    if (self = [super init]) {
        self.image = image;
        self.originFrame = frame;
    }
    return self;
}

- (CGRect)exitFrame {
    if (!self.image) {
        return CGRectZero;
    }
    if (CGRectEqualToRect(self.originFrame, CGRectZero)) {
        return [self enterFrame];
    }
    return self.originFrame;
}

- (CGRect)enterFrame {
    if (!self.image) {
        return CGRectZero;
    }
    CGFloat imageW = self.image.size.width;
    CGFloat imageH = self.image.size.height;
    CGRect frame;
    CGFloat H = [UIScreen width] * imageH / imageW;
    if (imageH/imageW > [UIScreen height] / [UIScreen width]) {
        //长图 指图片宽度方大为屏幕宽度时，高度超过屏幕高度
        frame = CGRectMake(0, 0, [UIScreen width], H);
    } else {
        //非 长图
        frame = CGRectMake(0, [UIScreen height] / 2 - H / 2, [UIScreen width], H);
    }
    return frame;
}

@end
