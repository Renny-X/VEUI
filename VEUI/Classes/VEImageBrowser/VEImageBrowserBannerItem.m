//
//  VEImageBrowserBannerItem.m
//  VEUI
//
//  Created by Coder on 2021/3/3.
//

#import "VEImageBrowserBannerItem.h"
#import "VEUI.h"

@interface VEImageBrowserBannerItem ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *containerView;
@property(nonatomic, strong)UIView *contentView;

@property(nonatomic,assign)NSInteger touchFingerNumber;

@property(nonatomic, strong)UIView *testView;

@end

@implementation VEImageBrowserBannerItem


#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - UE
- (void)changeSizeWithContentOffset:(CGPoint)contentOffset animated:(BOOL)animate {
    CGFloat contentOffsetY = contentOffset.y;
    CGFloat multiple = ([UIScreen height] - fabs(contentOffsetY) * 1.75) / [UIScreen height];
    multiple = multiple > 0.4 ? multiple : 0.4;
    
    __block CGAffineTransform transform = CGAffineTransformMakeScale(multiple, multiple);
    __block CGPoint center = CGPointMake([UIScreen width] / 2 - contentOffset.x * 0.5, [UIScreen height] / 2 - contentOffsetY * 0.5);
    [UIView animateWithDuration:animate ? 0.17 : CGFLOAT_MIN animations:^{
        self.contentView.transform = transform;
        self.contentView.center = center;
    }];
    if ([self.delegate respondsToSelector:@selector(bannerItemShouldChangeSuperAlpha:inContentFrame:)]) {
        CGRect currentFrame = [self.contentView convertRect:self.contentView.bounds toView:nil];
        [self.delegate bannerItemShouldChangeSuperAlpha:multiple inContentFrame:currentFrame];
    }
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tap {
    if (tap.numberOfTapsRequired == 1) {
        if ([self.delegate respondsToSelector:@selector(bannerItemOnSingleTap)]) {
            [self.delegate bannerItemOnSingleTap];
        }
    } else if (tap.numberOfTapsRequired == 2) {
        if (!self.canZoomIn) {
            return;
        }
        if (self.containerView.zoomScale > 1) {
            [UIView animateWithDuration:0.3 animations:^{
                [self changeSizeWithContentOffset:CGPointZero animated:NO];
                [self.containerView setZoomScale:1.0 animated:NO];
            }];
        } else {
            CGPoint touchPoint = [tap locationInView:tap.view];
            CGFloat maxZoomScale = self.containerView.maximumZoomScale;
            CGFloat width = self.containerView.width / maxZoomScale;
            CGFloat height = self.containerView.height / maxZoomScale;
            CGRect targetRect = CGRectMake(touchPoint.x - width / 2.0, touchPoint.y - height / 2.0, width, height);
            [UIView animateWithDuration:0.3 animations:^{
                [self.containerView zoomToRect:targetRect animated:NO];
                self.containerView.orign = CGPointZero;
            }];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    scrollView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.zoomScale > 1) {
        return;
    }
    if (self.touchFingerNumber == 1 && scrollView.contentOffset.y != 0) {
        [self changeSizeWithContentOffset:scrollView.contentOffset animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIPanGestureRecognizer * pan = [scrollView panGestureRecognizer];
    self.touchFingerNumber = pan.numberOfTouches;
    scrollView.clipsToBounds = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.zoomScale > 1) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (
        self.touchFingerNumber == 1
        && ((offsetY < 0 && velocity.y < 0) || (offsetY > 0 && velocity.y > 0))
        && fabs(offsetY) > 45
    ) {
        if ([self.delegate respondsToSelector:@selector(bannerItemShouldDismiss)]) {
            [self.delegate bannerItemShouldDismiss];
        }
    } else {
        [self changeSizeWithContentOffset:CGPointZero animated:YES];
        [self scrollViewDidZoom:scrollView];
    }
    scrollView.clipsToBounds = YES;
    self.touchFingerNumber = 0;
}

#pragma mark - Get
- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _containerView.delegate = self;
        _containerView.bouncesZoom = YES;
        _containerView.maximumZoomScale = 2.5; // 最大放大倍数
        _containerView.minimumZoomScale = 1.0; // 最小缩小倍数
        _containerView.multipleTouchEnabled = YES;
        _containerView.contentSize = self.size;
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _containerView.delaysContentTouches = NO; // 默认yes  设置NO则无论手指移动的多么快，始终都会将触摸事件传递给内部控件；
        _containerView.canCancelContentTouches = NO; // 默认是yes
        _containerView.alwaysBounceVertical = YES; // 设置上下回弹
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _containerView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _contentView;
}

#pragma mark - Init
- (void)setUI {
    self.canZoomIn = YES;
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.contentView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
}

- (instancetype)initWithContentView:(UIView *)contentView {
    if (self = [super initWithFrame:[UIScreen bounds]]) {
        self.contentView = contentView;
        contentView.frame = self.bounds;
        [self setUI];
    }
    return self;
}

@end
