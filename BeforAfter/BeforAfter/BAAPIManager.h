//
//  BAAPIManager.h
//  BeforAfter
//
//  Created by 石井晃 on 2015/05/23.
//  Copyright (c) 2015年 Mobile Interaction Researcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BAAPIManager : NSObject

+ (void)uploadGIFWithPath:(NSString *)path success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
