//
//  VEModel.h
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 * 重定向key { "model.property": "data.key" }
 */
- (NSDictionary *)reMapKeys;
/**
 * 重定向Value，返回 手动处理后的 Value，nil时 不处理
 */
- (BOOL)reMapValue:(id)value onKey:(NSString *)key;
/**
 * 指定属性对应的ClassName { "model.property": "class name" }
 */
- (NSDictionary *)valueOnModelClass;

@end

NS_ASSUME_NONNULL_END
