//
//  VECommonSelectView.m
//  Vedeng
//
//  Created by Drake on 2020/11/3.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "VECommonSelectView.h"
#import "VECommonCheckCell.h"
#import "VEConstant.h"
#import <Masonry/Masonry.h>

#define kToolViewHeight     (floor(MIN(Get375Height(65), 65)))//底部操作按钮高度

#pragma mark - <通用的> 单行选择 左侧单行文字+右侧选择圆圈 控件

@interface VECommonSelectView () <UITableViewDelegate,UITableViewDataSource>
{
    BOOL    _hideConfirmButton;
    BOOL    _onlyShowSelectedCheckIcon;//只显示选中的图标
    CGFloat _rowHeight;
    BOOL    _isShowOverScreen;
}
@property (nonatomic, strong) UIView        *maskView;//左侧省

@property (nonatomic, strong) UIView        *contentView;//内容容器
@property (nonatomic, strong) UITableView   *listTableView;//
@property (nonatomic, strong) UIView        *toolView;//底部按钮view
@property (nonatomic, strong) UIButton      *confirmButton;//确定按钮

@property (nonatomic, assign) CGFloat       contentHeight;//内容高度

@property (nonatomic, strong) NSArray                       *allTitleArray;//所有选中行
@property (nonatomic, strong) NSMutableArray <NSString *>   *originalSelectedIndexArray;//所有选中行
@property (nonatomic, strong) NSMutableArray <NSString *>   *localSelectedIndexArray;//所有选中行

@end



@implementation VECommonSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _rowHeight = 50;
        _onlyShowSelectedCheckIcon = NO;
        [self addConstraint];
    }
    return self;
}

- (void)dealloc
{
    _showBlock = nil;
    _dismissBlock = nil;
    _selectBlock = nil;
    _confirmBlock = nil;
    _cancelBlock = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.contentHeight <= 0 && CGRectGetHeight(self.bounds)) {
        self.contentHeight = CGRectGetHeight(self.bounds);
    }
    [self addConstraint];
}

#pragma mark - property
- (NSMutableArray<NSString *> *)localSelectedIndexArray
{
    if (!_localSelectedIndexArray) {
        _localSelectedIndexArray = [NSMutableArray array];
    }
    return _localSelectedIndexArray;
}

- (NSMutableArray<NSString *> *)originalSelectedIndexArray
{
    if (!_originalSelectedIndexArray) {
        _originalSelectedIndexArray = [NSMutableArray array];
    }
    return _originalSelectedIndexArray;
}

- (NSArray *)allTitleArray
{
    if (!_allTitleArray) {
        _allTitleArray = [NSArray array];
    }
    return _allTitleArray;
}

#pragma mark - public methods
- (void)reloadCellData:(NSDictionary *)cellData
{
    [self.listTableView reloadData];
}

- (void)reloadData:(NSArray <NSString *>*)allTitleArray selectedIndexArray:(NSArray *)selectedIndexArray
{
    GCD_Main_Queue_Excute(^{
        if (![allTitleArray isEqual:self.allTitleArray]) {
            self.allTitleArray = nil;
            self.allTitleArray = [NSArray arrayWithArray:allTitleArray];
        }
        if (![selectedIndexArray isEqual:self.localSelectedIndexArray]) {
            [self.localSelectedIndexArray removeAllObjects];
            [self.localSelectedIndexArray addObjectsFromArray:selectedIndexArray];
        }
        [self.listTableView reloadData];
    });
}

- (void)showOverScreen:(CGFloat)contentHeight withAnimation:(BOOL)animation
{
    _isShowOverScreen = YES;
    GCD_Main_Queue_Excute(^{
        
        self.hidden = NO;
        self.maskView.hidden = NO;
        self.contentView.hidden = YES;
        
        CGFloat realContentHeight = contentHeight;//实际高度
        if (_rowHeight && self.allTitleArray.count) {
            //需要重新计算高度
            CGFloat calculateHeight = 0;
            CGFloat tableHeight = ceil(_rowHeight * self.allTitleArray.count);
            if (!_hideConfirmButton) {
                calculateHeight = tableHeight + kToolViewHeight;
            } else {
                calculateHeight = tableHeight;
            }
            realContentHeight = MIN(contentHeight, calculateHeight);
        }
        
        self.contentHeight = realContentHeight;
        self.contentView.frame = CGRectMake(0, -contentHeight, CGRectGetWidth(self.bounds), self.contentHeight);
        
        self.contentView.hidden = NO;
        
        [self addSubview:self.contentView];
        
        [self.contentView layoutIfNeeded];
        VD_WS(ws);
        [UIView animateWithDuration:(animation?.3f:0) animations:^{
            ws.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(ws.bounds), ws.contentHeight);
        } completion:^(BOOL finished) {
            ws.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(ws.bounds), ws.contentHeight);
        }];
        
        [self.originalSelectedIndexArray removeAllObjects];
        [self.originalSelectedIndexArray addObjectsFromArray:self.localSelectedIndexArray];
        
        if (_showBlock) {
            _showBlock();
        }
    });
}

- (void)dismissWithAnimation:(BOOL)animation
{
    if (!_isShowOverScreen) {
        return;
    }
    //先取消
    if (_cancelBlock) {
        _cancelBlock(self.originalSelectedIndexArray);
    }
    [self doDismiss:animation];
}

- (void)doDismiss:(BOOL)animation
{
    VD_WS(ws);
    _isShowOverScreen = NO;
    self.originalSelectedIndexArray = nil;//置空
    [UIView animateWithDuration:(animation?.3f:0) animations:^{
        ws.contentView.frame = CGRectMake(0, -ws.contentHeight, CGRectGetWidth(ws.bounds), ws.contentHeight);
    } completion:^(BOOL finished) {
        ws.hidden = YES;
        ws.maskView.hidden = YES;//默认不需要显示灰色蒙层
        //恢复全覆盖
        ws.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(ws.bounds), ws.contentHeight);
    }];
    if (_dismissBlock) {
        _dismissBlock();
    }
}

- (void)setHideConfirmButton:(BOOL)hideConfirmButton
{
    _hideConfirmButton = hideConfirmButton;
    [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        if (hideConfirmButton) {
            make.height.mas_equalTo(0);
        } else {
            make.height.mas_equalTo(kToolViewHeight);
        }
    }];
}

- (void)setOnlyShowSelectedCheckIcon:(BOOL)showCheckIcon
{
    _onlyShowSelectedCheckIcon = showCheckIcon;
}

- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
}

#pragma mark - private methods
- (void)addConstraint
{
    [self addSubview:self.maskView];
    [self addSubview:self.contentView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.contentHeight);
}

- (void)confirmAction
{
    if (_confirmBlock) {
        _confirmBlock(self.localSelectedIndexArray);
    }
    if (_isShowOverScreen) {
        [self doDismiss:YES];
    }
}

- (void)maskAction
{
    if (!_isShowOverScreen) {
        return;
    }
    //先取消
    if (_cancelBlock) {
        _cancelBlock(self.originalSelectedIndexArray);
    }
    [self doDismiss:YES];
}

#pragma mark - view
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = VE_ColorWithHexString(@"0x000000", 0.6);
        _maskView.hidden = YES;//默认不需要显示灰色蒙层
        _maskView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskAction)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:self.listTableView];
        [_contentView addSubview:self.toolView];
        _contentView.clipsToBounds = YES;
        VD_WS(ws);
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.equalTo(ws.toolView.mas_top).offset(0);
        }];
        [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kToolViewHeight);
        }];
    }
    return _contentView;
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.alwaysBounceVertical = YES;
        _listTableView.clipsToBounds = YES;
        [_listTableView registerClass:[VECommonCheckCell class] forCellReuseIdentifier:@"VECommonCheckCell"];//单选cell
        if (@available(iOS 11.0, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _listTableView;
}

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [UIView new];
        _toolView.backgroundColor = [UIColor clearColor];
        _toolView.clipsToBounds = YES;
        [_toolView addSubview:self.confirmButton];
        [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _toolView;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 3;
        _confirmButton.backgroundColor = HEX_RGB(0x0099FF);
        [_confirmButton addTarget:self
                           action:@selector(confirmAction)
                 forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _confirmButton.titleLabel.textColor = HEX_RGB(0xffffff);
    }
    return _confirmButton;
}

#pragma mark - tableView delegate /datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (tableView == self.listTableView) {
        VECommonCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VECommonCheckCell"];
        [cell setOnlyShowSelectedCheckIcon:_onlyShowSelectedCheckIcon];
        NSString *title = VD_SafeObjectAtIndex(self.allTitleArray, row);
        [cell reloadCellData:VD_EMPTYSTRING(title)];
        if ([self.localSelectedIndexArray containsObject:@(row).stringValue]) {
            [cell setChosed:YES];//选中
        } else {//未选中
            [cell setChosed:NO];
        }
        
        NSInteger number = [tableView numberOfRowsInSection:section];
        if (number && row == number - 1) {
            [cell setHideBottomLine:YES];
        } else {
            [cell setHideBottomLine:NO];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.listTableView) {
        return _rowHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_selectBlock) {
        _selectBlock(indexPath.row);
    }
}

@end
