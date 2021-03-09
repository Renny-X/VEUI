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

- (NSDictionary *)reMapKeys;

@end

NS_ASSUME_NONNULL_END
