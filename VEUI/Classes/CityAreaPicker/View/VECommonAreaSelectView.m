//
//  VECommonAreaSelectView.m
//  Vedeng
//
//  Created by Drake on 2020/11/3.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "VECommonAreaSelectView.h"
#import "VECommonCheckCell.h"
#import "VEConstant.h"
#import <Masonry/Masonry.h>

//文字字体
#define kNormalFont         ([UIFont systemFontOfSize:14])
#define kSelectFont         ([UIFont boldSystemFontOfSize:14])
//文字颜色
#define kNormalColor        ([UIColor blackColor])
#define kSelectColor        (HEX_RGB(0x0099FF))
//背景字体
#define kNormalBgColor      (HEX_RGB(0xF5F7FA))
#define kSelectBgColor      ([UIColor whiteColor])

#define kToolViewHeight     (floor(MIN(Get375Height(60), 60)))


@interface VEProvinceCell : UITableViewCell
@property (nonatomic,strong)UILabel     *mainLabel;//左侧省标签
@property (nonatomic,strong)UILabel     *dotLabel;//数字标签
@property(nonatomic,strong)UIImageView  *checkIcon;

+ (CGFloat)heightForCellData:(NSDictionary *)cellData;

- (void)reloadCellData:(NSString *)province
             dotNumber:(NSInteger)dot
             isCountry:(BOOL)isCountry;

- (void)setChosed:(BOOL)chose;

@end


@implementation VEProvinceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kNormalBgColor;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addConstraint];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.contentView.backgroundColor = kNormalBgColor;
    
}

- (void)dealloc
{
    
}

#pragma mark - public methods
+ (CGFloat)heightForCellData:(NSDictionary *)cellData
{
    return 50;
}

- (void)reloadCellData:(NSString *)province
             dotNumber:(NSInteger)dot
             isCountry:(BOOL)isCountry
{
    self.mainLabel.text = VE_EMPTYSTRING(province);
    if (isCountry) {
        //如果是国家
        self.dotLabel.hidden = YES;
        self.dotLabel.text = @"";
        if (dot <= 0) {
            self.checkIcon.hidden = YES;
        } else {
            self.checkIcon.hidden = NO;
        }
    } else {
        self.checkIcon.hidden = YES;
        self.dotLabel.hidden = NO;
        if (dot <= 0) {
            self.dotLabel.text = @"";
        } else {
            self.dotLabel.text = VE_EMPTYSTRING(@(dot).stringValue);
        }
    }
}

- (void)setChosed:(BOOL)chose
{
    if (chose) {
        self.contentView.backgroundColor = kSelectBgColor;
        self.mainLabel.textColor = kSelectColor;
        self.mainLabel.font = kSelectFont;
        self.dotLabel.textColor = kSelectColor;
        self.dotLabel.font = kSelectFont;
    } else {
        self.contentView.backgroundColor = kNormalBgColor;
        self.mainLabel.textColor = kNormalColor;
        self.mainLabel.font = kNormalFont;
        self.dotLabel.textColor = kNormalColor;
        self.dotLabel.font = kNormalFont;
    }
}

#pragma mark - private methods
- (void)addConstraint
{
    [self.contentView addSubview:self.mainLabel];
    [self.contentView addSubview:self.dotLabel];
    [self.contentView addSubview:self.checkIcon];
    VE_WS(ws);
    [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(17);
        make.centerY.mas_offset(0);
        make.right.equalTo(ws.dotLabel.mas_left).offset(-10);
    }];
    [self.dotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(17);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(28);
    }];
    [self.checkIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 15));
        make.right.equalTo(ws.dotLabel);
        make.centerY.equalTo(ws.dotLabel);
    }];
}

#pragma mark - view
- (UILabel *)mainLabel
{
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.backgroundColor = [UIColor clearColor];
        _mainLabel.textColor = kNormalColor;
        _mainLabel.font = kNormalFont;
        [_mainLabel sizeToFit];
    }
    return _mainLabel;
}

- (UILabel *)dotLabel
{
    if (!_dotLabel) {
        _dotLabel = [[UILabel alloc] init];
        _dotLabel.backgroundColor = [UIColor clearColor];
        _dotLabel.textColor = kNormalColor;
        _dotLabel.font = kNormalFont;
        _dotLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dotLabel;
}

- (UIImageView *)checkIcon
{
    if (!_checkIcon) {
        _checkIcon = [UIImageView new];
        _checkIcon.backgroundColor = [UIColor clearColor];
        _checkIcon.image = [UIImage imageNamed:@"icon_item_checked"];
        _checkIcon.contentMode = UIViewContentModeScaleToFill;
        _checkIcon.hidden = YES;
    }
    return _checkIcon;
}

@end


#pragma mark - 通用的 省+市选中控件
@interface VECommonAreaSelectView () <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _rowHeight;
    BOOL    _isShowOverScreen;
}

@property (nonatomic, strong) UIView        *maskView;//左侧省
@property (nonatomic, strong) UIView        *contentView;//内容容器
@property (nonatomic, strong) UITableView   *provinceTableView;//左侧省
@property (nonatomic, strong) UITableView   *cityTableView;//右侧市
@property (nonatomic, strong) UIView        *toolView;//底部按钮view
@property (nonatomic, strong) UIButton      *resetButton;//重置按钮
@property (nonatomic, strong) UIButton      *confirmButton;//确定按钮

@property (nonatomic, assign) CGFloat       contentHeight;//内容高度

@property (nonatomic, strong) NSMutableArray <VEProvinceModel *> *localAllProvinceArray;//选中的省

@property (nonatomic, weak) VEProvinceModel  *currentProvince;//当前显示的省 这个model一定是localSelectedProvinceArray中的

@end

@implementation VECommonAreaSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _rowHeight = 50;
        [self addConstraint];
    }
    return self;
}

- (void)dealloc
{
    _showBlock = nil;
    _dismissBlock = nil;
    _confirmBlock = nil;
    _cancelBlock = nil;
    _resetBlock = nil;
    [_localAllProvinceArray removeAllObjects];
    _localAllProvinceArray = nil;
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
- (NSMutableArray<VEProvinceModel *> *)localAllProvinceArray
{
    if (!_localAllProvinceArray) {
        _localAllProvinceArray = [NSMutableArray array];
    }
    return _localAllProvinceArray;
}

#pragma mark - public methods
- (void)showOverScreen:(CGFloat)contentHeight withAnimation:(BOOL)animation
{
    _isShowOverScreen = YES;
    GCD_Main_Queue_Excute(^{
        self.hidden = NO;
        self.maskView.hidden = NO;
        self.contentView.hidden = YES;
        
        self.contentHeight = contentHeight;
        self.contentView.frame = CGRectMake(0, -contentHeight, CGRectGetWidth(self.bounds), self.contentHeight);
        
        self.contentView.hidden = NO;
        
        [self addSubview:self.contentView];
        
        [self.contentView layoutIfNeeded];
        VE_WS(ws);
        [UIView animateWithDuration:(animation?.3f:0) animations:^{
            ws.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(ws.bounds), ws.contentHeight);
        } completion:^(BOOL finished) {
            ws.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(ws.bounds), ws.contentHeight);
        }];
        if (self.showBlock) {
            self.showBlock();
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
        _cancelBlock(nil);
    }
    [self doDismiss:animation];
}

- (void)doDismiss:(BOOL)animation
{
    VE_WS(ws);
    _isShowOverScreen = NO;
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

- (void)reloadData:(NSArray<VEProvinceModel *> *)provinceArray
{
    if (![provinceArray isEqual:self.localAllProvinceArray]) {
        [self.localAllProvinceArray removeAllObjects];
        for (VEProvinceModel *md in provinceArray) {
            //复制
            VEProvinceModel *model = [[VEProvinceModel alloc] initWithModel:md];
            [self.localAllProvinceArray addObject:model];
        }
    }
    BOOL autoScroll = NO;
    if (!self.currentProvince) {
        autoScroll = YES;
        [self autoSelectProvince];
    }
    [self reloaList];
    if (autoScroll) {
        [self autoScroll];
    }
}

- (void)reloaList
{
    [self.provinceTableView reloadData];
    [self.cityTableView reloadData];
}

- (void)autoSelectProvince
{
    for (VEProvinceModel *mod in self.localAllProvinceArray) {
        if (!VE_IsArrEmpty(mod.selectCityCategoryIdArray)) {
            self.currentProvince = mod;
            break;
        }
    }
    if (!self.currentProvince && !VE_IsArrEmpty(self.localAllProvinceArray)) {
        self.currentProvince = [self.localAllProvinceArray firstObject];
    }
    
    [self autoScroll];
}

- (void)autoScroll
{
    GCD_Main_Queue_Excute(^{
        if (self.currentProvince && [self.localAllProvinceArray containsObject:self.currentProvince]) {
            NSInteger row = [self.localAllProvinceArray indexOfObject:self.currentProvince];
            if (row < [self.provinceTableView numberOfRowsInSection:0]) {
                [self.provinceTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
            }
        }
    });
}

- (void)selectProvinceIndex:(NSInteger)index
{
    if (VE_IsArrEmpty(self.localAllProvinceArray)) {
        self.currentProvince = nil;
    } else if (index < self.localAllProvinceArray.count) {
        self.currentProvince = VE_SafeObjectAtIndex(self.localAllProvinceArray, index);
    } else {
        self.currentProvince = VE_SafeObjectAtIndex(self.localAllProvinceArray, 0);
    }
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
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.contentHeight);
}

- (void)resetAction
{
    [self.localAllProvinceArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectCityCategoryIdArray = nil;
    }];
    [self reloaList];
    if (_resetBlock) {
        _resetBlock(self.localAllProvinceArray);
    }
}

- (void)confirmAction
{
    if (_confirmBlock) {
        _confirmBlock(self.localAllProvinceArray);
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
        _cancelBlock(nil);
    }
    [self doDismiss:YES];
}

//刷新特定省的所有市列表
- (void)reloadCityTableViewForProvince:(VEProvinceModel *)province
{
    VEProvinceModel *tableProvince = nil;
    for (VEProvinceModel *pro in self.localAllProvinceArray) {
        if ([VE_EMPTYSTRING(province.infoCategoryId) isEqualToString:VE_EMPTYSTRING(pro.infoCategoryId)]) {
            tableProvince = pro;
            break;
        }
    }
    if (tableProvince) {
        self.currentProvince = tableProvince;
        [self.cityTableView reloadData];
    }
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
        _contentView.clipsToBounds = YES;
        [_contentView addSubview:self.provinceTableView];
        [_contentView addSubview:self.cityTableView];
        [_contentView addSubview:self.toolView];
        
        VE_WS(ws);
        [self.provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.equalTo(ws.toolView.mas_top).offset(0);
            make.width.mas_equalTo(floor(Get375Width(125)));
        }];
        [self.cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.provinceTableView.mas_right).offset(0);
            make.top.bottom.equalTo(ws.provinceTableView);
            make.right.mas_equalTo(0);
        }];
        [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kToolViewHeight);
        }];
    }
    return _contentView;
}

- (UITableView *)provinceTableView
{
    if (!_provinceTableView) {
        _provinceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _provinceTableView.backgroundColor = kNormalBgColor;
        _provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _provinceTableView.delegate = self;
        _provinceTableView.dataSource = self;
        _provinceTableView.showsVerticalScrollIndicator = NO;
        _provinceTableView.alwaysBounceVertical = YES;
        _provinceTableView.clipsToBounds = YES;
        [_provinceTableView registerClass:[VEProvinceCell class] forCellReuseIdentifier:@"VEProvinceCell"];//省cell
        if (@available(iOS 11.0, *)) {
            _provinceTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _provinceTableView;
}

- (UITableView *)cityTableView
{
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cityTableView.backgroundColor = [UIColor clearColor];
        _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        _cityTableView.showsVerticalScrollIndicator = NO;
        _cityTableView.alwaysBounceVertical = YES;
        _cityTableView.clipsToBounds = YES;
        [_cityTableView registerClass:[VECommonCheckCell class] forCellReuseIdentifier:@"VECommonCheckCell"];//市cell
        if (@available(iOS 11.0, *)) {
            _cityTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _cityTableView;
}

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [UIView new];
        _toolView.backgroundColor = [UIColor clearColor];
        _toolView.clipsToBounds = YES;
        [_toolView addSubview:self.resetButton];
        [_toolView addSubview:self.confirmButton];
        VE_WS(ws);
        [self.resetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.equalTo(ws.toolView.mas_centerX).offset(-5);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.equalTo(ws.toolView.mas_centerX).offset(5);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _toolView;
}

- (UIButton *)resetButton
{
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.layer.cornerRadius = 3;
        _resetButton.layer.borderColor = HEX_RGB(0xDAE0E6).CGColor;
        _resetButton.layer.borderWidth = 1;
        _resetButton.backgroundColor = [UIColor whiteColor];
        [_resetButton addTarget:self
                         action:@selector(resetAction)
               forControlEvents:UIControlEventTouchUpInside];
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _resetButton.titleLabel.textColor = HEX_RGB(0x000000);
        [_resetButton setTitleColor:HEX_RGB(0x000000) forState:UIControlStateNormal];
    }
    return _resetButton;
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
    if (tableView == self.provinceTableView) {
        return self.localAllProvinceArray.count;
    } else if (tableView == self.cityTableView) {
        NSArray *cityArray = self.currentProvince.cityModelArray;
        return cityArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (tableView == self.provinceTableView) {//省列表
        
        VEProvinceModel *province = VE_SafeObjectAtIndex(self.localAllProvinceArray, row);
        
        VEProvinceCell *cell = [self.provinceTableView dequeueReusableCellWithIdentifier:@"VEProvinceCell"];
        [cell reloadCellData:province.infoCategoryName dotNumber:province.selectCityNumber isCountry:([province.infoCategoryId isEqualToString:kVE_CountryId_ALL])];
        
        if ([self.currentProvince.infoCategoryId isEqualToString:province.infoCategoryId]) {//高亮
            [cell setChosed:YES];
        } else {
            [cell setChosed:NO];
        }
        return cell;
        
    } else if (tableView == self.cityTableView) {//当前省的所有市列表
        
        NSArray *cityArray = self.currentProvince.cityModelArray;
        VEProvinceModel *city = VE_SafeObjectAtIndex(cityArray, row);
        
        VECommonCheckCell *cell = [self.cityTableView dequeueReusableCellWithIdentifier:@"VECommonCheckCell"];
        
        [cell reloadCellData:city.infoCategoryName];
        
        NSInteger count = [tableView numberOfRowsInSection:section];
        if (count && row == count - 1) {
            [cell setHideBottomLine:YES];
        } else {
            [cell setHideBottomLine:NO];
        }
        if ([self.currentProvince.selectCityCategoryIdArray containsObject:city.infoCategoryId]) {
            [cell setChosed:YES];
        } else {
            [cell setChosed:NO];
        }
        return cell;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.provinceTableView) {
        return _rowHeight;
    } else if (tableView == self.cityTableView) {
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
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (tableView == self.provinceTableView) {
        VEProvinceModel *province = VE_SafeObjectAtIndex(self.localAllProvinceArray, row);
        self.currentProvince = province;
        [self reloadData:self.localAllProvinceArray];
    } else if (tableView == self.cityTableView) {
        if (self.currentProvince) {
            NSArray *cityArray = self.currentProvince.cityModelArray;
            VEProvinceModel *city = VE_SafeObjectAtIndex(cityArray, row);
            if ([self.currentProvince.selectCityCategoryIdArray containsObject:city.infoCategoryId]) {
                [self.currentProvince removeCategoryId:city.infoCategoryId];
            } else {
                [self.currentProvince addCategoryId:city.infoCategoryId];
            }
            VE_WS(ws);
            if ([self.currentProvince.infoCategoryId isEqualToString:kVE_CountryId_ALL]) {
                /**1、如果是全国  需要取消所有的省市选择*/
                if ([city.infoCategoryId isEqualToString:kVE_CityId_ALL]) {
                    [self.localAllProvinceArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj.infoCategoryId isEqualToString:ws.currentProvince.infoCategoryId]) {
                            [obj removeAllCategoryId];
                        }
                    }];
                }
            } else {
                /**2、如果不是全国  需要取消全国选择*/
                __block VEProvinceModel *countryModel = nil;
                [self.localAllProvinceArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.infoCategoryId isEqualToString:kVE_CountryId_ALL]) {
                        countryModel = obj;
                        *stop = YES;
                    }
                }];
                if (countryModel) {
                    [countryModel removeAllCategoryId];
                }
            }
            [self reloadData:self.localAllProvinceArray];
        }
    }
}

@end
