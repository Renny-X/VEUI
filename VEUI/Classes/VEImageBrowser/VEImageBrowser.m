//
//  VEImageBrowser.m
//  VEUI
//
//  Created by Coder on 2021/2/25.
//

#import "VEImageBrowser.h"
#import "VEUI.h"
#import "VEImageBrowserBannerItem.h"
#import "VEImageBrowserControl.h"
#import "VEImageBrowserTransition.h"

@interface VEImageBrowser ()<UIViewControllerTransitioningDelegate, VEImageBrowserControlDelegate, VEImageBrowserBannerDelegate>

@property(nonatomic, strong)NSArray<UIView *> *bannerDataSource;

@property(nonatomic, strong)VEImageBrowserControl *control;

@property(nonatomic, strong)VEImageBrowserTransition *transition;

@end

@implementation VEImageBrowser

#pragma mark - layout
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.transitioningDelegate = self;
    
    self.control = [[VEImageBrowserControl alloc] initWithTintColor:[UIColor whiteColor] coverColor:[UIColor blackColor]];
    self.control.frame = self.view.bounds;
    self.control.delegate = self;
    [self.view addSubview:self.control];
}

- (void)setUIWithIndex:(NSInteger)index {
    self.banner = [[VEImageBrowserBanner alloc] initWithDataSource:self.bannerDataSource selectIndex:index];
    self.banner.delegate = self;
    [self.view addSubview:self.banner];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.banner.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.control];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transition.isEnter = YES;
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transition.isEnter = NO;
    return self.transition;
}

#pragma mark - VEImageBrowserBannerDelegate
- (void)bannerOnSingleTap {
    [self.control show:!self.control.userInteractionEnabled];
}

- (void)bannerShouldDismiss {
    [self hide];
}

- (void)bannerShouldChangeSuperAlpha:(CGFloat)alpha inContentFrame:(CGRect)frame {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
    self.contentFrame = frame;
}

#pragma mark - Init
- (instancetype)initWithImageArray:(NSArray<UIImage *> *)imageArr {
    return [self initWithImageArray:imageArr selectIndex:0];
}

- (instancetype)initWithModelArray:(NSArray<VEImageBrowserModel *> *)modelArr {
    return [self initWithModelArray:modelArr selectIndex:0];
}

- (instancetype)initWithImageArray:(NSArray<UIImage *> *)imageArr selectIndex:(NSInteger)selectIndex {
    if (self = [super init]) {
        self.imageArr = [NSArray arrayWithArray:imageArr];
        [self setUIWithIndex:selectIndex];
    }
    return self;
}

- (instancetype)initWithModelArray:(NSArray<VEImageBrowserModel *> *)modelArr selectIndex:(NSInteger)selectIndex {
    if (self = [super init]) {
        self.modelArr = [NSArray arrayWithArray:modelArr];
        [self setUIWithIndex:selectIndex];
    }
    return self;
}

#pragma mark - Public Func
- (void)show {
//    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController currentController] presentViewController:self animated:YES completion:nil];
}

- (void)hide {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VEImageBrowserControlDelegate
- (void)funcBtnClicked:(VEImageBrowserControlBtnType)btnType {
    if (btnType == VEImageBrowserControlBtnTypeClose) {
        [self hide];
    }
    if (btnType == VEImageBrowserControlBtnTypeMore && [self.delegate respondsToSelector:@selector(imageBrowserClickOnRightBtn)]) {
        [self.delegate imageBrowserClickOnRightBtn];
    }
}

#pragma mark - Set Func
- (void)setImageArr:(NSArray<UIImage *> *)imageArr {
    if (imageArr && imageArr.count) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 0; i < imageArr.count; i++) {
            VEImageBrowserModel *model = [[VEImageBrowserModel alloc] initWithImage:imageArr[i]];
            [tmp addObject:model];
        }
        _imageArr = [NSArray arrayWithArray:imageArr];
        self.imgModelArr = [NSArray arrayWithArray:tmp];
    } else {
        _imageArr = [NSArray array];
        self.imgModelArr = [NSArray array];
    }
}

- (void)setModelArr:(NSArray<VEImageBrowserModel *> *)modelArr {
    if (modelArr && modelArr.count) {
        _modelArr = [NSArray arrayWithArray:modelArr];
    } else {
        _modelArr = [NSArray array];
    }
    self.imgModelArr = [NSArray arrayWithArray:_modelArr];
}

- (void)setShowHeaderRightBtn:(BOOL)showHeaderRightBtn {
    self.control.showHeaderRightBtn = showHeaderRightBtn;
}

- (void)setHeaderRightBtnImage:(UIImage *)headerRightBtnImage {
    self.control.headerRightBtnImage = headerRightBtnImage;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self setSelectIndex:selectIndex animated:NO];
}

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animate {
    [self.banner.banner setSelectIndex:selectIndex animated:animate];
}

- (void)setSubViewHidden:(BOOL)hidden {
    self.control.hidden = hidden;
    self.banner.hidden = hidden;
}

#pragma mark - Get Func
- (NSInteger)selectIndex {
    return self.banner.banner.selectIndex;
}

- (NSArray<UIView *> *)bannerDataSource {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.imgModelArr.count; i++) {
        [arr addObject:[self viewWithModel:self.imgModelArr[i]]];
    }
    return arr;
}

- (BOOL)showHeaderRightBtn {
    return self.control.showHeaderRightBtn;;
}

- (UIImage *)headerRightBtnImage {
    return self.control.headerRightBtnImage;
}

- (VEImageBrowserTransition *)transition {
    if (!_transition) {
        _transition = [[VEImageBrowserTransition alloc] init];
        _transition.target = self;
    }
    return _transition;
}

#pragma mark - Factory
- (UIView *)viewWithModel:(VEImageBrowserModel *)model {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgV.backgroundColor = [UIColor clearColor];
    imgV.image = model.image;
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.clipsToBounds = YES;
    return imgV;
}

@end
