//
//  LWTBaseRequest.h
//  iCurrency
//
//  Created by 陆文韬 on 16/6/12.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWTBaseRequest : NSObject
/**
 *  返回result下item_list 数组模型
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param resultClass  需要转换返回的数据模型
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param warn         请求失败后警告提示语（是一个字符串，直接弹出显示即可）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param tokenInvalid token过期后的回调（请将token后想做的事情写到这个block中）
 */
+ (void)getWithUrl:(NSString *)url
            param:(id)param
      resultClass:(Class)resultClass
          success:(void (^)(id))success
          failure:(void (^)(NSError *))failure;

+ (void)postItemListWithUrl:(NSString *)url
                      param:(id)param
                resultClass:(Class)resultClass
                    success:(void (^)(id result))success
                       warn:(void (^)(NSError *error))failure
               tokenInvalid:(void (^)())tokenInvalid;

+ (void)postItemListHUDWithUrl:(NSString *)url
                         param:(id)param
                   resultClass:(Class)resultClass
                       success:(void (^)(id result))success
                          warn:(void (^)(NSString *warnMsg))warn
                       failure:(void (^)(NSError *error))failure
                  tokenInvalid:(void (^)())tokenInvalid;

+ (void)postResultWithUrl:(NSString *)url
                    param:(id)param
              resultClass:(Class)resultClass
                  success:(void (^)(id result))success
                     warn:(void (^)(NSString *warnMsg))warn
                  failure:(void (^)(NSError *error))failure
             tokenInvalid:(void (^)())tokenInvalid;

+ (void)postResultHUDWithUrl:(NSString *)url param:(id)param
                 resultClass:(Class)resultClass
                     success:(void (^)(id result))success
                        warn:(void (^)(NSString *warnMsg))warn
                     failure:(void (^)(NSError *error))failure
                tokenInvalid:(void (^)())tokenInvalid;




@end
