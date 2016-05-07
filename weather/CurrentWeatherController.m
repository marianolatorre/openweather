//
//  CurrentWeatherController.m
//  weather
//
//  Created by mariano latorre on 06/05/2016.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import "CurrentWeatherController.h"
#import "ForecastReport.h"

#define WEATHER_URL @"http://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric&appid=c61fc1f0ca61a12becafe12a6527a18b"

@implementation CurrentWeatherController


- (void)retrieveCurrentWeatherWithCompletionBlock:(void (^)(ForecastReport *))successBlock failureBlock:(void (^)(NSError *))failureBlock{
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    RKObjectMapping *currentWeatherMapping = [RKObjectMapping mappingForClass:[ForecastReport class]];
    
    
    [self mainMappingWithMapping:currentWeatherMapping];
    [self weatherMappingWithMapping:currentWeatherMapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:currentWeatherMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:nil];
    
    
    NSURL *url = [NSURL URLWithString:WEATHER_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self configureDateFormatter];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        
        if ([[result array] count] && successBlock) {
            successBlock([result array][0]);
        }else if (failureBlock){
            failureBlock([NSError errorWithDomain:@"Unexpected error?" code:0 userInfo:nil]);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failureBlock){
            failureBlock(error);
        }
    }];
    [operation start];
}

@end
