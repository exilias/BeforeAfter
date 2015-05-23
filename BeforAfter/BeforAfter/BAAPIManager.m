//
//  BAAPIManager.m
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

#import "BAAPIManager.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworking.h>


@implementation BAAPIManager

+ (void)uploadGIFWithPath:(NSString *)path success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    // set network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD showWithStatus:@"通信中" maskType:SVProgressHUDMaskTypeBlack];

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
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             /// dismiss indicator
                                                                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                             
//                                                                             // dismiss view, show success
//                                                                             [self dismissViewControllerAnimated:YES completion:^{
//                                                                                 [SVProgressHUD showSuccessWithStatus:@"投稿しました"];
//                                                                             }];
                                                                             [SVProgressHUD showSuccessWithStatus:@"投稿しました"];
                                                                             NSLog(@"success: %@, %@", [responseObject class], responseObject);
                                                                             
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             //NSLog(@"Error: %@", error);
                                                                             
                                                                             [SVProgressHUD showErrorWithStatus:@"アップロード失敗．．．"];
                                                                         }];
    
    
    [manager.operationQueue addOperation:operation];
    
}

@end
