//
//  ImageProccessing.h
//  MyTravels
//
//  Created by Triffort on 07/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageExtras.h"
@interface ImageProccessing : NSObject

+ (ImageProccessing *) sharedInstance;

+ (UIImage *) unEraseImageView : (UIImageView *) imageView realImage: (UIImage *) image drawAt: (CGRect)theRect;

-(UIImage*) reSize:(UIImage *)image aspectSize: (CGSize)newSize;

-(UIImage*)convertViewIntoUIimage : (UIView*)viewImage;


- (UIImage*) screenShot :(UIImage *)bckImage :(UIImage *)frontImage;

@end
