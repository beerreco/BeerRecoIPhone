//
//  PlaceTypeService.h
//  BeerReco
//
//  Created by RLemberg on 5/14/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldUpdateDataM.h"

@interface PlaceTypeService : NSObject

-(void)getAllPlaceTypes:(void (^)(NSMutableArray* placeTypes, NSError *error))onComplete;

-(void)getPlacesByPlaceType:(NSString*)placeTypeId oncComplete:(void (^)(NSMutableArray* places, NSError *error))onComplete;

-(void)addPlaceType:(PlaceTypeM*)placeType onComplete:(void (^)(PlaceTypeM* placeType, NSError *error))onComplete;

-(void)updatePlaceType:(FieldUpdateDataM*)fieldUpdateData onComplete:(void (^)(NSError *error))onComplete;

-(void)deletePlaceType:(NSString*)placeTypeId onComplete:(void (^)(NSError *error))onComplete;

@end
