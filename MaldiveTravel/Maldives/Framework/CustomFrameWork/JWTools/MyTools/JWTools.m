//
//  JWTools.m
//  JW百思
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "JWTools.h"
#import <CoreImage/CoreImage.h>

@implementation JWTools

/**
 *  实现数组的排序功能
 *
 *  @param arr 将要被排序的数组
 *
 *  @param des 是升序还是降序，如果是降序为YES，反之为升序
 *
 *  @return 返回排序之后的数组
 */
+ (id)sortWithArray:(NSArray *)arr des:(BOOL)des{
    
    NSMutableArray *resultArr = [arr mutableCopy];
    
    [resultArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (des) {
            return obj1 > obj2;
        }else{
            return obj1 < obj2;
        }
        
    }];
    
    return [resultArr mutableCopy];
}

/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param text 文字
 *  @param font 字体大小
 *  @param size 控件最大大小
 *
 *  @return 文字所占的区域大小
 */
+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size{
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    //通过文字来获取文字所占的大小
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size;
}
/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param label Label
 *
 *  @return 文字所占的区域大小
 */
+ (CGFloat)labelHeightWithLabel:(UILabel *)label{
    NSDictionary * attributes = @{NSFontAttributeName:label.font};
    CGRect conRect = [label.text boundingRectWithSize:CGSizeMake(label.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return conRect.size.height + 5.f;
}
/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param label Label
 *
 *  @return 文字所占的区域大小
 */
+ (CGFloat)labelHeightWithLabel:(UILabel *)label withWidth:(CGFloat)width{
    NSDictionary * attributes = @{NSFontAttributeName:label.font};
    CGRect conRect = [label.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return conRect.size.height;
}

#pragma mark - FilePath

/**
 *  获取文件路径
 *
 *  @param fileName 文件名（需要类型）
 *
 *  @return 文件路径
 */
+ (NSString *)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    NSArray * urlsArray = [fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * pathURL = [urlsArray firstObject];
    NSString * path = [pathURL path];
    
    NSString * filePath;
    filePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",fileName,type]];
    
    if (![fileManger fileExistsAtPath:filePath]) {
        [fileManger createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    return filePath;
}

/**
 *  获取文件路径
 *
 *  @param fileName 文件名
 *
 *  @return 文件路径
 */
+ (NSString *)filePathWithFileName:(NSString *)fileName{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    NSArray * urlsArray = [fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * pathURL = [urlsArray firstObject];
    NSString * path = [pathURL path];
    
    NSString * filePath;
    filePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    
    if (![fileManger fileExistsAtPath:filePath]) {
        [fileManger createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    return filePath;
}


/**
 *  通过文件名获取文本文件内容
 *
 *  @param fileName 文件名
 *
 *  @return 文件
 */
+ (NSString *)fileWithFileName:(NSString *)fileName{
    //获取数据所在的文件路径
    NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return file;
}


/**
 *  通过文件名获取文件内容
 *
 *  @param fileName Array文件名
 *
 *  @return Array文件
 */
+ (NSArray *)contentArrayForFileName:(NSString *)fileName{
    //将文件的内容转化为数组
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:[self filePathWithFileName:fileName]];
    
    return dataArr;
}

/**
 *  通过文件名获取文件内容
 *
 *  @param fileName Dictionary文件名
 *
 *  @return Dictionary文件
 */
+ (NSDictionary *)contentDictForFileName:(NSString *)fileName{
    //将文件的内容转化为数组
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self filePathWithFileName:fileName]];
    
    return dict;
}

/**
 *  保存图片到本地
 *
 *  @param image 图片
 *
 *  @return 存储地址
 */
+ (NSString *)saveJImage:(UIImage *)image{
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate * date = [NSDate date];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString * imgPath = [NSString stringWithFormat:@"%@.png",[dateFormatter stringFromDate:date]];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString * imagePath = [NSString stringWithFormat:@"%@/%@",docs[0],imgPath];
    [imageData writeToFile:imagePath atomically:YES];
    return imgPath;
}
#pragma mark - NSDate
/**
 *  传一个日期字符串，判断是否是昨天，或者是今天的日期
 *
 *  @param dateStr 日期字符串
 *
 *  @return 修改完的日期字符串
 */
+ (NSString *)dateStr:(NSString *)dateStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateStr];

    //创建一个日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if (!date) {
        return nil;
    }
    //通过日历对象，判断date是否是昨天的日期
    if ([calendar isDateInYesterday:date]) {
        dateFormatter.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
    }
    //通过日历对象，判断date是否是今天的日期
    if ([calendar isDateInToday:date]) {
        dateFormatter.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:date]];
    }
    
    dateFormatter.dateFormat = @"MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
/**
 *  传一个日期字符串，判断日期
 *
 *  @param dateStr 日期字符串
 *
 *  @return 修改完的日期字符串
 */
+ (NSString *)dateStrWithDate:(NSString *)dateStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date;
    if ([dateStr isEqualToString:@""]) {
        date = [NSDate date];
    }else{
        date = [dateFormatter dateFromString:dateStr];
    }
    if (!date)date = [NSDate date];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}

#pragma mark - RegEx
/**
 *  密码长度至少6
 *
 *  @param password 密码
 *
 *  @return 密码长度是否大于等于6
 */
+ (BOOL)isRightPassWordWithStr:(NSString *)password{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}

/**
 *  纯数字验证码
 *
 *  @param comfireCode 验证码
 *
 *  @return 验证码纯数字
 */
+ (BOOL)isComfireCodeWithStr:(NSString *)comfireCode{
    NSString *codeRegex = @"^[0-9]{1,10}+$";
    NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codePredicate evaluateWithObject:comfireCode];
}


/**
 *  邮箱验证
 *
 *  @param email 邮箱
 *
 *  @return 是否是邮箱
 */
+ (BOOL)isEmailWithStr:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  验证手机号
 *
 *  @param phoneNumber 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)isPhoneIDWithStr:(NSString *)phoneNumber{
    NSString * phoneNumberRegex = @"^[0-9]{10,11}+$";
    NSPredicate * phoneNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumberRegex];
    return [phoneNumberPredicate evaluateWithObject:phoneNumber];
}
/**
 *  验证国内手机号
 *
 *  @param telNumber 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)checkTelNumber:(NSString*)telNumber{
    NSString * pattern =@"^1+[3578]+\\d{9}";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:telNumber];
}


#pragma mark - NSString
/**
 *  数字时间转格式时间
 *
 *  @param number 数字时间,如:123456789
 *
 *  @return 格式时间,如:2016-01-01
 */
+ (NSString *)stringNumberTurnToDateWithNumber:(NSString *)number{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[number intValue]];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:confromTimesp]];
}


#pragma mark - QR Code 二维码
/**
 *  创建二维码s
 *  @param QRStr 二维码链接
 */
+ (UIImage *)makeQRCodeWithStr:(NSString *)QRStr{
    //创建一个过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认(因为滤镜有可能保存了上一次的属性)
    [filter setDefaults];
    //给过滤器添加数据
    NSData *data = [QRStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //获取输出的二维码
    CIImage *outputimage = [filter outputImage];
    //    return [UIImage imageWithCIImage:outputimage];
    return [JWTools createNonInterpolatedUIImageFormCIImage:outputimage withSize:100.f];
}

/**
 *  模糊二维码处理
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


#pragma mark - 图片压缩
/**
 *  图片压缩到指定大小
 *
 *  @param image      图片
 *  @param targetSize 大小
 *
 *  @return 压缩后图片
 */
+ (UIImage*)imageByScalingAndCropping:(UIImage *)image ForSize:(CGSize)targetSize{
   //缩图片大小，“缩” 文件的尺寸变小，也就是像素数减少。长宽尺寸变小，文件体积同样会减小
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
    //压图片大小，“压” 文件体积变小，但是像素数不变，长宽尺寸不变，那么质量可能下降
//    return [UIImage imageWithData:UIImageJPEGRepresentation(newImage, 0.5f)];
}

/**
 *  微信分享图片32K限制
 *
 *  @param imageUrl 图片URL
 *
 *  @return 压缩后图片
 */
+ (UIImage *)zipImageWithImage:(UIImage *)image{
    while (UIImageJPEGRepresentation(image, 1.f).length/1024 > 30) {
        image = [JWTools imageByScalingAndCropping:image ForSize:CGSizeMake(image.size.width * 0.7f, image.size.height * 0.7f)];
    }
    return image;
}

/**
 *  图片适应屏幕大小
 *
 *  @param image  图片
 *  @param height 适应高度
 *  @param width  适应宽度
 *
 *  @return 图片大小
 */
+ (CGSize)getScaleImageSizeWithImageView:(UIImage *)image withHeight:(CGFloat)height withWidth:(CGFloat)width{
    float heightScale = height/image.size.height/1.0;
    float widthScale = width/image.size.width/1.0;
    float scale = MIN(heightScale, widthScale);
    float h = image.size.height*scale;
    float w = image.size.width*scale;
    return CGSizeMake(w, h);
}


@end
