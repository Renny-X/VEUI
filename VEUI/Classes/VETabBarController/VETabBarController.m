//
//  VETabBarController.m
//  FBSnapshotTestCase
//
//  Created by Coder on 2021/6/10.
//

#import "VETabBarController.h"
#import "NSObject+VEUI.h"

@interface VETabBarController ()

@property(nonatomic, strong)NSMutableArray *_kvoArr;

@end

@implementation VETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:@"selectedViewController" options:NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc {
    if ([self containObserver:self forKeyPath:@"selectedViewController"]) {
        [self removeObserver:self forKeyPath:@"selectedViewController"];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedViewController"]) {
        NSInteger index = 0;
        id vc = [change valueForKey:@"old"];
        if (vc == nil) {
            return;
        }
        for (int i = 0; i < self.childViewControllers.count; i++) {
            id sub = self.childViewControllers[i];
            if ([sub isEqual:vc]) {
                index = i;
                break;
            }
        }
        self.lastSelectedIndex = index;
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
