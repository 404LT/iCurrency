//
//  LWTHttpRequest.m
//  iCurrency
//
//  Created by 陆文韬 on 16/6/12.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "LWTHttpRequest.h"
#import <AFNetworking.h>
@implementation LWTHttpRequest

+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //获得请求管理者
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    //申明返回的结果是text html类型
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    //发送GET请求
    [manage GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress){
    }success:^(NSURLSessionDataTask * _Nonnull task,id _Nullable responseObject){
        if (success) {
            success(responseObject);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error){
        if (failure) {
            failure(error);
        }
    }];
}

+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //获得请求管理者
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置超时时间为6S
    manage.requestSerializer.timeoutInterval = 6;
    
    //发送POST请求
    [manage POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}




@end
