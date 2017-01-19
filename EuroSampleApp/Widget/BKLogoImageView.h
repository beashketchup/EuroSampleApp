//
//  BKLogoImageView.h
//  EuroSampleApp
//
//  Created by Ashish Parmar on 18/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKLogoImageView : UIView {
    
    __weak id <NSObject> observerkey;
    UIImageView *imageView;
}

- (void) initalizeViewWidget:(NSDictionary *) dataDict;

@end
