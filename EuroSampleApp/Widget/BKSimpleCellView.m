//
//  BKSimpleCellView.m
//  EuroSampleApp
//
//  Created by Ashish Parmar on 18/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import "BKSimpleCellView.h"
#import "BKLogoImageView.h"
#import "BkSharedManager.h"

@implementation BKSimpleCellView

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        return self;
    }
    
    return nil;
}

- (void) initalizeViewWidget:(NSDictionary *) dataDict {
    
    CGRect rect = self.frame;
    
    CGFloat xPadding = 15;
    CGFloat yPadding = 15;
    
    NSString *imagePath = [dataDict objectForKey:@"provider_logo"];
    BKLogoImageView *logoImage = [[BKLogoImageView alloc] initWithFrame:CGRectMake(xPadding, yPadding, 120, 30)];
    if (imagePath != NULL) {
        [logoImage initalizeViewWidget:@{@"path" : imagePath}];
    }
    [self addSubview:logoImage];
    
    yPadding += logoImage.frame.size.height + 28;
    
    NSString *arvTime = [dataDict objectForKey:@"arrival_time"];
    NSString *depTime = [dataDict objectForKey:@"departure_time"];
    NSString *duration = [dataDict objectForKey:@"duration"];
    
    if (arvTime != NULL && depTime != NULL) {
        
        UILabel *depTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, yPadding, rect.size.width, rect.size.height)];
        depTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", depTime, arvTime];
        depTimeLabel.font = [UIFont boldSystemFontOfSize:20.0];
        depTimeLabel.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0];
        depTimeLabel.numberOfLines = 1;
        [self addSubview:depTimeLabel];
        
        rect = depTimeLabel.frame;
        CGRect newRect = [[BKSharedManager sharedManager] findRect:CGRectMake(0, 0, rect.size.width, CGFLOAT_MAX) forLabel:depTimeLabel forLimitedLines:1];
        rect.size = newRect.size;
        rect.origin.y = self.frame.size.height - 15 - rect.size.height;
        depTimeLabel.frame = rect;
    }
    
    NSString *price = [dataDict objectForKey:@"price_in_euros"];
    yPadding = 15;
    
    if (price != NULL) {
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, yPadding, rect.size.width, rect.size.height)];
        priceLabel.text = price;
        priceLabel.font = [UIFont boldSystemFontOfSize:22.0];
        priceLabel.numberOfLines = 1;
        [self addSubview:priceLabel];
        
        rect = priceLabel.frame;
        CGRect newRect = [[BKSharedManager sharedManager] findRect:CGRectMake(0, 0, rect.size.width, CGFLOAT_MAX) forLabel:priceLabel forLimitedLines:1];
        rect.size = newRect.size;
        rect.origin.x = self.frame.size.width - 15 - rect.size.width;
        priceLabel.frame = rect;
        
        yPadding += rect.size.height + 15;
    }
    
    if (duration != NULL) {
        
        UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, yPadding, rect.size.width, rect.size.height)];
        durationLabel.text = [NSString stringWithFormat:@"Direct  %@h", duration];
        durationLabel.font = [UIFont systemFontOfSize:17.0];
        durationLabel.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0];
        durationLabel.numberOfLines = 1;
        [self addSubview:durationLabel];
        
        rect = durationLabel.frame;
        CGRect newRect = [[BKSharedManager sharedManager] findRect:CGRectMake(0, 0, rect.size.width, CGFLOAT_MAX) forLabel:durationLabel forLimitedLines:1];
        rect.size = newRect.size;
        rect.origin.x = self.frame.size.width - 15 - rect.size.width;
        rect.origin.y = self.frame.size.height - 15 - rect.size.height;
        durationLabel.frame = rect;
    }
    
    CGPoint startPoint = CGPointMake(0, self.frame.size.height - 3.0);
    CGPoint endPoint = CGPointMake(self.frame.size.width, self.frame.size.height - 3.0);
    CAShapeLayer *linePath = [[BKSharedManager sharedManager] makeLineBetweenTwoPoints:startPoint
                                                                           destination:endPoint
                                                                                bounds:self.frame
                                                                                 color:[UIColor colorWithRed:220/255.0
                                                                                                       green:220/255.0
                                                                                                        blue:220/255.0
                                                                                                       alpha:1.0]
                                                                                 width:1.8];
    [self.layer addSublayer:linePath];
}

@end
