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

@implementation ForecastController

- (void) mainMappingWithMapping:(RKObjectMapping *)mapping{
    RKObjectMapping *mainMapping = [RKObjectMapping mappingForClass:[MainReport class]];
    [mainMapping addAttributeMappingsFromDictionary:@{
                                                      @"temp_max" : @"maxTemp",
                                                      @"temp_min" : @"minTemp",
                                                      @"temp" : @"temp"}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"main" toKeyPath:@"mainReport" withMapping:mainMapping]];
}

- (void)weatherMappingWithMapping:(RKObjectMapping *)mapping{
    RKObjectMapping *weatherMapping = [RKObjectMapping mappingForClass:[Weather class]];
    [weatherMapping addAttributeMappingsFromDictionary:@{
                                                         @"icon": @"icon",
                                                         @"description" : @"weatherDescription"}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"weather" toKeyPath:@"weather" withMapping:weatherMapping]];
}

- (void)configureDateFormatter{
    // we should do this only once
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"y-m-d HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateFormatter atIndex:0];
}

@end
