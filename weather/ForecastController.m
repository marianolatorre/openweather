//
//  ForecastController.m
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import "ForecastController.h"

#import "ForecastReport.h"
#import "MainReport.h"
#import "Weather.h"

#define FORECAST_URL @"http://api.openweathermap.org/data/2.5/forecast?q=London,us&appid=c61fc1f0ca61a12becafe12a6527a18b"

@implementation ForecastController

- (void)retrieveForecast{
    
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    RKObjectMapping *forecastMapping = [RKObjectMapping mappingForClass:[ForecastReport class]];
    [forecastMapping addAttributeMappingsFromDictionary:@{
                                                        @"dt_txt" : @"date",
                                                        @"dt" : @"dt"
                                                        }];
    
    
    
    
    RKObjectMapping *mainMapping = [RKObjectMapping mappingForClass:[MainReport class]];
    [mainMapping addAttributeMappingsFromDictionary:@{
                                                      @"temp_max" : @"maxTemp",
                                                      @"temp_min" : @"minTemp"}];
    [forecastMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"main" toKeyPath:@"mainReport" withMapping:mainMapping]];

    RKObjectMapping *weatherMapping = [RKObjectMapping mappingForClass:[Weather class]];
    [weatherMapping addAttributeMappingsFromArray:@[@"icon"]];
    [forecastMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"weather" toKeyPath:@"weather" withMapping:weatherMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:forecastMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@"list"
                                                                                       statusCodes:nil];

    
    NSURL *url = [NSURL URLWithString:FORECAST_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self configureDateFormatter];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
//    __weak typeof(self) weakSelf = self;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [self.forecastControllerDelegate forecastDataRetrieved:[[result array] copy]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.forecastControllerDelegate forecastFailedWithError:error];
    }];
    [operation start];
    
}

- (void) configureDateFormatter{
    // we should do this only once
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"y-m-d HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateFormatter atIndex:0];
}

@end
