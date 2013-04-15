//
//  NSString+IsEmpty.m
//  3i-Mind
//
//  Created by Ralph Stohn on 2/24/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import "NSString+IsEmpty.h"

@implementation NSString (IsEmpty)

+ (BOOL) isNullOrEmpty:(NSString*)string
{
    return (self == nil || [string isKindOfClass:[NSNull class]] || string.length == 0);
}

@end
