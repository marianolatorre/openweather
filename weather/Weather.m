//
//  Weather.m
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import "Weather.h"

static NSString * const kImageURLFormat = @"http://openweathermap.org/img/w/%@.png";

@implementation Weather

- (NSString *)iconUrl{
    return self.icon ? [NSString stringWithFormat:kImageURLFormat, self.icon] : nil;
}

@end
