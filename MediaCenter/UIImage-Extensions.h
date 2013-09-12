//
//  UIImage-Extensions.h
//  The9AdPlatform
//
//  Created by zhang xiaodong on 11-5-31.
//  Copyright 2011 the9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (CS_Extensions)
//截图指定的像素大小图片
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
/**等比缩放图片到指定大小**/
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
/**缩放图片到指定大小**/
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
/**图片旋转弧度**/
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
/**图片旋转角度**/
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
/** 图片转换为字符串(图片转换为base64)*/
+(NSString *) image2String:(UIImage *)image;
/** 字符串转换为图片(base64转换成image)*/
+(UIImage *) string2Image:(NSString *)string;
/**合并两张图片**/
+(UIImage*)MergerImage:(UIImage*)img mergerImage:(UIImage*)merger position:(CGPoint)pos;
/***图片上添加文字****/
+(UIImage *)addText:(UIImage *)img text:(NSString *)text1 position:(CGPoint)pos;
@end;
