//
//  MainReport.h
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainReport : NSObject

@property (nonatomic, copy) NSNumber *temp;
@property (nonatomic, copy) NSNumber *minTemp;
@property (nonatomic, copy) NSNumber *maxTemp;

@end
