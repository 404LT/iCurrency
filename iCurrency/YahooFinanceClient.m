//
//  YahooFinanceClient.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//
#import "ExchangeRate.h"
#import "YahooFinanceClient.h"
#import <AFNetworking.h>
NSString * yahoolURL=@"https://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json&";

@implementation YahooFinanceClient
- (NSData *)communicateWithYahooFinance
{
    NSLog(@"communicateWithYahooFinance is called");
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:yahoolURL] encoding:NSUTF8StringEncoding error:nil]dataUsingEncoding:NSUTF8StringEncoding];
    return jsonData;
}

- (NSDictionary *)getParsedDictionaryFromResults
{
    NSError *error2;
    
    //1、网络请求，最终返回一个JSON格式存储在NSData中
    NSMutableDictionary *parsedResults = [[NSMutableDictionary alloc]init];
    NSData *data = [[NSString stringWithContentsOfURL:[NSURL URLWithString:yahoolURL] encoding:NSUTF8StringEncoding error:nil]dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //2、解析JSON请求，最终把解析后的结果存放在一个字典里面
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
    
    if([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dictionary =(NSDictionary *) jsonObject;
        id mdic=[dictionary valueForKey:@"list"];
        if([mdic isKindOfClass:[NSDictionary class]])
        {
            id resourceArray=[(NSDictionary*)mdic valueForKey:@"resources"];
            
            if([resourceArray isKindOfClass:[NSArray class]]){
                NSArray *array=(NSArray *)resourceArray;
                //NSLog(array.description);
                for (int i=0; i<[array count]; i++) {
                    id resourceInArray=array[i];
                    if ([resourceInArray isKindOfClass:[NSDictionary class]]) {
                        id resource=[(NSDictionary *)resourceInArray valueForKey:@"resource"];
                        if([resourceInArray isKindOfClass:[NSDictionary class]]){
                            id fieldsInResource=[(NSDictionary *) resource valueForKey:@"fields"];
                            if([fieldsInResource isKindOfClass:[NSDictionary class]]){
                                NSString *name=[(NSDictionary *)fieldsInResource valueForKey:@"name"];
                                if([name rangeOfString:@"GOLD"].location !=NSNotFound || [name rangeOfString:@"SILVER"].location !=NSNotFound || [name rangeOfString:@"COPPER"].location !=NSNotFound || [name rangeOfString:@"PLATIN"].location !=NSNotFound || [name rangeOfString:@"PALLADIUM"].location !=NSNotFound)
                                    continue;
                                NSString *price_string=[(NSDictionary*)fieldsInResource valueForKey:@"price"];
                                NSNumber *price_number=[NSNumber numberWithFloat:[price_string floatValue]];
                                [parsedResults setValue:price_number forKey:name];
                            }
                        }
                    }
                }
                
                //3、把字典保存到本地
                
                ExchangeRate *exchange = [[ExchangeRate alloc]init];
                exchange.rates = parsedResults;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [exchange saveRates];
                    NSLog(@"获取汇率成功并保存 :");
                });
                return parsedResults;
            }
            
        }
    }
    return nil;
}


@end
