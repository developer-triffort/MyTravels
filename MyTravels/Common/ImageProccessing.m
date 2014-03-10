//
//  ImageProccessing.m
//  MyTravels
//
//  Created by Triffort on 07/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "ImageProccessing.h"
#import <QuartzCore/QuartzCore.h>
@implementation ImageProccessing

static ImageProccessing *imgProcessing = nil;

+ (ImageProccessing *) sharedInstance
{
    if(!imgProcessing)
        return imgProcessing = [[ImageProccessing alloc] init];
    return imgProcessing;
    
}

+ (UIImage *) unEraseImageView : (UIImageView *) imageView realImage: (UIImage *) image drawAt: (CGRect)theRect
{
    UIGraphicsBeginImageContext(imageView.image.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height)];

    
    CGImageRef mySubimage = CGImageCreateWithImageInRect (image.CGImage, theRect);
    
    UIImage *subImage = [[[UIImage alloc] initWithCGImage:mySubimage] autorelease];
    
    [[subImage imageWithRadius:theRect.size.width/2 width:theRect.size.width height:theRect.size.width] drawAtPoint:CGPointMake(theRect.origin.x, theRect.origin.y)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextEOClip(context);
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}


-(UIImage*) reSize:(UIImage *)image aspectSize: (CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage*)convertViewIntoUIimage : (UIView*)viewImage
{
    UIGraphicsBeginImageContext(viewImage.frame.size);
    [viewImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (UIImage*) screenShot :(UIImage *)bckImage :(UIImage *)frontImage // merge content of two imageview with effect
{
    UIImage *currentImage = bckImage;
    UIImage *filterImage = frontImage;
    CGSize newSize = CGSizeMake(currentImage.size.width, currentImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    [filterImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    filterImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	
	UIGraphicsBeginImageContext(filterImage.size);
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
	
	[filterImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
	
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
	
	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor colorWithPatternImage:currentImage].CGColor);
	CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, filterImage.size.width, filterImage.size.height));
	
	filterImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
    if (filterImage) {
        return filterImage;
    }
	return currentImage;
    
}
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
	
    
    CGImageRef maskRef = maskImage.CGImage;
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    CGImageRelease(masked);
	return [UIImage imageWithCGImage:masked];
}


@end
