//
//  VECollectionViewFlowLayout.h
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VECollectionViewFlowLayoutAlignment) {
    VECollectionViewFlowLayoutAlignmentDefault = 0, // 默认排列样式，两边靠边，中间均等间隔
    VECollectionViewFlowLayoutAlignmentLeft, // 靠左排列
    VECollectionViewFlowLayoutAlignmentRight, // 靠右排列
};

@protocol VECollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional
- (UIColor *)collectionView:(UICollectionView *)collectionView
                     layout:(UICollectionViewLayout*)collectionViewLayout
   backgroundColorAtSection:(NSInteger)section;

- (UIView *)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout*)collectionViewLayout
   backgroundViewAtSection:(NSInteger)section
              sectionFrame:(CGRect)frame;

@end

@interface VECollectionViewFlowLayout : UICollectionViewFlowLayout

@property(nonatomic, assign)VECollectionViewFlowLayoutAlignment itemAlignment;

- (CGRect)itemsAreaAtSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
