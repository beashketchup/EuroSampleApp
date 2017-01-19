//
//  BKSharedManager.m
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import "BKSharedManager.h"

@implementation BKSharedManager

+ (id) sharedManager {
    
    static BKSharedManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id) init {
    
    if (self = [super init]) {
        
        cacheImageDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (CGRect) findRect:(CGRect) preferredRect forLabel:(UILabel *) label forLimitedLines:(NSInteger) lines {
    
    if (label != NULL) {
        
        CGRect newRect = preferredRect;
        label.frame = preferredRect;
        label.numberOfLines = lines;
        [label sizeToFit];
        
        newRect.size = label.frame.size;
        return newRect;
    }
    
    return CGRectZero;
}

- (void) setImageKeyForDownloading:(NSString *) path {
    
    if ([cacheImageDict objectForKey:path] == NULL) {
        [cacheImageDict setObject:@"1" forKey:path];
    }
}

- (void) removeImageKeyForDownloading:(NSString *) path {
    
    if ([cacheImageDict objectForKey:path]) {
        [cacheImageDict removeObjectForKey:path];
    }
}

- (BOOL) isImageDownloading:(NSString *) path {
    
    if ([cacheImageDict objectForKey:path]) {
        return TRUE;
    }
    
    return FALSE;
}

- (NSArray *) normalizeDataArray:(NSArray *) dataArray {
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (NSDictionary *eachData in dataArray) {
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSNumber *idNum = [eachData objectForKey:@"id"];
        if (idNum != NULL) {
            [newDict setObject:idNum forKey:@"id"];
        }
        
        NSString *imagePath = [eachData objectForKey:@"provider_logo"];
        if (imagePath != NULL) {
            imagePath = [imagePath stringByReplacingOccurrencesOfString:@"{size}" withString:@"63"];
            [newDict setObject:imagePath forKey:@"provider_logo"];
        }
        
        NSNumber *price = [eachData objectForKey:@"price_in_euros"];
        if (price != NULL) {
            
            [newDict setObject:[NSString stringWithFormat:@"€%.02f", price.floatValue] forKey:@"price_in_euros"];
        }
        
        NSString *arvTime = [eachData objectForKey:@"arrival_time"];
        NSString *depTime = [eachData objectForKey:@"departure_time"];
        if (arvTime != NULL && depTime != NULL) {
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"HH:mm"];
            NSDate *date1 = [df dateFromString:depTime];
            NSDate *date2 = [df dateFromString:arvTime];
            NSTimeInterval interval = [date2 timeIntervalSinceDate:date1];
            int hours = (int)interval / 3600;
            int minutes = (interval - (hours*3600)) / 60;
            NSString *timeDiff = [NSString stringWithFormat:@"%d:%02d", hours, minutes];
            
            [newDict setObject:arvTime forKey:@"arrival_time"];
            [newDict setObject:depTime forKey:@"departure_time"];
            [newDict setObject:timeDiff forKey:@"duration"];
        }
        
        [newArray addObject:newDict];
    }
    
    return newArray;
}

- (CAShapeLayer *) makeLineBetweenTwoPoints:(CGPoint) source
                              destination:(CGPoint) destination
                                   bounds:(CGRect) bounds
                                    color:(UIColor *) color
                                    width:(CGFloat) width {
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:source];
    [path addLineToPoint:destination];
    
    CAShapeLayer *linePath = [[CAShapeLayer alloc] init];
    [linePath setFrame:bounds];
    [linePath setPath:path.CGPath];
    [linePath setLineWidth:width];
    [linePath setStrokeColor:color.CGColor];
    [linePath setStrokeEnd:1];
    [linePath setLineJoin:kCALineJoinBevel];
    
    return linePath;
}

@end
