//
//  VETab.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/3/10.
//

#import "VETab.h"
#import <VEUI/VEUI.h>
#import "VETabContentItem.h"

#define VETAB_Tab_CELL_REUSE_IDENTIFIER @"VETAB_Tab_CELL_REUSE_IDENTIFIER"
#define VETAB_Content_CELL_REUSE_IDENTIFIER @"VETAB_Content_CELL_REUSE_IDENTIFIER"

@interface VETab ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSMutableArray *contentArr;

@property(nonatomic, strong)UICollectionView *colV;
@property(nonatomic, strong)UICollectionView *contentV;
@property(nonatomic, assign)CGFloat itemWidth;

@property(nonatomic, assign)NSInteger layoutTag;

@property(nonatomic, assign)NSInteger itemCount;

@end

@implementation VETab

- (instancetype)initWithStyle:(VETabStyle)style {
    if (self = [super init]) {
        [self setUI];
        _style = style;
        self.itemCount = 0;
        _selectedIndex = -1;
        self.contentArr = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public
- (void)reloadTab {
    if (self.colV) {
        [self.colV reloadData];
        [self setSelectedIndex:self.selectedIndex animate:YES];
    }
}

- (void)reloadContent {
    if (self.contentV) {
        self.contentArr = [NSMutableArray array];
        [self.contentV reloadData];
    }
}

- (VETabItem *)tabItemAtIndex:(NSInteger)index {
    return (VETabItem *)[self.colV dequeueReusableCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - UI
- (void)initParams {
    self.backgroundColor = [UIColor whiteColor];
    self.itemWidth = 60;
    self.itemHeight = 40;
}

- (void)setUI {
    [self initParams];
    [self addSubview:self.colV];
    [self addSubview:self.contentV];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.layoutTag) {
        [self setSelectedIndex:self.selectedIndex >= 0 ?: 0 animate:YES];
        self.layoutTag = 1;
    }
    self.colV.scrollEnabled = self.tabScrollEnabled;
    self.contentV.scrollEnabled = self.contentScrollEnabled;
    self.colV.frame = CGRectMake(0, 0, self.width, self.itemHeight);
    self.contentV.frame = CGRectMake(0, self.itemHeight, self.width, self.height - self.itemHeight);
}

#pragma mark - Data Handler
- (void)checkArrWithCount:(NSInteger)count {
    while (self.contentArr.count < count) {
        [self.contentArr addObject:[NSNull null]];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfTabItems)]) {
        self.itemCount = [self.dataSource numberOfTabItems];
        return self.itemCount;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self checkArrWithCount:indexPath.row + 1];
    if (collectionView.tag % 10) {
        // 内容页
        VETabContentItem *cell = (VETabContentItem *)[collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Content_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
        UIView *layoutView = [self.contentArr objectAtIndex:indexPath.row];
        if (![layoutView isKindOfClass:[UIView class]]) {
            layoutView = nil;
            if ([self.dataSource respondsToSelector:@selector(tab:contentViewAtIndex:)]) {
                layoutView = [self.dataSource tab:self contentViewAtIndex:indexPath.row];
            }
            if (!layoutView) {
                layoutView = [[UIView alloc] init];
                layoutView.backgroundColor = [UIColor whiteColor];
            }
            [self.contentArr replaceObjectAtIndex:indexPath.row withObject:layoutView];
        }
        cell.layoutView = layoutView;
        return cell;
    }
    // tab
    VETabItem *cell;
    if ([self.dataSource respondsToSelector:@selector(tab:tabItemAtIndex:)]) {
        cell = [self.dataSource tab:self tabItemAtIndex:indexPath.row];
    }
    if (!cell) {
        cell = (VETabItem *)[collectionView dequeueReusableCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        // tab
        _selectedIndex = indexPath.row;
        [self setSelectedIndex:indexPath.row animate:YES];
        if ([self.delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
            [self.delegate didSelectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag % 10) {
        if (collectionView.width <= 0 || collectionView.height <= 0) {
            return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
        }
        return collectionView.size;
    }
    if ([self.dataSource respondsToSelector:@selector(tab:tabItemWidthAtIndex:)]) {
        CGFloat width = [self.dataSource tab:self tabItemWidthAtIndex:indexPath.row];
        if (width > 0) {
            return CGSizeMake(width, self.itemHeight);
        }
    }
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self setSelectedIndex:index animate:NO];
}

#pragma mark - Set
- (void)setSelectedIndex:(NSInteger)selectedIndex animate:(BOOL)animate {
    if ([self.dataSource respondsToSelector:@selector(numberOfTabItems)]) {
        self.itemCount = [self.dataSource numberOfTabItems];
    }
    if (self.itemCount > selectedIndex && selectedIndex >= 0) {
        if (self.selectedIndex != selectedIndex) {
            _selectedIndex = selectedIndex;
            [self collectionView:self.colV didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
            [self.colV selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        [self.contentV setContentOffset:CGPointMake(selectedIndex * self.contentV.width, 0) animated:animate];
    }
}

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        
        _colV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _colV.tag = 1000;
        _colV.backgroundColor = [UIColor clearColor];
        _colV.delegate = self;
        _colV.dataSource = self;
        _colV.showsHorizontalScrollIndicator = NO;
        _colV.showsVerticalScrollIndicator = NO;
        [_colV registerClass:[VETabItem class] forCellWithReuseIdentifier:VETAB_Tab_CELL_REUSE_IDENTIFIER];
    }
    return _colV;
}

- (UICollectionView *)contentV {
    if (!_contentV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        
        _contentV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _contentV.tag = 1001;
        _contentV.backgroundColor = [UIColor clearColor];
        _contentV.delegate = self;
        _contentV.dataSource = self;
        _contentV.showsHorizontalScrollIndicator = NO;
        _contentV.showsVerticalScrollIndicator = NO;
        _contentV.pagingEnabled = YES;
        [_contentV registerClass:[VETabContentItem class] forCellWithReuseIdentifier:VETAB_Content_CELL_REUSE_IDENTIFIER];
    }
    return _contentV;
}

@synthesize selectedIndex = _selectedIndex;
- (NSInteger)selectedIndex {
    if (!_selectedIndex) {
        _selectedIndex = 0;
    }
    return _selectedIndex;
}

#pragma mark- tab scroll enabled
@synthesize tabScrollEnabled = _tabScrollEnabled;
- (BOOL)tabScrollEnabled {
    return self.colV.scrollEnabled;
}

- (void)setTabScrollEnabled:(BOOL)tabScrollEnabled {
    _tabScrollEnabled = tabScrollEnabled;
    self.colV.scrollEnabled = tabScrollEnabled;
}

#pragma mark- tab scroll enabled
@synthesize contentScrollEnabled = _contentScrollEnabled;
- (BOOL)contentScrollEnabled {
    return self.contentV.scrollEnabled;
}

- (void)setcontentScrollEnabled:(BOOL)contentScrollEnabled {
    _contentScrollEnabled = contentScrollEnabled;
    self.contentV.scrollEnabled = contentScrollEnabled;
}

@end
