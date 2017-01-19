//
//  BKLogoImageView.m
//  EuroSampleApp
//
//  Created by Ashish Parmar on 18/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

#import "BKLogoImageView.h"
#import "BkSharedManager.h"
#import "EuroSampleApp-Swift.h"

@implementation BKLogoImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        return self;
    }
    
    return nil;
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self->observerkey];
    self->observerkey = nil;
}

- (void) initalizeViewWidget:(NSDictionary *) dataDict {
    
    CGRect rect = self.frame;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self addSubview:imageView];
    
    NSString *path = [dataDict objectForKey:@"path"];    
    
    if ([[BKSharedManager sharedManager] isImageDownloading:path]) {
        
        NSString *fileName = [path lastPathComponent];
        __weak BKLogoImageView* wself = self;
       self->observerkey = [[NSNotificationCenter defaultCenter] addObserverForName:[NSString stringWithFormat:@"IMAGE_%@", fileName]
                                                                        object:nil
                                                                         queue:nil
                                                                    usingBlock:^(NSNotification * _Nonnull note) {
                                                                        
                                                                        NSString *imagePath = note.object;
                                                                        
                                                                        BKLogoImageView* sself = wself;
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            [sself setImageForView:imagePath];
                                                                        });
                                                                    }];
    }
    else {
        
        [self showLoadingIndicator];
        
        __weak BKLogoImageView* wself = self;
        BKDataSource *imageSource = [[BKDataSource alloc] init];
        [imageSource getImageFor:path
                      completion:^(NSString * _Nonnull value,
                                   enum BKBKDataSourceError errorType) {
                          
                          //NSLog(@"Result image = %@", value);
                          
                          BKLogoImageView* sself = wself;
                          [sself setImageForView:value];
                      }];
    }
}

- (void) showLoadingIndicator {
    
    CGRect rect = self.frame;
    BKSpinnerView *spinnerView = [[BKSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    spinnerView.tag = 1001;
    [[spinnerView layer] setStrokeColor:[UIColor colorWithRed:252/255.0 green:156/255.0 blue:33/255.0 alpha:1.0].CGColor];
    [[spinnerView layer] setLineWidth:3.0];
    [self addSubview:spinnerView];
    
    CGPoint center = spinnerView.center;
    center.x = rect.size.width / 2;
    center.y = rect.size.height / 2;
    spinnerView.center = center;
}

- (void) removeLoadingIndicator {
    
    UIView *spinnerView = [self viewWithTag:1001];
    if (spinnerView != NULL) {
        [spinnerView removeFromSuperview];
    }
}

- (void) setImageForView:(NSString *) imagePath {
    
    [self removeLoadingIndicator];
    
    if (imagePath != NULL && [imagePath isKindOfClass:[NSString class]]) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (image != NULL) {
            
            CGSize size = image.size;
            CGRect imageRect = imageView.frame;
            CGFloat newWidth = imageRect.size.height * size.width / size.height;
            imageRect.size = CGSizeMake(newWidth, imageRect.size.height);
            
            imageView.frame = imageRect;
            CGPoint center = imageView.center;
            center.y = self.frame.size.height / 2;
            imageView.center = center;
            
            imageView.image = image;
        }
    }
}

@end
