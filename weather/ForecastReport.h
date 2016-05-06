//
//  ForecastReport.h
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainReport.h"
#import "Weather.h"

@interface ForecastReport : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *dt;

@property (nonatomic, strong) MainReport *mainReport;
@property (nonatomic, strong) Weather *weather;

@end
