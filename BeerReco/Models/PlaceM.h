//
//  PlaceM.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceM : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *placeTypeId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *geoLocation;
@property (nonatomic, strong) NSString *placeIconUrl;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
