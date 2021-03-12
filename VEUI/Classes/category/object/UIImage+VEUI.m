//
//  UIImage+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import "UIImage+VEUI.h"
#import "UIView+VEUI.h"

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

+ (UIImage *)imageFromView:(UIView *)view {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(view.width * scale, view.height * scale);
    return [self imageFromView:view size:size];
}

+ (UIImage *)imageFromView:(UIView *)view size:(CGSize)size {
    BOOL hidden = view.hidden;
    CGRect frame = view.frame;
    
    if (hidden) {
        view.orign = CGPointMake(-view.width, -view.height);
        view.hidden = NO;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
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

+ (UIImage*)imageWithIcon:(NSString*)iconCode inFont:(NSString*)fontName size:(CGSize)size color:(UIColor*)color {
//    CGFloat scale = [[UIScreen mainScreen] scale];
//    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.width)];
    label.font = [UIFont fontWithName:fontName size:MIN(size.width, size.height)];
    label.text = iconCode;
    if(color) {
        label.textColor = color;
    }
//    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return retImage;
    return [UIImage imageFromView:label size:size];
}

@end
