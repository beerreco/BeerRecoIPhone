//
//  BeerInPlaceM.h
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntityM.h"

@interface BeerInPlaceM : BaseEntityM

@property (nonatomic, strong) NSString *beerId;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic) double price;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
