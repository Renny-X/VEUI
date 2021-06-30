//
//  VECollectionViewLeftFlowLayoutController.m
//  VEUI_Example
//
//  Created by Coder on 2021/6/25.
//  Copyright © 2021 Coder. All rights reserved.
//

#import "VECollectionViewLeftFlowLayoutController.h"

#define VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM @"VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM"

@interface VECollectionViewLeftFlowLayoutController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VECollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *colV;

@property(nonatomic, strong)NSArray *randomWidthArray;

@end

@implementation VECollectionViewLeftFlowLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.colV];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.randomWidthArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor randomColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [[self.randomWidthArray safe_objectAtIndex:indexPath.row] floatValue];
    
    return CGSizeMake(width, 25);
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout backgroundColorAtSection:(NSInteger)section {
    return [UIColor randomColor];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        VECollectionViewLeftFlowLayout *flowLayout = [[VECollectionViewLeftFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        _colV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _colV.backgroundColor = UIColor.clearColor;
        _colV.delegate = self;
        _colV.dataSource = self;
        [_colV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VECOLLECTIONVIEW_LEFT_FLOWLAYOUT_ITEM];
    }
    return _colV;
}

- (NSArray *)randomWidthArray {
    if (!_randomWidthArray) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [tmpArr addObject:[NSNumber numberWithInt:randomNum(20, 200)]];
        }
        _randomWidthArray = [NSArray arrayWithArray:tmpArr];
    }
    return _randomWidthArray;
}

@end
