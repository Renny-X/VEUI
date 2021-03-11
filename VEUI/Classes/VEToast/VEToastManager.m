//
//  VEToastManager.m
//  VEUI
//
//  Created by Coder on 2021/2/20.
//

#import "VEToastManager.h"
#import "VEUIDEVTool.h"
#import "UIIMage+VEUI.h"

@interface VEToastManager()

@property(nonatomic, strong)NSMutableArray *toastArr;

@end

@implementation VEToastManager

- (void)show:(UIView *)view duration:(NSTimeInterval)duration {
    @synchronized (self.toastArr) {
        UIView *window = [[UIApplication sharedApplication] keyWindow];
        [window.layer removeAllAnimations];
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
        while (self.toastArr.count) {
            UIView *v = [self.toastArr firstObject];
            [v removeFromSuperview];
            [self.toastArr removeObject:v];
        }
        __block UIView *v = view;
        v.alpha = 0;
        [window addSubview:v];
        [self.toastArr addObject:v];
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:self.animateDuration animations:^{
            v.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished && duration > 0) {
                NSTimeInterval after = duration < weakSelf.animateDuration ? duration : duration - weakSelf.animateDuration;
                [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:after];
            }
        }];
    }
}

- (void)hide {
    if (self.toastArr.count == 0) {
        return;
    }
    @synchronized (self.toastArr) {
        while (self.toastArr.count > 1) {
            UIView *v = [self.toastArr firstObject];
            [v removeFromSuperview];
            [self.toastArr removeObject:v];
        }
    }
    __block UIView *v = [self.toastArr firstObject];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:self.animateDuration animations:^{
        v.alpha = 0;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
        [weakSelf.toastArr removeAllObjects];
    }];
}

#pragma mark - Get
- (NSMutableArray *)toastArr {
    if (!_toastArr) {
        _toastArr = [NSMutableArray array];
    }
    return _toastArr;
}

- (NSArray *)loadingImages {
    if (!_loadingImages) {
        NSMutableArray *imgArr = [NSMutableArray array];
        NSBundle *bundle = [VEUIDEVTool vebundle];
        
        UIImage *oImg = [UIImage imageNamed:@"loading" inBundle:bundle compatibleWithTraitCollection:nil];
        oImg = [UIImage imageWithCGImage:oImg.CGImage scale:oImg.scale orientation:UIImageOrientationDownMirrored];
        for (int i = 0; i < 12; i++) {
            UIImage *img = [oImg imageRotatedByDegrees:i * 30];
            [imgArr addObject:img];
        }
        _loadingImages = [NSArray arrayWithArray:imgArr];
    }
    
    return _loadingImages;
}

#pragma mark - Singleton
static VEToastManager *_instance;
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[VEToastManager alloc] init];
            _instance.duration = 2.3;
            _instance.imgSize = CGSizeMake(50, 50);
            _instance.animateDuration = 0.2;
            _instance.textFont = 14;
            _instance.toastColor = [UIColor colorWithWhite:0 alpha:0.6];
            _instance.tintColor = [UIColor whiteColor];
        }
    });
    return _instance;
}

@end
