//
//  VEImageBrowser.h
//  VEUI
//
//  Created by Coder on 2021/2/25.
//

#import <UIKit/UIKit.h>
#import "VEImageBrowserModel.h"
#import "VEImageBrowserBanner.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VEImageBrowserDelegate <NSObject>

@optional
- (void)imageBrowserClickOnRightBtn;

@end

@interface VEImageBrowser : UIViewController

@property(nonatomic, weak)id<VEImageBrowserDelegate> delegate;

@property(nonatomic, strong)VEImageBrowserBanner *banner;

@property(nonatomic, copy)NSArray<UIImage *> *imageArr;
@property(nonatomic, copy)NSArray<VEImageBrowserModel *> *modelArr;

@property(nonatomic, strong)NSArray<VEImageBrowserModel *> *imgModelArr;

@property(nonatomic, assign)BOOL showHeaderRightBtn;
@property(nonatomic, strong)UIImage *headerRightBtnImage;

@property(nonatomic, assign)NSInteger selectIndex;

@property(nonatomic, assign)CGRect contentFrame;

- (instancetype)initWithImageArray:(NSArray<UIImage *> *)imageArr;

- (instancetype)initWithModelArray:(NSArray<VEImageBrowserModel *> *)modelArr;

- (instancetype)initWithImageArray:(NSArray<UIImage *> *)imageArr selectIndex:(NSInteger)selectIndex;

- (instancetype)initWithModelArray:(NSArray<VEImageBrowserModel *> *)modelArr selectIndex:(NSInteger)selectIndex;

- (void)show;

- (void)hide;

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animate;

- (void)setSubViewHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
