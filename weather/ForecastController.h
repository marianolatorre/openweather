//
//  ForecastController.h
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol ForecastControllerDelegate

- (void)forecastDataRetrieved:(NSArray *)results;
- (void)forecastFailedWithError:(NSError *)error;

@end

@interface ForecastController : NSObject

@property (nonatomic, weak) id<ForecastControllerDelegate> forecastControllerDelegate;

- (void)retrieveForecast;

@end
