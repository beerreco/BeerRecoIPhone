//
//  FileManagementService.h
//  BeerReco
//
//  Created by RLemberg on 4/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ImageOfPlace @"place"
#define ImageOfBeer @"beer"

@interface FileManagementService : NSObject

-(void)uploadFile:(UIImage*)imageFile ofEntity:(NSString*)imageOf onComplete:(void (^)(NSString* filePath, NSError *error))onComplete;

@end
