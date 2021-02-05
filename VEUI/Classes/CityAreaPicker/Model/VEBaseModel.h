//
//  VEBaseModel.h
//  Vedeng
//
//  Created by Drake on 2020/11/11.
//  Copyright © 2020 Vedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kVE_TypeId_ALL                 (@"-1")//招标类型的全部：固定id
#define kVE_CountryId_ALL              (@"1")//全国的：id
#define kVE_CityId_ALL                 (@"1")//全部城市的：固定id
#define kVE_TimeId_ALL                 (@"0")//全部更新时间类型的：固定id

@interface VEBaseModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
