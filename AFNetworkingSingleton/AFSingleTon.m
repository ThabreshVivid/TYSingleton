//
//  AFSingleTon.m
//  AFNetworkingSingleton
//
//  Created by Thabresh on 8/29/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//
#import "AFSingleTon.h"
static NSString * const WebServiceAPIBaseURLString = @"http://api.geonames.org/";

@implementation AFSingleTon
+ (AFSingleTon *)sharedClient {
    static AFSingleTon *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFSingleTon alloc] initWithBaseURL:[NSURL URLWithString:WebServiceAPIBaseURLString]];
    });    
    return _sharedClient;
}
- (id)initWithBaseURL:(NSURL *)url {
        self = [super init];
        if (!self) {
            return nil;
        }
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-www-form-urlencoded",@"application/json", nil];
        self.serializationQueue = dispatch_queue_create("Serialization Queue", DISPATCH_QUEUE_CONCURRENT);   
    return self;
}
#pragma mark
#pragma mark - SessionCall
- (AFHTTPRequestOperation*)SessionCall:(NSDictionary*)params MethodName:(NSString*)MName success:(SuccessBlock)success failure:(FailureBlock)failure {
    return [self operationForPostPath:MName parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleJSONArrayResponse:responseObject
                            operation:operation
                              success:success
                              failure:failure];
        
    } failure:failure];
}
#pragma mark
- (AFHTTPRequestOperation*) operationForPostPath:(NSString*)path
                                      parameters:(NSDictionary*)params
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure {
    
    //GET Method
    AFHTTPRequestOperation *oper = [self.manager GET:path parameters:params success:success failure:failure];
    // POST Method
    //AFHTTPRequestOperation *oper = [self.manager POST:path parameters:params success:success failure:failure];
    return oper;
    
}

-(void) handleJSONArrayResponse:(NSDictionary*)response
                      operation:(AFHTTPRequestOperation*)operation
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure
{
    
    NSArray *data = [response mutableCopy];
    dispatch_after(DISPATCH_TIME_NOW, self.serializationQueue, ^{
        NSError *error = nil;
        NSArray *models = data;
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{
            if (error) {
                failure(operation, error);
            } else {
                success(operation, models);
            }
        });
    });
}
@end
