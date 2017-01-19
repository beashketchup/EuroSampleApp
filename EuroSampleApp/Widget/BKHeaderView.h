//
//  BKHeaderView.h
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKHeaderView : UIView {
    
    UILabel *titleLabel;
    UILabel *dateLabel;
}

- (void) initalizeViewWidget:(NSDictionary *) dataDict;

@end
