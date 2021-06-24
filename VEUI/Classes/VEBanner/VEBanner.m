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

@property(nonatomic, strong)NSMutableDictionary *cacheDict;

@property(nonatomic, strong)NSTimer *timer;

@property(nonatomic, assign)BOOL shouldAutoPlay;

@end

@implementation VEBanner

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.colV];
    
    self.scrollCycled = YES;
    self.disableSuperScrollViewEnabledWhenDragging = NO;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    self.showPageControl = YES;
    self.tintColor = [UIColor whiteColor];
    
    _selectIndex = -1;
    _pageControlBottomOffset = 20;
    self.shouldAutoPlay = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.delegate) {
        return;
    }
    if (self.selectIndex == -1) {
        self.selectIndex = 0;
    }
    self.colV.frame = self.bounds;
    [self.colV reloadData];
    
    CGFloat pcHeight = 10;
    self.pageControl.frame = CGRectMake(0, self.height - pcHeight - self.pageControlBottomOffset, self.width, pcHeight);
    self.pageControl.numberOfPages = [self.delegate numberOfItemsForVEBanner:self];
    if (self.pageControl.numberOfPages <= 1) {
        self.pageControl.hidden = true;
    } else {
        self.pageControl.hidden = !self.showPageControl;
    }
    self.pageControl.currentPageIndicatorTintColor = self.tintColor;
}

- (void)reloadData {
    self.cacheDict = [NSMutableDictionary dictionary];
    [self.colV reloadData];
}

#pragma mark - auto play
- (void)startAutoPlay {
    if (self.autoPlayTimeInterval < 0.5) {
        return;
    }
    [self endAutoPlay];
    __weak __typeof(self) ws = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoPlayTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong __typeof(ws) ss = ws;
        if (!ss.superview || ss.hidden == true) {
            return;
        }
        if (!ss.delegate || !ss.shouldAutoPlay) {
            return;
        }
        NSInteger count = [ss.delegate numberOfItemsForVEBanner:ss];
        if (count <= 1) {
            return;
        }
        NSInteger target = ss.selectIndex + 1;
        if (!self.scrollCycled) {
            target = target >= count ? 0 : target;
            [ss setSelectIndex:target animated:YES];
            return;
        }
        target += 1;
        ss.colV.userInteractionEnabled = NO;
        [ss.colV setContentOffset:CGPointMake(target * ss.colV.width, 0) animated:YES];
    }];
}

- (void)endAutoPlay {
    if (self.timer) {
        [self.timer invalidate];
        _timer = nil;
    }
}

- (NSInteger)dataRowFor:(NSInteger)row {
    if (!self.delegate) {
        return 0;
    }
    if (!self.scrollCycled) {
        return row;
    }
    NSInteger count = [self.delegate numberOfItemsForVEBanner:self];
    if (count <= 1) {
        return 0;
    }
    if (row == 0) {
        return count - 1;
    }
    if (row > count) {
        return 0;
    }
    return row - 1;
}

- (NSInteger)displayRowFor:(NSInteger)row {
    if (!self.delegate) {
        return 0;
    }
    if (!self.scrollCycled) {
        return row;
    }
    NSInteger count = [self.delegate numberOfItemsForVEBanner:self];
    if (count <= 1) {
        return 0;
    }
    return row + 1;
}

#pragma mark - CollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.delegate) {
        return 0;
    }
    NSInteger count = [self.delegate numberOfItemsForVEBanner:self];
    if (count > 1 && self.scrollCycled) {
        return count + 2;
    }
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEBANNER_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    if (self.delegate) {
        NSInteger row = [self dataRowFor:indexPath.row];
        UIView *v;
        NSString *cacheKey = [NSString stringWithFormat:@"%d", (int)row];
        if ([self.cacheDict.allKeys containsObject:cacheKey]) {
            v = (UIView *)[self.cacheDict valueForKey:cacheKey];
        } else {
            v = [self.delegate vebanner:self viewForItemAtIndex:row];
            [self.cacheDict setValue:v forKey:cacheKey];
        }
        [cell.contentView addSubview:v];
    }
    cell.contentView.clipsToBounds = YES;
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(vebanner:didSelectAtIndex:)]) {
        [self.delegate vebanner:self didSelectAtIndex:[self dataRowFor:indexPath.row]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.colV) {
        return;
    }
    self.shouldAutoPlay = YES;
    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView != self.colV) {
        return;
    }
    self.shouldAutoPlay = YES;
    scrollView.userInteractionEnabled = YES;
    
    NSInteger count = [self.delegate numberOfItemsForVEBanner:self];
    int index = scrollView.contentOffset.x  / scrollView.width;
    if (count > 1 && self.scrollCycled) {
        index = (int)[self dataRowFor:index];
        scrollView.contentOffset = CGPointMake((index + 1) * scrollView.width, 0);
    }
    self.selectIndex = (int)index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(vebanner:didScrollAtIndex:)]) {
        [self.delegate vebanner:self didScrollAtIndex:self.selectIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.colV) {
        return;
    }
    self.shouldAutoPlay = NO;
    [self setSuperScrollEnabled:NO];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView != self.colV) {
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != self.colV) {
        return;
    }
    if (decelerate) {
        scrollView.userInteractionEnabled = NO;
    }
    [self setSuperScrollEnabled:YES];
}

#pragma mark - disableSuperScrollViewEnabledWhenDragging handler
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

- (void)setSuperScrollEnabled:(BOOL)enabled {
    if (!self.disableSuperScrollViewEnabledWhenDragging) {
        return;
    }
    // 禁用条件  !enabled && (self.colV.isDragging || self.colV.isDecelerating)
    // 启用条件  enabled
    if ((!enabled && (self.colV.isDragging || self.colV.isDecelerating)) || enabled) {
        for (UIScrollView *s in self.superScrollViews) {
            s.scrollEnabled = enabled;
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
        _colV.backgroundColor = [UIColor whiteColor];
        _colV.delegate = self;
        _colV.dataSource = self;
        _colV.showsHorizontalScrollIndicator = NO;
        _colV.showsVerticalScrollIndicator = NO;
        _colV.pagingEnabled = YES;
        _colV.alwaysBounceHorizontal = YES;
        [_colV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:VEBANNER_CELL_REUSE_IDENTIFIER];
    }
    return _colV;
}

- (BOOL)scrollEnabled {
    return self.colV.scrollEnabled;
}

- (NSMutableDictionary *)cacheDict {
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}

#pragma mark - Set
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.colV.scrollEnabled = scrollEnabled;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self setSelectIndex:selectIndex animated:NO];
}

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animate {
    if (self.delegate) {
        NSInteger row = [self displayRowFor:selectIndex];
        NSInteger total = [self collectionView:self.colV numberOfItemsInSection:0];
        if (row < total) {
            _selectIndex = selectIndex;
            CGFloat offsetX = self.width * row;
            [self.colV setContentOffset:CGPointMake(offsetX, 0) animated:animate];
            self.pageControl.numberOfPages = [self.delegate numberOfItemsForVEBanner:self];
            self.pageControl.currentPage = selectIndex;
            [self.pageControl updateCurrentPageDisplay];
        }
        if (!animate && [self.delegate respondsToSelector:@selector(vebanner:didScrollAtIndex:)]) {
            [self.delegate vebanner:self didScrollAtIndex:self.selectIndex];
        }
    }
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}

- (void)setAutoPlayTimeInterval:(NSTimeInterval)autoPlayTimeInterval {
    if (autoPlayTimeInterval < 0.5) {
        return;
    }
    _autoPlayTimeInterval = autoPlayTimeInterval;
    [self startAutoPlay];
}

- (void)setShouldAutoPlay:(BOOL)shouldAutoPlay {
    _shouldAutoPlay = shouldAutoPlay;
    if (shouldAutoPlay) {
        [self startAutoPlay];
    } else {
        [self endAutoPlay];
    }
}

@end
