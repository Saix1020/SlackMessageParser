//
//  UIFont+SLKMessageParser.h
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef UIFont*(^fontStyle)(void);

@interface UIFont (SLKMessageParser)

+(void)registMessageFontsForPre:(NSString*)preFontName
                           code:(NSString*)codeFontName
                        default:(NSString*)defaultFontName;



+(UIFont*)preTextFontWithSize:(CGFloat)size;
+(UIFont*)codeTextFontWithSize:(CGFloat)size;
+(UIFont*)defaultTextFontWithSize:(CGFloat)size;


@property (nonatomic, readonly) fontStyle boldStyle;
@property (nonatomic, readonly) fontStyle italicStyle;

-(UIFont*)addBoldStyle;
-(UIFont*)addItalicStyle;



@end
