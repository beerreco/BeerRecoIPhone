//
//  NSThread+SendBlockToBackground.h
//  3i-Mind
//
//  Created by RLemberg on 3/7/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (SendBlockToBackground)

- (void) performBlock: (void (^)())block;

@end
