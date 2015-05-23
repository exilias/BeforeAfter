//
//  BAAPIManager.m
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

#import "BAAPIManager.h"

#import <AFNetworking/AFNetworking.h>


@implementation BAAPIManager

+ (void)uploadGIFWithPath:(NSString *)path success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
{
    // create NSData from URL
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:path];
    
    // upload imageData
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                   URLString:@"http://yoshitooooom.xtwo.jp/api/post.php"
                                                                                  parameters:@{
                                                                                               @"user_id":@"1"
                                                                                               }
                                                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                       [formData appendPartWithFileData:imageData
                                                                                                   name:@"pic"
                                                                                               fileName:@"pic.gif"
                                                                                               mimeType:@"image/gif"];
                                                                   }
                                                                                       error:NULL];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    [manager.operationQueue addOperation:operation];
}


+ (void)getTimelineWithSuccess:(void (^)(NSArray *timelines))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary* param = @{};
    
    // execute post request
    [manager POST:@"http://yoshitooooom.xtwo.jp/api/get_timeline.php"
       parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[responseObject valueForKey:@"result"] boolValue]) {
             NSMutableArray *content_list;
             
             // decode json string
             content_list = [[NSMutableArray alloc]init];
             [content_list addObjectsFromArray:[responseObject valueForKey:@"content_list"]];
             
             if (success) {
                 success(content_list.copy);
             }
         } else {
             if (success) {
                 success(@[]);
             }
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failure) {
             failure(error);
         }
     }];
}

@end
