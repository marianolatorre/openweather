//
//  Weather.h
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *weatherDescription;

- (NSString *)imageName;

@end
