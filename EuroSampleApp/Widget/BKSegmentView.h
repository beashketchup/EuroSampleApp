//
//  BKSegmentView.h
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKSegmentViewDelegate;

@interface BKSegmentView : UIView {
    
    UILabel *cursorLabel;    
    NSMutableDictionary *sizeDict;
}

@property (weak, nonatomic) id<BKSegmentViewDelegate> delegate;

- (void) initalizeViewWidget:(NSDictionary *) dataDict;

@end

@protocol BKSegmentViewDelegate <NSObject>

- (void) segmentClicked:(NSInteger) index;

@end
