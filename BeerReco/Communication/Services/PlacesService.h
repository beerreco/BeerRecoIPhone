//
//  PlacesService.h
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PlaceM.h"

@interface PlacesService : NSObject

-(void)addPlace:(PlaceM*)place onComplete:(void (^)(PlaceM* place, NSError *error))onComplete;

-(void)updatePlace:(PlaceM*)place onComplete:(void (^)(PlaceM* place, NSError *error))onComplete;

@end
