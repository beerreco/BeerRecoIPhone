//
//  PlaceView.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AreaM.h"
#import "PlaceM.h"
#import "PlaceTypeM.h"

@interface PlaceViewM : NSObject

@property (nonatomic, strong) PlaceM* place;
@property (nonatomic, strong) AreaM* area;
@property (nonatomic, strong) PlaceTypeM* placeType;

-(id)initWithJson:(NSDictionary*)json;
-(NSDictionary*)ToDictionary;

@end
