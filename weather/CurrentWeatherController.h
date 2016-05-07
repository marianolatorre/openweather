//
//  CurrentWeatherController.h
//  weather
//
//  Created by mariano latorre on 06/05/2016.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ForecastController.h"
#import "ForecastReport.h"

@interface CurrentWeatherController : ForecastController


- (void)retrieveCurrentWeatherWithCompletionBlock:(void (^)(ForecastReport *))successBlock failureBlock:(void (^)(NSError *))failureBlock;

@end


