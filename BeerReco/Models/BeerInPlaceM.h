//
//  BeerInPlaceM.h
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerInPlaceM : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) NSString *beerId;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic) double price;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
