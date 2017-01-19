//
//  BKSharedManager.h
//  EuroSampleApp
//
//  Created by Ashish Parmar on 16/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BKSharedManager : NSObject {
    
    NSMutableDictionary *cacheImageDict;
}

+ (id) sharedManager;

- (CGRect) findRect:(CGRect) preferredRect forLabel:(UILabel *) label forLimitedLines:(NSInteger) lines;
- (void) setImageKeyForDownloading:(NSString *) path;
- (void) removeImageKeyForDownloading:(NSString *) path;
- (BOOL) isImageDownloading:(NSString *) path;
- (NSArray *) normalizeDataArray:(NSArray *) dataArray;

- (CAShapeLayer *) makeLineBetweenTwoPoints:(CGPoint) source
                                destination:(CGPoint) destination
                                     bounds:(CGRect) bounds
                                      color:(UIColor *) color
                                      width:(CGFloat) width;

@end
