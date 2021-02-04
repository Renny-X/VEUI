//
//  UIImage+VEUI.m
//  VEUI
//
//  Created by Coder on 2021/2/4.
//

#import "UIImage+VEUI.h"

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

@end
