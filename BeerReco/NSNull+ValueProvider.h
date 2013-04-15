//
//  NSNull+ValueProvider.h
//  3i-Mind
//
//  Created by RLemberg on 2/7/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (ValueProvider)

- (char)charValue;
- (unsigned char)unsignedCharValue;
- (short)shortValue;
- (unsigned short)unsignedShortValue;
- (int)intValue;
- (unsigned int)unsignedIntValue;
- (long)longValue;
- (unsigned long)unsignedLongValue;
- (long long)longLongValue;
- (unsigned long long)unsignedLongLongValue;
- (float)floatValue;
- (double)doubleValue;
- (BOOL)boolValue;
- (NSString*)stringValue;

@end
