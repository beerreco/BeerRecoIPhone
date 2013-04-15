//
//  NSThread+SendBlockToBackground.m
//  3i-Mind
//
//  Created by RLemberg on 3/7/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import "NSThread+SendBlockToBackground.h"

@implementation NSThread (SendBlockToBackground)

- (void) performBlock: (void (^)())block;
{
    [self performSelector: @selector(runBlock:)
                 onThread: self withObject: block waitUntilDone: NO];
}

- (void) runBlock: (void (^)())block;
{
    block();
}

@end
