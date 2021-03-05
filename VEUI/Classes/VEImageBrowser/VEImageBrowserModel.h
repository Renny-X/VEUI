//
//  VEImageBrowserModel.h
//  VEUI
//
//  Created by Coder on 2021/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEImageBrowserModel : NSObject

@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign)CGRect originFrame;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image originFrame:(CGRect)frame;

- (CGRect)exitFrame;
- (CGRect)enterFrame;

@end

NS_ASSUME_NONNULL_END
