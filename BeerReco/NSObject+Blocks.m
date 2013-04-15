//
//  NSObject+Blocks.m
//  3i-Mind
//
//  Created by Ralph Stohn on 3/6/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)

- (void)performBlock:(void (^)())block
{
    block();
}

- (void)performBlock:(void (^)())block afterDelay:(CGFloat)delay
{
    void (^block_)() = [block copy]; // autorelease this if you're not using ARC
    [self performSelector:@selector(performBlock:) withObject:block_ afterDelay:delay];
}

@end
