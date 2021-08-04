//
//  VEBannerController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/24.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VEBannerController.h"

@interface VEBannerController ()<VEBannerDelegate>

@property(nonatomic, strong)VEBanner *banner;

@property(nonatomic, strong)NSArray *sourceArr;

@end

@implementation VEBannerController

- (NSArray *)sourceArr {
    return @[
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2F2c.zol-img.com.cn%2Fproduct%2F124_500x2000%2F748%2FceZOdKgDAFsq2.jpg&refer=http%3A%2F%2F2c.zol-img.com.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1627107697&t=3f05049378f7b85f94ec570c872aefcb",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fblog%2F201306%2F25%2F20130625150506_fiJ2r.jpeg&refer=http%3A%2F%2Fcdn.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1627107697&t=c3571ddac837692f6df7de1ab88db60f",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201206%2F16%2F20120616174342_ycsye.thumb.700_0.jpeg&refer=http%3A%2F%2Fcdn.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1627107697&t=4b8c71dcef5102b380ebf322c4d54b87",
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollV.contentSize = CGSizeMake(scrollV.width, scrollV.height * 4);
    [self.view addSubview:scrollV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(randomSet)];
    [scrollV addGestureRecognizer:tap];
    
    VEBanner *banner = [[VEBanner alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    banner.autoPlayTimeInterval = 1.5;
//    banner.scrollCycled = false;
    banner.centerY = scrollV.height * 0.5;
    banner.delegate = self;
    banner.disableSuperScrollViewEnabledWhenDragging = true;
    [scrollV addSubview:banner];
    
    self.banner = banner;
}

- (NSInteger)numberOfItemsForVEBanner:(VEBanner *)banner {
    return self.sourceArr.count;
}

- (__kindof UIView *)vebanner:(VEBanner *)banner viewForItemAtIndex:(NSInteger)index {
    NSString *picPath = self.sourceArr[index];
    NSURL *picUrl = [NSURL URLWithString:picPath];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:banner.bounds];
    [imgV sd_setImageWithURL:picUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            imgV.image = image;
        }
    }];
    
    return imgV;
}

- (void)vebanner:(VEBanner *)banner didSelectAtIndex:(NSInteger)index {
    NSLog(@"did select at ==> %d", (int)index);
}

- (void)vebanner:(VEBanner *)banner didScrollAtIndex:(NSInteger)index {
    NSLog(@"did scroll at ==> %d", (int)index);
}

- (void)randomSet {
    self.banner.autoPlayTimeInterval = 1.5;
    
//    int count = (int)[self numberOfItemsForVEBanner:self.banner];
//    
//    int r = randomNum(0, count - 1);
//    BOOL animate = randomNum(0, 1);
//    [self.banner setSelectIndex:r animated:animate];
//    
//    NSLog(@"set select index ==> %d -- %d", r, animate);
}

@end
