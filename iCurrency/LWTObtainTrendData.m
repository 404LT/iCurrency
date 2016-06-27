//
//  LWTObtainTrendData.m
//  iCurrency
//
//  Created by 陆文韬 on 16/6/25.
//  Copyright © 2016年 LunTao. All rights reserved.
//

/* 
 //可用于查询历史数据的URL：
http://query.yahooapis.com/v1/public/yql?q=select%20Adj_Close%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D%20%22YHOO%22%20and%20startDate%20%3D%20%222013-01-01%22%20and%20endDate%20%3D%20%222013-02-06%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=
 1、根据所传入的国家名称，时间范围，获取所选国家对美元的汇率，并且存入一个数组
 2、字典里面的内容按照 最高价 最低价 收盘价 分别存入不同的数组
 

 并不需要把每一天的最高最低价格给分别抽出一个数组中的，因为看一段时间（比如三个月）的最高最低价肯定是该事件段内，每日收盘价的最高或者最低价
 写个方法计算出一段时间内的最高最低价格就行了
 
 */

#import "LWTObtainTrendData.h"
#import <AFNetworking.h>

@implementation LWTObtainTrendData

//定义获取的URL
#define YAHOOURL_YQL @"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D%20%22"
#define YAHOOURL_COUNTRY @"%3DX%22%20and%20"//国家X为美国
#define YAHOOURL_DATE_START @"startDate%20%3D%20%22"//后面接一个开始日期的字符串
#define YAHOOURL_DATE_END @"%22%20and%20endDate%20%3D%20%22"//后面接一个结束日期的字符串
#define YAHOOURL_DATE_FORMAT @"%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="//返回json格式数据

/*
 测试用例:
 NSString *startDate = @"2016-06-20";
 NSString *endDate = @"2016-06-24";
 NSString *countryName = @"CNY";
 [self getDataFromYahoo:countryName startDate:startDate endDate:endDate];
 
*/

- (void)getDataFromYahoo:(NSString *)country
               startDate:(NSString *)startDate
                 endDate:(NSString *)endDate
{
    NSMutableArray *historyCloseQuotes = [[NSMutableArray alloc]init];
    //根据所传入的国家名称，时间范围，获取所选国家对美元的汇率，并且存入一个数组
    NSMutableString* query = [[NSMutableString alloc] init];
    [query appendString:YAHOOURL_YQL];
    [query appendFormat:@"%@", country];
    [query appendString:YAHOOURL_COUNTRY];
    [query appendString:YAHOOURL_DATE_START];
    [query appendString:startDate];
    [query appendString:YAHOOURL_DATE_END];
    [query appendString:endDate];
    [query appendString:YAHOOURL_DATE_FORMAT];
    NSLog(@"Query: %@", query);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:query
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *_Nonnull task,id responseObje)
     {
         NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObje options:NSJSONReadingMutableLeaves error:nil];
         
         NSLog(@"dic is %@",resultDic);
         
         //历史收盘价
         
         NSArray *quoteEntries = [resultDic valueForKeyPath:@"query.results.quote"];
         NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
         [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
         if ([quoteEntries isKindOfClass:[NSArray class]]) {
             for (NSDictionary *quoteEntry in quoteEntries) {
                 
                 [historyCloseQuotes addObject:[formatter numberFromString:quoteEntry[@"Adj_Close"]]];
                 
             }
             //NSLog(@"historyCloseQuotes is %@",historyCloseQuotes);
         }
         
         
         
         
     }failure:^(NSURLSessionDataTask *_Nonnull task,NSError *error){
         NSLog(@"网络故障-reason :%@",error);
     }];
    
}

//以下函数用来抽离出字典当中的数据分别存储在不同的数组当中



@end
