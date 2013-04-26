//
//  FileManagementService.m
//  BeerReco
//
//  Created by RLemberg on 4/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FileManagementService.h"

#define FileUploadService @"FileUpload/UploadFileHandler.ashx"

#define QueryParam_FileName @"fileName"
#define QueryParam_ImageOf @"imageOf"
#define QueryParam_ItemId @"itemId"

#define ImageOfBeer @"beer"

@implementation FileManagementService

-(void)uploadFile:(void (^)(NSString* filePath, NSError *error))onComplete
{
    NSString* fileName = @"beerreco_icon.png";
    
    NSDictionary* params = @{QueryParam_FileName:fileName,QueryParam_ImageOf: ImageOfBeer, QueryParam_ItemId: [NSString uuid]};
    
    NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURL_FileServer, FileUploadService]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
    
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:fileName]);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
    {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (onComplete)
        {
            onComplete(operation.responseString, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (onComplete)
        {
            onComplete(nil, error);
        }
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
}

@end
