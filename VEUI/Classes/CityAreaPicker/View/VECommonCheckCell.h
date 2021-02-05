//
//  VECommonCheckCell.h
//  Vedeng
//
//  Created by Drake on 2020/11/2.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - <通用的> 地区选中-左侧单行文字+右侧选中圈圈 cell

@interface VECommonCheckCell : UITableViewCell

+ (CGFloat)heightForCellData:(NSDictionary *)cellData;
- (void)reloadCellData:(NSString *)cellData;

- (void)setChosed:(BOOL)chose;
- (void)setOnlyShowSelectedCheckIcon:(BOOL)showCheckIcon;
- (void)setHideBottomLine:(BOOL)hide;
@end

NS_ASSUME_NONNULL_END
