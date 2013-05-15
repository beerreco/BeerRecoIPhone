//
//  AreasService.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AreaM.h"
#import "PlaceViewM.h"
#import "FieldUpdateDataM.h"

@interface AreasService : NSObject

-(void)getAllAreas:(void (^)(NSMutableArray* areas, NSError *error))onComplete;

-(void)getPlacesByArea:(NSString*)areaId oncComplete:(void (^)(NSMutableArray* places, NSError *error))onComplete;

-(void)addArea:(AreaM*)area onComplete:(void (^)(AreaM* area, NSError *error))onComplete;

-(void)updateArea:(FieldUpdateDataM*)fieldUpdateData onComplete:(void (^)(NSError *error))onComplete;

@end
