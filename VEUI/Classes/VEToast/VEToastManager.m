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

- (void)show:(UIView *)view duration:(NSTimeInterval)duration mask:(BOOL)mask {
    __weak typeof(self) ws = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) ss = ws;
        
        UIView *window = [[UIApplication sharedApplication] keyWindow];
        [ss prepareHide:NO];
        
        __block UIView *v = view;
        v.alpha = 0;
        
        __block UIView *maskView = [[UIView alloc] init];
        maskView.alpha = 0;
        if (mask) {
            maskView.frame = window.bounds;
            maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        } else {
            maskView.frame = v.frame;
            v.frame = v.bounds;
            maskView.backgroundColor = [UIColor clearColor];
        }
        [maskView addSubview:v];
        v.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        [window addSubview:maskView];
        [ss.toastArr addObject:v];
        __weak typeof(self)weakSelf = ss;
        [UIView animateWithDuration:ss.animateDuration animations:^{
            maskView.alpha = 1;
            v.alpha = 1;
            v.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            if (finished && duration > 0) {
                NSTimeInterval after = duration < weakSelf.animateDuration ? duration : duration - weakSelf.animateDuration;
                [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:after];
            }
        }];
    });
}

- (void)prepareHide:(BOOL)animated {
    __weak typeof(self)ws = self;
    @synchronized (self.toastArr) {
        __strong typeof(self) ss = ws;
        [[ss class] cancelPreviousPerformRequestsWithTarget:ss selector:@selector(hide) object:nil];
        if (!animated) {
            UIView *window = [[UIApplication sharedApplication] keyWindow];
            [window.layer removeAllAnimations];
            for (UIView *v in ss.toastArr) {
                [v removeFromSuperview];
            }
            ss.toastArr = [NSMutableArray array];
        } else {
            while (ss.toastArr.count > 1) {
                UIView *v = [ss.toastArr firstObject];
                [v removeFromSuperview];
                [ss.toastArr removeObject:v];
            }
        }
    }
}

- (void)hide {
    if (self.toastArr.count == 0) {
        return;
    }
    __weak typeof(self) ws = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) ss = ws;
        [ss prepareHide:YES];
        __block UIView *v = [ss.toastArr firstObject];
        __weak typeof(self)weakSelf = ss;
        [UIView animateWithDuration:ss.animateDuration animations:^{
            v.alpha = 0;
            v.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            if ([weakSelf.toastArr containsObject:v] && v.superview) {
                [weakSelf prepareHide:NO];
            }
        }];
    });
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
