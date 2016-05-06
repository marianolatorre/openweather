//
//  ViewController.m
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) NSArray *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    ForecastController *forecastController = [ForecastController new];
    forecastController.forecastControllerDelegate = self;
    [forecastController retrieveForecast];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - ForecastControllerDelegate

- (void)forecastDataRetrieved:(NSArray *)results{
    self.model = results;
    
    //refresh in main thread UI
    
}

- (void)forecastFailedWithError:(NSError *)error{

}

@end
