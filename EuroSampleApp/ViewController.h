//
//  ViewController.h
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKSegmentView.h"

@interface ViewController : UIViewController <BKSegmentViewDelegate> {

    UIScrollView *dataScrollView;
    NSArray *dataArray;
}

@end

