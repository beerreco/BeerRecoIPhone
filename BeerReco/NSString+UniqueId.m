//
//  NSString+UniqueId.m
//  3i-Mind
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import "NSString+UniqueId.h"

@implementation NSString (UniqueId)

+ (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

@end
