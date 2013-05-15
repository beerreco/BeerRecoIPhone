//
//  PlaceTypeM.h
//  BeerReco
//
//  Created by RLemberg on 5/14/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceTypeM : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *updateDate;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end