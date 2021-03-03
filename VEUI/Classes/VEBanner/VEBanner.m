//
//  VEBanner.m
//  Pods
//
//  Created by Coder on 2021/3/2.
//

#import "VEBanner.h"
#import "VEUI.h"

#define VEBANNER_CELL_REUSE_IDENTIFIER @"VEBANNER_CELL_REUSE_IDENTIFIER"

@interface VEBanner()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *colV;

@property(nonatomic, strong)NSArray *superScrollViews;

@property(nonatomic, strong)UIPageControl *pageControl;

@end

@implementation VEBanner

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame DataSource:@[]];
}

- (instancetype)initWithDataSource:(NSArray<UIView *> *)dataSource {
    return [self initWithFrame:CGRectZero DataSource:dataSource];
}

- (instancetype)initWithFrame:(CGRect)frame DataSource:(NSArray<UIView *> *)dataSource {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.dataSource = [NSArray arrayWithArray:dataSource];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.colV];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    self.showPageControl = YES;
    self.tintColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.colV reloadData];
    
    if (@available(iOS 11.0, *)) {
        self.pageControl.frame = CGRectMake(0, self.height - self.safeAreaInsets.bottom - 60, self.width, 30);
    } else {
        self.pageControl.frame = CGRectMake(0, self.height - 60, self.width, 30);
    }
    self.pageControl.hidden = !self.showPageControl && self.dataSource.count > 1;
    self.pageControl.numberOfPages = self.dataSource.count;
    
    self.pageControl.currentPageIndicatorTintColor = self.tintColor;
}

#pragma mark - CollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEBANNER_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    UIView *v = self.dataSource[indexPath.row];
    v.backgroundColor = UIColor.clearColor;
    [cell.contentView addSubview:v];
    v.center = cell.contentView.center;
    cell.contentView.clipsToBounds = YES;
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    for (UIScrollView *s in self.superScrollViews) {
        s.scrollEnabled = YES;
    }
    int index = scrollView.contentOffset.x  / scrollView.width;
    self.selectIndex = (int)index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.colV && (self.colV.isDragging || self.colV.isDecelerating)) {
        // 禁用父组件scrollview 滑动
        for (UIScrollView *s in self.superScrollViews) {
            s.scrollEnabled = NO;
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.size;
}

#pragma mark - Get
- (UICollectionView *)colV {
    if (!_colV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.size;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.sectionFootersPinToVisibleBounds = NO;
        
        _colV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _colV.backgroundColor = [UIColor clearColor];
        _colV.delegate = self;
        _colV.dataSource = self;
        _colV.showsHorizontalScrollIndicator = NO;
        _colV.showsVerticalScrollIndicator = NO;
        _colV.alwaysBounceHorizontal = YES;
        _colV.pagingEnabled = YES;
        [_colV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VEBANNER_CELL_REUSE_IDENTIFIER];
    }
    return _colV;
}

- (NSArray *)superScrollViews {
    if (!self.superview) {
        return @[];
    }
    if (!_superScrollViews) {
        NSMutableArray *arr = [NSMutableArray array];
        for(UIView *next = self.superview; next; next = next.superview){
            if ([next isKindOfClass:[UIScrollView class]] && ((UIScrollView *)next).scrollEnabled) {
                [arr addObject:(UIScrollView *)next];
            }
        }
        _superScrollViews = [NSArray arrayWithArray:arr];
    }
    return _superScrollViews;
}

- (BOOL)scrollEnabled {
    return self.colV.scrollEnabled;
}

#pragma mark - Set
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.colV.scrollEnabled = scrollEnabled;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self setSelectIndex:selectIndex animated:NO];
}

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animate {
    if (selectIndex < self.dataSource.count) {
        _selectIndex = selectIndex;
        CGFloat offsetX = self.width * selectIndex;
        [self.colV setContentOffset:CGPointMake(offsetX, 0) animated:animate];
        self.pageControl.numberOfPages = self.dataSource.count;
        self.pageControl.currentPage = selectIndex;
        [self.pageControl updateCurrentPageDisplay];
    }
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}

@end
