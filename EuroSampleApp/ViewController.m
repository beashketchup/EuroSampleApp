//
//  ViewController.m
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import "ViewController.h"
#import "BKHeaderView.h"
#import "BKFooterView.h"
#import "BkSharedManager.h"
#import "BKSimpleCellView.h"
#import "EuroSampleApp-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initializeViewWidgets];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initializeViewWidgets {
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat yPadding = 0;
    self->dataArray = @[];
    
    BKHeaderView *headerView = [[BKHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 10)];
    [headerView initalizeViewWidget:@{@"title" : @"Berlin - Munich", @"date" : @"Jun 07"}];
    [self.view addSubview:headerView];
    
    yPadding += headerView.frame.size.height;
    
    BKSegmentView *segmentView = [[BKSegmentView alloc] initWithFrame:CGRectMake(0, yPadding, screenSize.width, 60)];
    [segmentView initalizeViewWidget:@{@"data" : @[@"Train", @"Bus", @"Flight"]}];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    
    yPadding += headerView.frame.size.height;
    
    BKFooterView *footerView = [[BKFooterView alloc] initWithFrame:CGRectMake(0, screenSize.height - 44, screenSize.width, 44)];
    [footerView initalizeViewWidget:nil];
    [self.view addSubview:footerView];
    
    CGFloat availableHeight = screenSize.height - yPadding - footerView.frame.size.height;
    dataScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPadding, screenSize.width, availableHeight)];
    [self.view addSubview:dataScrollView];
    
    __weak ViewController* wself = self;
    BKDataSource *sourceTrain = [[BKDataSource alloc] init];
    [sourceTrain retrieveListFor:BKMasterFilterBuses
                      completion:^(NSArray<NSDictionary<NSString *,id> *> * _Nonnull value,
                                   enum BKBKDataSourceError errorType) {
                          
                          NSLog(@"Result Value = %@", value);
                          ViewController* sself = wself;
                          sself->dataArray = [[BKSharedManager sharedManager] normalizeDataArray:value];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [sself loadDataToScroller];
                          });
                      }];
}

- (void) loadDataToScroller {
    
    CGRect rect = dataScrollView.frame;
    CGFloat yPadding = 0;
    for (NSDictionary *eachData in dataArray) {
        
        BKSimpleCellView *cellView = [[BKSimpleCellView alloc] initWithFrame:CGRectMake(0, yPadding, rect.size.width, 100)];
        [cellView initalizeViewWidget:eachData];
        [dataScrollView addSubview:cellView];
        
        yPadding += cellView.frame.size.height;
    }
    
    dataScrollView.contentSize = CGSizeMake(rect.size.width, yPadding);
}

- (void) removeViewFromScroller {
    
    CGRect rect = dataScrollView.frame;
    [dataScrollView removeFromSuperview];
    
    dataScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:dataScrollView];
}

#pragma mark Segment Delegate methods

- (void) segmentClicked:(NSInteger) index {
    
    BKMasterFilter filter = BKMasterFilterTrains;
    switch (index) {
        case 0:
            filter = BKMasterFilterTrains;
            break;
        case 1:
            filter = BKMasterFilterBuses;
            break;
        case 2:
            filter = BKMasterFilterFlights;
            break;
        default:
            break;
    }
    
    [self removeViewFromScroller];
    
    __weak ViewController* wself = self;
    BKDataSource *sourceTrain = [[BKDataSource alloc] init];
    [sourceTrain retrieveListFor:filter
                      completion:^(NSArray<NSDictionary<NSString *,id> *> * _Nonnull value,
                                   enum BKBKDataSourceError errorType) {
                          
                          //NSLog(@"Result Value = %@", value);
                          ViewController* sself = wself;
                          sself->dataArray = [[BKSharedManager sharedManager] normalizeDataArray:value];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [sself loadDataToScroller];
                          });
                      }];
}

@end
