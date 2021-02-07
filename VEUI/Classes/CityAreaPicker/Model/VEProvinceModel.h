//
//  VEProvinceModel.h
//  Vedeng
//
//  Created by Drake on 2020/11/4.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEProvinceModel : VEBaseModel <NSCopying,NSMutableCopying>

//-------------------------------------//
@property (nonatomic, copy) NSString *infoCategoryId;//如果是全国 1
@property (nonatomic, copy) NSString *infoCategoryName;//如果是全国 全国
@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, strong) NSArray <VEProvinceModel *> *cityModelArray;//所有城市 //如果是全国 一个city cityId=1
//---------以上4个属性是必须存在的----------//


@property (nonatomic, strong) NSMutableArray <NSString *> *selectCityCategoryIdArray;//所有选中的城市id


/**只读属性**/
@property (nonatomic, assign,readonly) NSInteger selectCityNumber;//选中的城市数量
@property (nonatomic, strong,readonly) NSArray <NSString *> *cityIdArray;//所有城市id
@property (nonatomic, strong,readonly) NSArray <NSString *> *cityNameArray;//所有城市名称

- (instancetype)initWithDictionary:(NSDictionary *)dict;//通过dict初始化，不包含城市dict
- (instancetype)initWithModel:(VEProvinceModel *)province;//拷贝城市model

- (void)addCategoryId:(NSString *)categoryId;//添加城市id
- (void)removeCategoryId:(NSString *)categoryId;//移除城市id
- (void)removeAllCategoryId;//移除城市id

//通过json对象初始化，json中包含城市json
- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)json;//对象转json，json中包含城市json

@end

NS_ASSUME_NONNULL_END
