//
//  AFSingleTon.h
//  AFNetworkingSingleton
//
//  Created by Thabresh on 8/29/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"
typedef void(^SuccessBlock)(AFHTTPRequestOperation* operation, id response);
typedef void(^FailureBlock)(AFHTTPRequestOperation* operation, NSError *error);
@interface AFSingleTon : NSObject
+ (AFSingleTon *)sharedClient;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) dispatch_queue_t serializationQueue;
- (AFHTTPRequestOperation*)SessionCall:(NSDictionary*)params MethodName:(NSString*)MName success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
