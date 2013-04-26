//
//  FileManagementService.h
//  BeerReco
//
//  Created by RLemberg on 4/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagementService : NSObject

-(void)uploadFile:(void (^)(NSString* filePath, NSError *error))onComplete;

@end
