//
//  BaseEntityM.h
//  BeerReco
//
//  Created by RLemberg on 6/5/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntityM : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) NSString *contributorId;

-(id)initWithJson:(NSDictionary*)json;
-(NSMutableDictionary*)ToDictionary;

@end
