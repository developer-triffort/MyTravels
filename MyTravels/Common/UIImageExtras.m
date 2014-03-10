//
//  UIImageExtras.m
//  MyTravels
//
//  Created by Mohd Muzammil on 02/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "UIImageExtras.h"


@implementation UIImage (Extras)

- (UIImage *)scaleImage:(UIImage*)image toResolution:(int)resolution {
    CGImageRef imgRef = [image CGImage];
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    //if already at the minimum resolution, return the orginal image, otherwise scale
    if (width <= resolution && height <= resolution) {
        return image;
        
    } else {
        CGFloat ratio = width/height;
        
        if (ratio > 1) {
            bounds.size.width = resolution;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = resolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (UIImage*)imageWithRadius:(float) radius
                      width:(float)width
                     height:(float)height
{
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(c);
    CGContextMoveToPoint  (c, width, height/2);
    CGContextAddArcToPoint(c, width, height, width/2, height,   radius);
    CGContextAddArcToPoint(c, 0,         height, 0,           height/2, radius);
    CGContextAddArcToPoint(c, 0,         0,         width/2, 0,           radius);
    CGContextAddArcToPoint(c, width, 0,         width,   height/2, radius);
    CGContextClosePath(c);
    
    CGContextClip(c);
    
    [self drawAtPoint:CGPointZero];
    UIImage *converted = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return converted;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	//CGSize imageSize = sourceImage.size;
	//CGFloat width = imageSize.width;
	//CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	//CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	/*
     if (CGSizeEqualToSize(imageSize, targetSize) == NO)
     {
     CGFloat widthFactor = targetWidth / width;
     CGFloat heightFactor = targetHeight / height;
     
     if (widthFactor > heightFactor)
     scaleFactor = widthFactor; // scale to fit height
     else
     scaleFactor = heightFactor; // scale to fit width
     scaledWidth  = width * scaleFactor;
     scaledHeight = height * scaleFactor;
     
     // center the image
     if (widthFactor > heightFactor)
     {
     thumbnailPoint.y = (targetHeight - scaledHeight) * 1.0;
     }
     else
     if (widthFactor < heightFactor)
     {
     thumbnailPoint.x = (targetWidth - scaledWidth) * 1.0;
     }
     }
     */
    
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	
    if(newImage == nil)
		NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
    
    newImage = [self imageWithBorderFromImage:newImage];
	return newImage;
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    UIGraphicsBeginImageContext(source.size);
    [source drawAtPoint:CGPointZero];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 40);
    // CGContextSetRGBStrokeColor(ctx, 0.470 , 0.470 , 0.470, 1.000); // Gray
    CGContextSetRGBStrokeColor(ctx, 0.0 , 0.0 , 0.0, 1.000); // Black
    // CGContextSetRGBStrokeColor(ctx, 1.0 , 1.0 , 1.0, 1.000); // White
    
    CGRect borderRect = CGRectMake(0, 0,
                                   source.size.width+25,
                                   source.size.height);
    
    CGContextStrokeRect(ctx, borderRect);
    
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
    
}

- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect {
    CGContextRef                context;
    CGImageRef                  imageRef;
    CGSize                      inputSize;
    UIImage                     *outputImage = nil;
    CGFloat                     scaleFactor, width;
    
    // resize, maintaining aspect ratio:
    
    inputSize = newSize;
    scaleFactor = newSize.height / inputSize.height;
    width = roundf( inputSize.width * scaleFactor );
    
    if ( width > newSize.width ) {
        scaleFactor = newSize.width / inputSize.width;
        newSize.height = roundf( inputSize.height * scaleFactor );
    } else {
        newSize.width = width;
    }
    
    UIGraphicsBeginImageContext( newSize );
    
    context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake( 0, 0, newSize.width, newSize.height ), self.CGImage );
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    inputSize = newSize;
    
    // constrain crop rect to legitimate bounds
    if ( cropRect.origin.x >= inputSize.width || cropRect.origin.y >= inputSize.height ) return outputImage;
    if ( cropRect.origin.x + cropRect.size.width >= inputSize.width ) cropRect.size.width = inputSize.width - cropRect.origin.x;
    if ( cropRect.origin.y + cropRect.size.height >= inputSize.height ) cropRect.size.height = inputSize.height - cropRect.origin.y;
    
    // crop
    if ( ( imageRef = CGImageCreateWithImageInRect( outputImage.CGImage, cropRect ) ) ) {
        outputImage = [[[UIImage alloc] initWithCGImage: imageRef] autorelease];
        CGImageRelease( imageRef );
    }
    
    return outputImage;
}

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality
{
    UIGraphicsBeginImageContext( newSize );

    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    //CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    //CGContextRef bit = CGBitmapContextCreate(<#void *data#>, <#size_t width#>, <#size_t height#>, <#size_t bitsPerComponent#>, <#size_t bytesPerRow#>, <#CGColorSpaceRef space#>, <#CGBitmapInfo bitmapInfo#>)
    /*CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                CGImageGetBytesPerRow(imageRef),
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));*/
    
    CGContextRef bitmap= UIGraphicsGetCurrentContext();    
    // Rotate and/or flip the image if required by its orientation
   //CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? newRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    
    BOOL drawTransposed;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        
        // Apprently in iOS 5 the image is already correctly rotated, so we don't need to rotate it manually
        
        drawTransposed = NO;
        
    } else {
        
        switch (self.imageOrientation) {
                
            case UIImageOrientationLeft:
                
            case UIImageOrientationLeftMirrored:
                
            case UIImageOrientationRight:
                
            case UIImageOrientationRightMirrored:
                
                drawTransposed = YES;
                
                break;
                
            default:
                
                drawTransposed = NO;
                
        }
        
        transform = [self transformForOrientation:newSize];
        
    }
    
    return [self resizedImage:newSize
            
                    transform:transform
            
               drawTransposed:drawTransposed
            
         interpolationQuality:quality];
    
}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
            
    }
    
    return transform;
}



@end
