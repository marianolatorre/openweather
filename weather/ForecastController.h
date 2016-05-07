//
//  ForecastController.h
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>



@interface ForecastController : NSObject


- (void)mainMappingWithMapping:(RKObjectMapping *)mapping;

- (void)weatherMappingWithMapping:(RKObjectMapping *)mapping;

- (void)configureDateFormatter;

@end
