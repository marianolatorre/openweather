//
//  ViewController.m
//  weather
//
//  Created by Mariano Latorre on 5/6/16.
//  Copyright © 2016 Mariano Latorre. All rights reserved.
//

#import "ViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "FiveDayForecastController.h"
#import "CurrentWeatherController.h"



@interface ViewController ()

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSArray *fiveDayForecast;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *hiloLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *conditionsLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation ViewController


/**
 
 Design here is based on Yahoo weather app adapted to the new data requirements.
 
 Assets borrowed from RAYWENDERLICH website.
 
 
 
 **/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.view addSubview:self.tableView];
    
    self.hourlyFormatter = [[NSDateFormatter alloc] init];
    self.hourlyFormatter.dateFormat = @"h a";
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight, headerFrame.size.width - 2*inset, hiloHeight);
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - temperatureHeight - hiloHeight, headerFrame.size.width - 2*inset, temperatureHeight);
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    CGRect conditionsFrame = iconFrame;
    // make the conditions text a little smaller than the view
    // and to the right of our icon
    conditionsFrame.size.width = self.view.bounds.size.width - 2*inset - iconHeight - 10;
    conditionsFrame.origin.x = iconFrame.origin.x + iconHeight + 10;
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    // bottom left
    self.temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.text = @"0°";
    self.temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:self.temperatureLabel];
    
    // bottom left
    self.hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    self.hiloLabel.backgroundColor = [UIColor clearColor];
    self.hiloLabel.textColor = [UIColor whiteColor];
    self.hiloLabel.text = @"0° / 0°";
    self.hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:self.hiloLabel];
    
    // top
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width-20, 80)];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.text = @"Loading...";
    self.cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    self.cityLabel.textAlignment = NSTextAlignmentRight;
    [header addSubview:self.cityLabel];
    
    self.conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    self.conditionsLabel.backgroundColor = [UIColor clearColor];
    self.conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:self.conditionsLabel];
    
    // bottom left
    self.iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:self.iconView];

    [self refresh:nil];
}

- (void) refresh:(UIRefreshControl *)refreshControl{
    // TODO: improve refresh feedback--> refresh in a dispatch group to check all tasks ended and not just one.
    
    CurrentWeatherController *currentWeatherController = [CurrentWeatherController new];
    [currentWeatherController retrieveCurrentWeatherWithCompletionBlock:^(ForecastReport *report) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[report weather] count]) {
                Weather *weather = [report weather][0];
                self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",[[report mainReport] temp].floatValue];
                self.iconView.image = [UIImage imageNamed:[weather imageName]];
                self.conditionsLabel.text = [weather weatherDescription];
                self.cityLabel.text = @"London";
                self.hiloLabel.text = [NSString  stringWithFormat:@"%.0f° / %.0f°",[[report mainReport] maxTemp].floatValue,[[report mainReport] minTemp].floatValue];
                [refreshControl endRefreshing];
            }
        });
        
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cityLabel.text = @"Loading...";
            self.temperatureLabel.text = @"-";
            self.iconView.image = nil;
            self.conditionsLabel.text = @"-";
            [refreshControl endRefreshing];
        });
    }];
    
    FiveDayForecastController *forecastController = [FiveDayForecastController new];
    
    [forecastController retrieveFiveDayForecastWithCompletionBlock:^(NSArray *forecastArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fiveDayForecast = [FiveDayForecastController processFiveDayForecastReport:forecastArray];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fiveDayForecast = nil;
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    }];


}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fiveDayForecast count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + [self.fiveDayForecast[section][@"dayReport"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        [self configureDailyCell:cell weather:self.fiveDayForecast[indexPath.section]];
        
    }else{
        [self configureHourlyCell:cell weather:self.fiveDayForecast[indexPath.section][@"dayReport"][indexPath.row -1]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }
    return 40;
}

- (void)configureHourlyCell:(UITableViewCell *)cell weather:(ForecastReport *)report {
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:[report date]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",[[report mainReport] temp].floatValue];
    cell.imageView.image = [UIImage imageNamed:[[report weather][0] imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureDailyCell:(UITableViewCell *)cell weather:(NSDictionary *)dailyReport {
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    cell.textLabel.text = [dailyReport objectForKey:@"WeekDay"] ;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",((NSNumber *)dailyReport[@"maxMin"][@"max"]).floatValue, ((NSNumber *)dailyReport[@"maxMin"][@"min"]).floatValue];
    cell.imageView.image = nil;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    
    NSLog(@"Percent %f", percent);
    self.blurredImageView.alpha = percent;
}

@end
