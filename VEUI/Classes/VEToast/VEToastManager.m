//
//  VEToastManager.m
//  VEUI
//
//  Created by Coder on 2021/2/20.
//

#import "VEToastManager.h"

@interface VEToastManager()

@property(nonatomic, strong)NSMutableArray *toastArr;

@end

@implementation VEToastManager

- (void)show:(UIView *)view duration:(NSTimeInterval)duration {
    @synchronized (self.toastArr) {
        while (self.toastArr.count) {
            UIView *v = [self.toastArr firstObject];
            [v removeFromSuperview];
            [self.toastArr removeObject:v];
        }
    }
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    __block UIView *v = view;
    [self.toastArr addObject:v];
    v.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:self.animateDuration animations:^{
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:duration];
    }];
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

#pragma mark - Singleton
static VEToastManager *_instance;
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[VEToastManager alloc] init];
            _instance.duration = 2.3;
            _instance.imgSize = CGSizeMake(50, 50);
            _instance.animateDuration = 0.3;
            _instance.textFont = 14;
            _instance.toastColor = [UIColor colorWithWhite:0 alpha:0.6];
            _instance.tintColor = [UIColor whiteColor];
        }
    });
    return _instance;
}

@end
