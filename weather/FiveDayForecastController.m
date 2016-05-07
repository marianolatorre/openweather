//
//  FiveDayForecastController.m
//  weather
//
//  Created by mariano latorre on 06/05/2016.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import "FiveDayForecastController.h"
#import "ForecastReport.h"

#define FORECAST_URL @"http://api.openweathermap.org/data/2.5/forecast?q=London,us&units=metric&appid=c61fc1f0ca61a12becafe12a6527a18b"

@implementation FiveDayForecastController


- (void)retrieveFiveDayForecastWithCompletionBlock:(void (^)(NSArray *))successBlock failureBlock:(void (^)(NSError *))failureBlock{
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    RKObjectMapping *forecastMapping = [RKObjectMapping mappingForClass:[ForecastReport class]];
    [forecastMapping addAttributeMappingsFromDictionary:@{
                                                          @"dt_txt" : @"date",
                                                          @"dt" : @"dt"
                                                          }];
    
    [self mainMappingWithMapping:forecastMapping];
    [self weatherMappingWithMapping:forecastMapping];
        
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:forecastMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@"list"
                                                                                       statusCodes:nil];
    
    NSURL *url = [NSURL URLWithString:FORECAST_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self configureDateFormatter];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        if (successBlock){
            successBlock([[result array] copy]);
        }

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
    [operation start];
    
}

+ (NSArray *)splitForecastByDay:(NSArray *)forecastArray{
    
    //TODO: uni test this
    
    __block NSArray *forecastPerDay = @[[NSMutableArray new],
                                        [NSMutableArray new],
                                        [NSMutableArray new],
                                        [NSMutableArray new],
                                        [NSMutableArray new],
                                        [NSMutableArray new]];
    
    NSDate *firstDate = [[forecastArray firstObject] date];
    
    NSInteger firstDay = [self dateDay:firstDate];
    
    
    [forecastArray enumerateObjectsUsingBlock:^(ForecastReport *forecastReport, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger forecastDay = [self dateDay:[forecastReport date]];
        NSInteger index = forecastDay - firstDay;
        NSMutableArray *dayArray = index < 6 ? forecastPerDay[index] : nil;
        [dayArray addObject:forecastReport];
    }];
    
    return forecastPerDay.copy;
}

+ (NSInteger)dateDay:(NSDate *)date{

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:date];
    return dateComponents.day;
}

+ (NSDictionary *)maxMinTempInForecastPeriod:(NSArray *)forecastArray{
    //TODO: uni test this
    
    float xmax = -MAXFLOAT;
    float xmin = MAXFLOAT;
    
    for (ForecastReport *forecast in forecastArray) {
        
        float x = [[forecast mainReport] temp].floatValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }

    return @{
             @"min" : [NSNumber numberWithFloat:xmin],
             @"max" : [NSNumber numberWithFloat:xmax]
             };
}

+ (NSArray *)processFiveDayForecastReport:(NSArray *)forecastArray{
    //TODO: uni test this
    
    // needs extra safety checks, edge cases not covered
    
    // using dictionary to speed up prototype, might be better to have proper object models for the expected report format.
    
    NSArray *splittedByDayForecast = [FiveDayForecastController splitForecastByDay:forecastArray];
    
    __block NSMutableArray *processedReport = [NSMutableArray new];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
  
    [splittedByDayForecast enumerateObjectsUsingBlock:^(NSArray <ForecastReport *> *dayArray, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *aDay = [[dayArray firstObject] date];
        
        NSString *dayName = [dateFormatter stringFromDate:aDay];
        
        
        [processedReport addObject:@{
                                     @"WeekDay"        : dayName,
                                     @"maxMin"         : [FiveDayForecastController maxMinTempInForecastPeriod:dayArray],
                                     @"dayReport"  : dayArray}
         ];
    }];
    
    return processedReport;
}

@end
