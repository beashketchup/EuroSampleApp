//
//  BKFooterView.m
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import "BKFooterView.h"

@implementation BKFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    
        [self setBackgroundColor:[UIColor colorWithRed:15/255.0 green:97/255.0 blue:163/255.0 alpha:1.0]];        
        return self;
    }
    
    return nil;
}

- (void) initalizeViewWidget:(NSDictionary *) dataDict {
    
    CGRect rect = self.frame;
    
    UIButton *sortButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, rect.size.height)];
    [sortButton setTitle:@"Sort" forState: UIControlStateNormal];
    [sortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:sortButton];
        
    [sortButton addTarget:self action:@selector(sortButtonAction:) forControlEvents:UIControlEventTouchUpInside];        
}

- (void) sortButtonAction:(UIButton *) sender {
    
}

@end
