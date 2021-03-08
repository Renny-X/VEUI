//
//  VEProvinceModel.m
//  Vedeng
//
//  Created by Drake on 2020/11/4.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import "VEProvinceModel.h"
#import "VEConstant.h"

@implementation VEProvinceModel

- (instancetype)copyWithZone:(NSZone *)zone
{
    VEProvinceModel *copy = [[[self class] allocWithZone:zone] init];
    copy.infoCategoryId = self.infoCategoryId.mutableCopy;
    copy.infoCategoryName = self.infoCategoryName.mutableCopy;
    copy.parentId = self.parentId.mutableCopy;
    NSMutableArray *cityModelArray = [NSMutableArray arrayWithCapacity:self.cityModelArray.count];
    [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cityModelArray addObject:obj.mutableCopy];
    }];
    copy.cityModelArray = cityModelArray;
    copy.selectCityCategoryIdArray = self.selectCityCategoryIdArray.mutableCopy;
    return copy;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    VEProvinceModel *copy = [[[self class] allocWithZone:zone] init];
    copy.infoCategoryId = self.infoCategoryId.mutableCopy;
    copy.infoCategoryName = self.infoCategoryName.mutableCopy;
    copy.parentId = self.parentId.mutableCopy;
    NSMutableArray *cityModelArray = [NSMutableArray arrayWithCapacity:self.cityModelArray.count];
    [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cityModelArray addObject:obj.mutableCopy];
    }];
    copy.cityModelArray = cityModelArray;
    copy.selectCityCategoryIdArray = self.selectCityCategoryIdArray.mutableCopy;
    return copy;
}

- (void)dealloc
{
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.infoCategoryId = VE_EncodeStringFromDic(dict, @"infoCategoryId");
        self.infoCategoryName = VE_EncodeStringFromDic(dict, @"infoCategoryName");
        self.parentId = VE_EncodeStringFromDic(dict, @"parentId");
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json
{
    if (self = [super init]) {
        self.infoCategoryId = VE_EncodeStringFromDic(json, @"infoCategoryId");
        self.infoCategoryName = VE_EncodeStringFromDic(json, @"infoCategoryName");
        self.parentId = VE_EncodeStringFromDic(json, @"parentId");
        
        NSArray <NSDictionary *>*cityModelArray = VE_EncodeArrayFromDic(json, @"cityModelArray");
        
        if (cityModelArray && !VE_IsArrEmpty(cityModelArray)) {
            NSMutableArray *cityModels = [NSMutableArray array];
            [cityModelArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull json, NSUInteger idx, BOOL * _Nonnull stop) {
                VEProvinceModel *mod = [[VEProvinceModel alloc] initWithJson:json];
                [cityModels addObject:mod];
            }];
            self.cityModelArray = cityModels;
        } else {
            self.cityModelArray = @[];
        }
    }
    return self;
}

- (NSDictionary *)json
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setValue:VE_EMPTYSTRING(self.infoCategoryId) forKey:@"infoCategoryId"];
    [json setValue:VE_EMPTYSTRING(self.infoCategoryName) forKey:@"infoCategoryName"];
    [json setValue:VE_EMPTYSTRING(self.parentId) forKey:@"parentId"];
    
    if (!VE_IsArrEmpty(self.cityModelArray)) {
        NSMutableArray *cityModelArray = [NSMutableArray array];
        [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [cityModelArray addObject:[obj json]];
        }];
        [json setValue:cityModelArray forKey:@"cityModelArray"];
    }
    
    return json;
}

- (instancetype)initWithModel:(VEProvinceModel *)province
{
    if (self = [super init]) {
        self.infoCategoryId = province.infoCategoryId.mutableCopy;
        self.infoCategoryName = province.infoCategoryName.mutableCopy;
        self.parentId = province.parentId.mutableCopy;
        
        if (province.cityModelArray.count) {
            NSMutableArray *citys = [NSMutableArray array];
            [province.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [citys addObject:[[VEProvinceModel alloc] initWithModel:obj]];
            }];
            self.cityModelArray = citys;
        }
        
        [self.selectCityCategoryIdArray addObjectsFromArray:province.selectCityCategoryIdArray.mutableCopy];
    }
    return self;
}

- (void)addCategoryId:(NSString *)categoryId
{
    VE_WS(ws);
    if (!categoryId.length) {
        return;
    }
    __block NSUInteger index = -1;
    if (!self.cityModelArray.count) {
        return;
    }
    [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.infoCategoryId isEqualToString:categoryId]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0) {
        if (![self.selectCityCategoryIdArray containsObject:categoryId]) {
            [self.selectCityCategoryIdArray addObject:categoryId];
        }
    }
    if ([categoryId isEqualToString:kVE_CityId_ALL]) {
        //如果选中的是 全部的1  需要全部选中市
        [self.selectCityCategoryIdArray removeAllObjects];
        [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [ws.selectCityCategoryIdArray addObject:obj.infoCategoryId];
        }];
    }
    
    __block VEProvinceModel *existAllModel = nil;
    [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull mod, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([mod.infoCategoryId isEqualToString:kVE_CityId_ALL]) {
            existAllModel = mod;
            *stop = YES;
        }
    }];
    if (existAllModel && self.selectCityCategoryIdArray.count >= self.cityModelArray.count - 1) {
        //全部选中
        [self.selectCityCategoryIdArray removeAllObjects];
        [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull mod, NSUInteger idx, BOOL * _Nonnull stop) {
            [ws.selectCityCategoryIdArray addObject:mod.infoCategoryId];
        }];
    }
}

- (void)removeCategoryId:(NSString *)categoryId
{
    if (!categoryId.length) {
        return;
    }
    __block NSUInteger index = -1;
    if (!self.cityModelArray.count) {
        return;
    }
    [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.infoCategoryId isEqualToString:categoryId]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0) {
        if ([self.selectCityCategoryIdArray containsObject:categoryId]) {
            [self.selectCityCategoryIdArray removeObject:categoryId];
        }
    }
    if (![categoryId isEqualToString:kVE_CityId_ALL]) {
        //如果移除的不是 全部的1  需要移除1
        __block VEProvinceModel *allCity = nil;
        [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.infoCategoryId isEqualToString:kVE_CityId_ALL]) {
                allCity = obj;
                *stop = YES;
            }
        }];
        if (allCity && [self.selectCityCategoryIdArray containsObject:allCity.infoCategoryId]) {
            [self.selectCityCategoryIdArray removeObject:allCity.infoCategoryId];
        }
    } else {//如果取消全部选择
        [self.selectCityCategoryIdArray removeAllObjects];
    }
}

- (void)removeAllCategoryId
{
    [self.selectCityCategoryIdArray removeAllObjects];
}

#pragma mark - property
- (NSMutableArray<NSString *> *)selectCityCategoryIdArray
{
    if (!_selectCityCategoryIdArray) {
        _selectCityCategoryIdArray = [NSMutableArray array];
    }
    return _selectCityCategoryIdArray;
}

- (NSInteger)selectCityNumber
{
    //这里的数量需要去除 全部的那个
    if (self.selectCityCategoryIdArray.count == 1 && [self.selectCityCategoryIdArray.firstObject isEqualToString:kVE_CityId_ALL]) {
        //全国或者全省就返回1
        return 1;
    }
    if ([self.selectCityCategoryIdArray containsObject:kVE_CityId_ALL]) {
        return self.selectCityCategoryIdArray.count - 1;
    }
    return self.selectCityCategoryIdArray.count;
}

- (NSArray<NSString *> *)cityIdArray
{
    NSMutableArray *ids = [NSMutableArray array];
    [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!VE_IsStringEmpty(obj.infoCategoryId)) {
            [ids addObject:obj.infoCategoryId];
        }
    }];
    return ids;
}

- (NSArray<NSString *> *)cityNameArray
{
    NSMutableArray *names = [NSMutableArray array];
    [self.cityModelArray enumerateObjectsUsingBlock:^(VEProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!VE_IsStringEmpty(obj.infoCategoryId)) {
            [names addObject:obj.infoCategoryName];
        }
    }];
    return names;
}

@end
