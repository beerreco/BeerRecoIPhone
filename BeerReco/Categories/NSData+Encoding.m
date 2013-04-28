//
//  NSData+Encoding.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "NSData+Encoding.h"

@implementation NSData (Encoding)

- (NSString*)UTF8String
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end
