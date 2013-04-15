//
//  NSObject+Blocks.h
//  3i-Mind
//
//  Created by Ralph Stohn on 3/6/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block afterDelay:(CGFloat)delay;

@end
