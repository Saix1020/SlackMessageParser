//
//  UIFont+SLKMessageParser.m
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "UIFont+SLKMessageParser.h"
#import <CoreText/CoreText.h>

static NSMutableDictionary* SLKMessageFontsDictinary = nil;


@implementation UIFont (SLKMessageParser)

+(void)registMessageFontsForPre:(NSString*)preFontName
                           code:(NSString*)codeFontName
                        default:(NSString*)defaultFontName
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^(){
        SLKMessageFontsDictinary = [NSMutableDictionary new];
    });
    
    if (preFontName.length==0) {
        preFontName = @"Helvetica";
    }
    SLKMessageFontsDictinary[@"preFontName"] = preFontName;
    
    if (codeFontName.length==0) {
        codeFontName = @"Helvetica";
    }
    SLKMessageFontsDictinary[@"codeFontName"] = codeFontName;
    
    if (defaultFontName.length==0) {
        defaultFontName = @"Helvetica";
    }
    SLKMessageFontsDictinary[@"defaultFontName"] = defaultFontName;
}


+(UIFont*)preTextFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:SLKMessageFontsDictinary[@"preFontName"] size:size];
}

+(UIFont*)codeTextFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:SLKMessageFontsDictinary[@"codeFontName"] size:size];

}
+(UIFont*)defaultTextFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:SLKMessageFontsDictinary[@"defaultFontName"] size:size];
}


-(UIFont*)addFontStyle:(UIFontDescriptorSymbolicTraits)style
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:self.fontName size:self.pointSize];
    
    if (!fontDescriptor) {
        return self;
    }
    
    NSString *boldFontName = [[fontDescriptor fontDescriptorWithSymbolicTraits:fontDescriptor.symbolicTraits|style].fontAttributes valueForKey:UIFontDescriptorNameAttribute];
    
    if (!boldFontName) {
        return self;
    }
    
    return [UIFont fontWithName:boldFontName size:self.pointSize];
}


-(UIFont*)addBoldStyle
{
    return [self addFontStyle:UIFontDescriptorTraitBold];
}

-(UIFont*)addItalicStyle
{
    return [self addFontStyle:UIFontDescriptorTraitItalic];
}

-(fontStyle)boldStyle
{
    __weak typeof (self) weakSelf = self;
    return ^UIFont*(){
        return [weakSelf addFontStyle:UIFontDescriptorTraitBold];
    };
}

-(fontStyle)italicStyle
{
    __weak typeof (self) weakSelf = self;
    return ^UIFont*(){
        return [weakSelf addFontStyle:UIFontDescriptorTraitItalic];
    };
}



@end
