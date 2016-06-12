//
//  LWTHttpRequest.h
//  iCurrency
//
//  Created by 陆文韬 on 16/6/12.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWTHttpRequest : NSObject

/*
 GET请求
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+(void)get:(NSString *)url
    params:(NSDictionary *)params
   success:(void (^)(id responseObj))success
   failure:(void (^)(NSError *error))failure;

/*
 POST 请求
 */

+(void)post:(NSString *)url
     params:(NSDictionary *)params
    success:(void (^)(id responseObj))success
    failure:(void (^)(NSError *error))failure;





@end
