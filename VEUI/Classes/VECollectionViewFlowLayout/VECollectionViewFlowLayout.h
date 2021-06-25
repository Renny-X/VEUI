//
//  VECollectionViewFlowLayout.h
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VECollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout backgroundColorAtSection:(NSInteger)section;

@end

@interface VECollectionViewFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END
