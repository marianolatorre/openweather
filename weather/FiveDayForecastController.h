//
//  FiveDayForecastController.h
//  weather
//
//  Created by mariano latorre on 06/05/2016.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForecastController.h"
#import <RestKit/RestKit.h>


@interface FiveDayForecastController : ForecastController

- (void)retrieveFiveDayForecastWithCompletionBlock:(void (^)(NSArray *))successBlock failureBlock:(void (^)(NSError *))failureBlock;

+ (NSArray *)processFiveDayForecastReport:(NSArray *)forecastArray;

@end
