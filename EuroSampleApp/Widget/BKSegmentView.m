//
//  BKSegmentView.m
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import "BKSegmentView.h"
#import "BkSharedManager.h"

@implementation BKSegmentView

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
    
    NSArray *titleArray = [dataDict objectForKey:@"data"];
    CGRect rect = self.frame;
    
    sizeDict = [[NSMutableDictionary alloc] init];
    
    CGFloat xPadding = 0;
    if (titleArray != NULL) {
        
        NSInteger index = 0;
        CGFloat labelSize = self.frame.size.width / titleArray.count;
        for (NSString *newTitle in titleArray) {
            
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [titleButton setFrame:CGRectMake(xPadding, 0, labelSize, rect.size.height - 10)];
            [titleButton setTitle:newTitle forState:UIControlStateNormal];
            [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            titleButton.tag = 100 + index;
            [self addSubview:titleButton];
            
            CGPoint center = titleButton.center;
            center.y = self.frame.size.height / 2;
            titleButton.center = center;
            
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:titleButton.frame];
            tempLabel.text = newTitle;
            tempLabel.numberOfLines = 1;
            
            CGRect rect = tempLabel.frame;
            CGRect newRect = [[BKSharedManager sharedManager] findRect:CGRectMake(0, 0, tempLabel.frame.size.width, CGFLOAT_MAX) forLabel:tempLabel forLimitedLines:1];
            rect.size = newRect.size;
            
            center = tempLabel.center;
            center.x = xPadding + (labelSize / 2);
            tempLabel.center = center;
            rect = tempLabel.frame;
            
            [sizeDict setValue:[NSValue valueWithCGRect:rect] forKey:[NSString stringWithFormat:@"%ld", (long)titleButton.tag]];
            
            xPadding += labelSize;
            index += 1;
            
            [titleButton addTarget:self action:@selector(titleClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (titleArray.count > 0) {
            
            CGRect currentRect = [[sizeDict objectForKey:@"101"] CGRectValue];
            currentRect.size.height = 3;
            currentRect.origin.y = self.frame.size.height - currentRect.size.height;
            cursorLabel = [[UILabel alloc] initWithFrame:currentRect];
            [cursorLabel setBackgroundColor:[UIColor colorWithRed:252/255.0 green:156/255.0 blue:33/255.0 alpha:1.0]];
            [self addSubview:cursorLabel];
        }
    }
}

- (void) titleClickEvent:(UIButton *) sender {
    
    [self.delegate segmentClicked:(sender.tag - 100)];
    
    [self animateCursorToIndex:sender.tag completion:^(BOOL finished) {
        
    }];
}

- (void) animateCursorToIndex:(NSInteger) toIndex completion:(void (^ __nullable)(BOOL finished)) completion {
    
    CGRect toRect = [[sizeDict valueForKey:[NSString stringWithFormat:@"%ld", toIndex]] CGRectValue];
    
    CGRect rect = cursorLabel.frame;
    toRect.origin.y = rect.origin.y;
    toRect.size.height = rect.size.height;
    
    [UIView animateWithDuration:0.55
                          delay:0.0
         usingSpringWithDamping:0.65
          initialSpringVelocity:0.05
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         cursorLabel.frame = toRect;
                     }
                     completion:completion];
}

@end
