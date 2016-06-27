//
//  LWTObtainTrendData.h
//  iCurrency
//
//  Created by 陆文韬 on 16/6/25.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWTObtainTrendData : NSObject


- (void)getDataFromYahoo:(NSString *)country
               startDate:(NSString *)startDate
                 endDate:(NSString *)endDate;

@end
