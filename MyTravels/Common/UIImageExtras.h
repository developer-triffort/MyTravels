//
//  UIImageExtras.h
//  MyTravels
//
//  Created by Mohd Muzammil on 02/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

@interface UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
- (UIImage *)scaleImage:(UIImage*)image toResolution:(int)resolution;
- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect;
- (UIImage*)imageWithRadius:(float) radius
width:(float)width
                     height:(float)height;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end