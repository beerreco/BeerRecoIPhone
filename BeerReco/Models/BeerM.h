//
//  BeerM.h
//  BeerReco
//
//  Created by RLemberg on 4/3/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerM : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) NSString *drinkType;
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *brewery;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *madeOf;
@property (nonatomic) float alchoholPrecent;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *beerIconUrl;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
