//
//  NSString+URLEncoding.h
//  3i-Mind
//
//  Created by Ralph Stohn on 2/25/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)URLEncodedString;
- (NSString*) URLDecodedString;


@end
