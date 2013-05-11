//
//  BeerInPlaceViewM.h
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeerInPlaceM.h"
#import "BeerViewM.h"
#import "PlaceViewM.h"

@interface BeerInPlaceViewM : NSObject

@property (nonatomic, strong) BeerViewM* beerView;
@property (nonatomic, strong) PlaceViewM* placeView;
@property (nonatomic, strong) BeerInPlaceM* beerInPlace;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
