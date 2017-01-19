//
//  BKHeaderView.m
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import "BKHeaderView.h"
#import "BkSharedManager.h"

@implementation BKHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame {
    
    frame.size.height = 74;
    if (self = [super initWithFrame:frame]) {
        
        return self;
    }
    
    return nil;
}

- (void) initalizeViewWidget:(NSDictionary *) dataDict {
    
    NSString *title = [dataDict objectForKey:@"title"];
    NSString *date = [dataDict objectForKey:@"date"];
    CGRect rect = self.frame;
    
    CGFloat yPadding = 0;
    CGFloat totalHeight = 0;
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, yPadding, rect.size.width, 20)];
    [statusView setBackgroundColor:[UIColor colorWithRed:15/255.0 green:97/255.0 blue:163/255.0 alpha:1.0]];
    [self addSubview:statusView];
    
    yPadding += statusView.frame.size.height;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, yPadding, rect.size.width, rect.size.height - statusView.frame.size.height)];
    [headerView setBackgroundColor:[UIColor colorWithRed:15/255.0 green:97/255.0 blue:163/255.0 alpha:1.0]];
    [self addSubview:headerView];
    
    yPadding = 0;
    rect = headerView.frame;
    
    if (title != NULL) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPadding, rect.size.width, rect.size.height)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        [headerView addSubview:titleLabel];
        
        rect = titleLabel.frame;
        CGRect newRect = [[BKSharedManager sharedManager] findRect:CGRectMake(0, 0, rect.size.width, CGFLOAT_MAX) forLabel:titleLabel forLimitedLines:1];
        rect.size.height = newRect.size.height;
        titleLabel.frame = rect;
        
        yPadding += rect.size.height + 5;
        
        totalHeight += rect.size.height + 5;
    }
    
    if (date != NULL) {
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPadding, rect.size.width, rect.size.height)];
        dateLabel.text = date;
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.numberOfLines = 1;
        [headerView addSubview:dateLabel];
        
        rect = dateLabel.frame;
        CGRect newRect = [[BKSharedManager sharedManager] findRect:CGRectMake(0, 0, rect.size.width, CGFLOAT_MAX) forLabel:dateLabel forLimitedLines:1];
        rect.size.height = newRect.size.height;
        dateLabel.frame = rect;
        
        totalHeight += rect.size.height;
    }
    
    CGFloat availableHeight = (headerView.frame.size.height - totalHeight) / 2;
    if (titleLabel != NULL) {
        
        rect = titleLabel.frame;
        rect.origin.y = availableHeight;
        titleLabel.frame = rect;
        
        yPadding = rect.origin.y + rect.size.height + 5;
        
        if (dateLabel != NULL) {
            rect = dateLabel.frame;
            rect.origin.y = yPadding;
            dateLabel.frame = rect;
        }
    }
    else if (dateLabel != NULL) {
        
        rect = dateLabel.frame;
        rect.origin.y = availableHeight;
        dateLabel.frame = rect;
    }
}

@end
