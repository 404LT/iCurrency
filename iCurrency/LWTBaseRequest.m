//
//  LWTBaseRequest.m
//  iCurrency
//
//  Created by 陆文韬 on 16/6/12.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "LWTBaseRequest.h"
#import "LWTHttpRequest.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>

@implementation LWTBaseRequest

+(void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *params = [param mj_keyValues];
    
    [LWTHttpRequest get:url params:[self requestParams:params] success:^(id responseObj){
        if (success) {
            id result = [resultClass mj_objectWithKeyValues:responseObj];
            success(result);
        }
    }failure:^(NSError *error){
        if (failure) {
            failure(error);
        }
    }];
}

//返回result下 item_list数组模型






/*
 组合请求参数
 @param dict外部参数字典
 @return 返回组合参数
 */

+ (NSMutableDictionary *)requestParams:(NSDictionary *)dict
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    return params;
}
@end
