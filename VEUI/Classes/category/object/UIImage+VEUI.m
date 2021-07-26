//
//  UIImage+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import "UIImage+VEUI.h"
#import "UIView+VEUI.h"
#import <Accelerate/Accelerate.h>
//#import <CoreGraphics/CoreGraphics.h>

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

@implementation UIImage (VEUI)

+ (UIImage *)image:(UIImage *)img resetToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    img = nil;
    return scaledImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return Image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [[self imageWithColor:color] resetToSize:size];
}

+ (UIImage *)imageWithURL:(NSString *)url {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return (data != nil) ? [UIImage imageWithData:data] : nil;
}

+ (UIImage *)imageFromView:(UIView *)view {
    return [self createImageWithView:view size:view.size scale:[UIScreen mainScreen].scale];
}

+ (UIImage *)imageFromView:(UIView *)view size:(CGSize)size {
    return [self createImageWithView:view size:size scale:1];
}

+ (UIImage *)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(CGSize)size color:(UIColor*)color {
    CGFloat fontSize = MIN(size.width, size.height);
    if (!fontSize) {
        return nil;
    }
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:iconCode attributes:@{
        NSForegroundColorAttributeName:color ?: [UIColor blackColor],
        NSFontAttributeName:fontName && fontName.length ? [UIFont fontWithName:fontName size:fontSize] : [UIFont systemFontOfSize:fontSize]
    }];
    return [self imageWithAttributedString:attr size:size];
}

+ (UIImage*)imageWithAttributedString:(NSAttributedString *)attributedString size:(CGSize)size {
    if (!size.width || !size.height || !attributedString) {
        return nil;
    }
    UILabel *label = [[UILabel alloc] init];
    label.size = size;
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = attributedString;
    return [self createImageWithView:label size:size scale:[UIScreen mainScreen].scale];
}

- (UIImage *)resetToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)resetToSize:(CGSize)size withScale:(CGFloat)scale {
    CGSize tmpSize = CGSizeMake(size.width * scale, size.height * scale);
    UIGraphicsBeginImageContext(tmpSize);
    [self drawInRect:CGRectMake(0, 0, tmpSize.width, tmpSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    scaledImage = [UIImage imageWithData:UIImagePNGRepresentation(scaledImage) scale:scale];
    return scaledImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width * self.scale, self.size.height * self.scale)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);

    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));

    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width / 2, -rotatedSize.height / 2, rotatedSize.width, rotatedSize.height), [self CGImage]);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage) scale:self.scale];
    return newImage;
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    UIBezierPath *path;
    if (radius == 0) {
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    }else {
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height) cornerRadius:radius];
    }
    [path addClip];
    [self drawAtPoint:CGPointZero];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (img) {
        return img;
    }
    return self;
}


- (UIImage *)resetTintColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * image 添加 高斯模糊 CoreImage
 * @param blurLevel 模糊返回 0 ~ 1
 * @return 返回模糊后的图片
 */
- (UIImage *)gaussianBlurImageWithBlurLevel:(CGFloat)blurLevel {
    if (blurLevel < 0.f || blurLevel > 1.f) {
        blurLevel = 0.5f;
    }
    int boxSize = (int)(blurLevel * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];

    CGImageRef img = destImage.CGImage;
    vImage_Buffer inBuffer;
    vImage_Buffer outBuffer;
    vImage_Error error;
        
    void *pixelBuffer;
    //create vImage_Buffer with data from CGImageRef
        
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);

    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
        return self;
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);

    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        return self;
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        return self;
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

// utils
+ (UIImage *)createImageWithView:(UIView *)view size:(CGSize)size scale:(CGFloat)scale {
    BOOL hidden = view.hidden;
    CGRect frame = view.frame;
    
    if (hidden) {
        view.orign = CGPointMake(-view.width, -view.height);
        view.hidden = NO;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    if (view.superview) {
        [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (hidden) {
        view.frame = frame;
        view.hidden = hidden;
    }
    return img;
}

@end
