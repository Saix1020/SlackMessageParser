//
//  SLKMessageContainer2.m
//  SLKMessageDemo
//
//  Created by saix on 2017/9/26.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageComponent.h"
#import "SLKMessageToken+Display.h"
#import "NSString+SLKMessageParser.h"
#import "SLKMessageParser.h"
#import <CoreText/CoreText.h>
#import "SLKLinkRect.h"
#import "UIColor+SLKMessageParser.h"

// copy from github
CGFloat AB_CTFrameGetHeight(CTFrameRef f)
{
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(f);
    NSInteger n = (NSInteger)[lines count];
    CGPoint *lineOrigins = (CGPoint *) malloc(sizeof(CGPoint) * n);
    CTFrameGetLineOrigins(f, CFRangeMake(0, n), lineOrigins);
    
    CGPoint first, last;
    
    CGFloat h = 0.0;
    for(int i = 0; i < n; ++i) {
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        if(i == 0) {
            first = lineOrigins[i];
            h += ascent;
            h += descent;
        }
        if(i == n-1) {
            last = lineOrigins[i];
            h += first.y - last.y;
            h += descent;
            free(lineOrigins);
            return ceil(h);
        }
    }
    free(lineOrigins);
    return 0.0;
}

@implementation SLKMessageComponent

-(NSMutableArray<SLKMessageComponent*>*)subComponents
{
    if (!_subComponents) {
        _subComponents = [NSMutableArray new];
    }
    
    return _subComponents;
}

-(void)addSubComponent:(SLKMessageComponent *)subComponent
{
    [self.subComponents addObject:subComponent];
}

-(SLKMessageTextComponent*)currentTextComponent
{
    if (!_currentTextComponent){
        _currentTextComponent = [SLKMessageTextComponent new];
        _currentTextComponent.type = SLKMessageComponentTypeNomal;
        [self addSubComponent:_currentTextComponent];
    }
    return _currentTextComponent;
}
-(instancetype)init
{
    self = [super init];
    if (self){
        self.frame = CGRectZero;
        self.type = SLKMessageComponentTypeNomal;
        self.insets = UIEdgeInsetsMake(4, 0, 4, 0);
        self.lineFragmentPadding = 5;
    }
    
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame andType:(SLKMessageComponentType)type
{
    self = [self init];
    if (self){
        self.frame = frame;
        self.type = type;
    }
    
    return self;
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    NSArray* stringTokens = [[[SLKMessageParser alloc] init] getTokensArray:message mode:@"NORMAL" flag:@{@"jumbomoji" : @1}];;
    NSMutableArray* tokens = [NSMutableArray new];
    [stringTokens enumerateObjectsUsingBlock:^(NSString* stringToken, NSUInteger idx, BOOL* stop) {
        [tokens addObject:[[SLKMessageToken alloc] initWithToken:stringToken]];
    }];
    
    NSMutableArray* tokensStack = [NSMutableArray new];
    for(SLKMessageToken* token in tokens){
        
        if(token.isTokenStart){
            [tokensStack insertObject:token atIndex:0];
        }
        else if(token.isTokenEnd){
            NSMutableArray* subTokens = token.subTokens;
            while(YES){
                SLKMessageToken* firstToken = tokensStack.firstObject;
                [tokensStack removeObjectAtIndex:0];
                
                if(firstToken.isTokenStart){
                    token.startToken = firstToken;
                    break;
                }
                else {
                    [subTokens addObject:firstToken];
                }
                
            }
            
            BOOL ignoredToken = NO;
            if(token.type == SLKMessageTokenB){
                [token appendStyle:kSLKMessageTokenSpanB];
                ignoredToken = YES;
            }
            else if(token.type == SLKMessageTokenI){
                [token appendStyle:kSLKMessageTokenSpanI];
                ignoredToken = YES;
            }
            else if(token.type == SLKMessageTokenSTRIKE){
                [token appendStyle:kSLKMessageTokenSpanSTRIKE];
                ignoredToken = YES;
            }
            
            token.subTokens = [[[subTokens reverseObjectEnumerator] allObjects] mutableCopy];
            if(ignoredToken) {
                [tokensStack insertObjects:subTokens atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, subTokens.count)]];
            }
            else {
                [tokensStack insertObject:token atIndex:0];
            }
        }
        else {
            [tokensStack insertObject:token atIndex:0];
        }
    }
    
    tokens = [[[tokensStack reverseObjectEnumerator] allObjects] mutableCopy];
    NSMutableArray* finalTokens = [NSMutableArray new];
    __block SLKMessageToken* prevToken = nil;
    [tokens enumerateObjectsUsingBlock:^(SLKMessageToken* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (prevToken && prevToken.type == SLKMessageTokenLINE_BREAK) {
            if (obj.type == SLKMessageTokenQUOTE) {
                [finalTokens removeLastObject];
            }
        }
        [finalTokens addObject:obj];
        prevToken = obj;
        
    }];
    [self addSLKMessageTokens:finalTokens];
}

#define kVSpace 4.f
#define kHSpace 16.f

-(void)addSLKMessageTokens:(NSArray<SLKMessageToken*>*)tokens
{
    _subComponents = nil;
    CGFloat y = 0;
    CGFloat x = 0;
    if (self.type == SLKMessageComponentTypeQuote ) {
        x = kHSpace;
    }
    CGSize size = self.frame.size;
    size.width -= x;
    
    for (SLKMessageToken* token in tokens) {
        if (token.type != SLKMessageTokenQUOTE && token.type != SLKMessageTokenPRE) {
            [self.currentTextComponent appendAttributedString:token.attributedString];
        }
        else {
            if(self.currentTextComponent.attributedString.length>0){
                self.currentTextComponent.frame = CGRectMake(self.frame.origin.x+x, self.frame.origin.y+y, size.width, 0);
                [self.currentTextComponent format];
                y += self.currentTextComponent.frame.size.height;
                self.currentTextComponent = nil;
            }
            
            if(token.type == SLKMessageTokenQUOTE){
                CGFloat deltaY = 0;
                if (self.type == SLKMessageComponentTypeQuote) {
                    deltaY = kVSpace;
                }
                SLKMessageQuoteComponent* newContainer = [[SLKMessageQuoteComponent alloc]
                                                          initWithFrame:CGRectMake(self.frame.origin.x+x, self.frame.origin.y+y+deltaY, size.width, 0) andType:SLKMessageComponentTypeQuote];
                [self addSubComponent:newContainer];
                [newContainer addSLKMessageTokens:token.subTokens];
                y += newContainer.frame.size.height+deltaY ;
            }
            else if(token.type == SLKMessageTokenPRE) {
                SLKMessagePreComponent* newContainer = [[SLKMessagePreComponent alloc] initWithFrame:CGRectMake(self.frame.origin.x+x, self.frame.origin.y+y, size.width, 0) andType:SLKMessageComponentTypePre];
                [self addSubComponent:newContainer];
                [newContainer addSLKMessageTokens:token.subTokens];
                y += newContainer.frame.size.height;
            }
        }
    }
    
    if (self.currentTextComponent.attributedString.length>0) {
        self.currentTextComponent.frame = CGRectMake(self.frame.origin.x+x, self.frame.origin.y+y, size.width, 0);
        [self.currentTextComponent format];
        y += self.currentTextComponent.frame.size.height;

    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, y+(self.type == SLKMessageComponentTypeQuote?kVSpace/2:0));
}


-(void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        for (SLKMessageComponent* component in self.subComponents) {
            [component draw];
        }
    }
    CGContextRestoreGState(context);

}

-(void)drawWithContent:(CGContextRef)context
{
    CGContextSaveGState(context);
    {
        for (SLKMessageComponent* component in self.subComponents) {
            [component drawWithContent:context];
        }
    }
    CGContextRestoreGState(context);
}

-(void)getLinkRectsInto:(NSMutableArray*)linkRects andCodeRectsInto:(NSMutableArray*)codeRects;
{
    for (SLKMessageComponent* component in self.subComponents) {
        [component getLinkRectsInto:linkRects andCodeRectsInto:codeRects];
    }
}


@end

@interface SLKMessageTextComponent()


@property (nonatomic, strong) NSMutableArray* codeRects;
@property (nonatomic, strong) NSMutableArray* linkRects;


@end

@implementation SLKMessageTextComponent
-(NSMutableArray*)codeRects
{
    if (!_codeRects) {
        _codeRects = [NSMutableArray new];
    }
    return _codeRects;
}

-(NSMutableArray*)linkRects
{
    if (!_linkRects) {
        _linkRects = [NSMutableArray new];
    }
    return _linkRects;
}

-(NSMutableAttributedString*)attributedString
{
    if (!_attributedString){
        _attributedString = [NSMutableAttributedString new];
    }
    return _attributedString;
}

-(void)appendAttributedString:(NSAttributedString *)attrString
{
    [self.attributedString appendAttributedString:attrString];
}


-(void)format
{
#define kMaxAttributedStringHeight 10000.f
    _codeRects = nil;
    CGRect rect = CGRectMake(self.frame.origin.x+self.insets.left+self.lineFragmentPadding,
                             self.frame.origin.y+self.insets.top,
                             self.frame.size.width-self.insets.left-self.insets.right-self.lineFragmentPadding*2,
                             kMaxAttributedStringHeight);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    NSMutableAttributedString * attStr = self.attributedString;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attStr.length), path, NULL);
    CGFloat frameHight = AB_CTFrameGetHeight(frame);
    
    NSArray * lines = (NSArray *)CTFrameGetLines(frame);
    NSUInteger lineCount = lines.count;
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);

    for (int i = 0; i < lineCount; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        CGPoint lineOrigin = lineOrigins[i];
        CGPoint position;
        position.x = rect.origin.x + lineOrigin.x;
        position.y = rect.size.height + rect.origin.y - lineOrigin.y;

        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;

        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);

        for (CFIndex k = 0; k < runCount; k++)
        {
            
            CTRunRef run = CFArrayGetValueAtIndex(runs, k);
            CGFloat width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, CTRunGetGlyphCount(run)), NULL, NULL, NULL);
            CGFloat lineHight = lineAscent + ABS(lineDescent) + lineLeading;
        
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
            
            id codeAttr = [runAttributes valueForKey:@"kSLKCodeAttribute"];
            id linkAttr = [runAttributes valueForKey:@"kSLKLinkAttribute"];

            if (codeAttr)
            {
                CGRect rectx = CGRectMake(lineOrigin.x + xOffset + rect.origin.x, position.y-lineAscent, width, lineHight);

                [self.codeRects addObject:[NSValue valueWithCGRect:rectx]];
            }
            else if(linkAttr){
                SLKLinkRect* linkRect = (SLKLinkRect*)linkAttr;
                CGRect rectx = CGRectMake(lineOrigin.x + xOffset + rect.origin.x, position.y-lineAscent, width, lineHight);
                [linkRect addRect:rectx];
                [self.linkRects addObject:linkRect];
            }
        }
        
    }
    
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, frameHight+kVSpace);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);

}



-(void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (_codeRects) {
        CGContextSaveGState(context);
        for(NSValue* vrect in _codeRects){
            CGRect rect = [vrect CGRectValue];
            [_RGBCOLOR(0xf7f7f9) setFill]; //f7f7f9
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2];
            CGContextSetStrokeColorWithColor(context, _RGBCOLOR(0xe1e1e8).CGColor); //e1e1e8

            [bezierPath stroke];
            [bezierPath fill];
        }
        CGContextRestoreGState(context);

    }
    
    CGContextSaveGState(context);

    CGRect rect = self.frame;
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    rect.origin.y = -rect.origin.y;
    
    if (self.ctFrameRef) {
        CTFrameDraw(self.ctFrameRef, context);
    }
    else {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);

        NSMutableAttributedString * attStr = self.attributedString;

        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
        self.ctFrameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attStr.length), path, NULL);
        
        CTFrameDraw(self.ctFrameRef, context);
//        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);
        
    }
    CGContextRestoreGState(context);

}

-(void)drawWithContent:(CGContextRef)context
{
    if (_codeRects) {
        CGContextSaveGState(context);
        for(NSValue* vrect in _codeRects){
            CGRect rect = [vrect CGRectValue];
            [_RGBCOLOR(0xf7f7f9) setFill]; //f7f7f9
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2];
            CGContextSetStrokeColorWithColor(context, _RGBCOLOR(0xe1e1e8).CGColor); //e1e1e8
            
            [bezierPath stroke];
            [bezierPath fill];
        }
        CGContextRestoreGState(context);
        
    }
//    if (_linkRects) {
//        CGContextSaveGState(context);
//        for(NSValue* vrect in _linkRects){
//            CGRect rect = [vrect CGRectValue];
////            [_RGBCOLOR(0xf7f7f9) setFill]; //f7f7f9
//            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2];
//            CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor); //e1e1e8
//            
//            [bezierPath stroke];
////            [bezierPath fill];
//        }
//        CGContextRestoreGState(context);
//        
//    }
    
    CGContextSaveGState(context);

    CGRect rect = self.frame;
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    rect.origin.y = -rect.origin.y;
//
//
    if (self.ctFrameRef) {
        CTFrameDraw(self.ctFrameRef, context);
    }
    else {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);

        NSMutableAttributedString * attStr = self.attributedString;

        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
        self.ctFrameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attStr.length), path, NULL);

        CTFrameDraw(self.ctFrameRef, context);
        //        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);

    }
    CGContextRestoreGState(context);
    
//    [self.attributedString drawWithRect:self.frame
//                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                context:nil];
    
}

-(void)dealloc
{
    if (self.ctFrameRef){
        CFRelease(self.ctFrameRef);
    }
}


-(void)getLinkRectsInto:(NSMutableArray*)linkRects andCodeRectsInto:(NSMutableArray*)codeRects
{
    [linkRects addObjectsFromArray:self.linkRects];
    [codeRects addObjectsFromArray:self.codeRects];
}


@end

@implementation SLKMessageQuoteComponent

-(void)draw
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 4, self.frame.size.height);

    [_RGBCOLOR(0xe3e4e6) setFill]; //f7f7f9
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:3];
    [bezierPath fill];
    CGContextRestoreGState(context);

    for (SLKMessageComponent* component in self.subComponents) {
        [component draw];
    }
    
    
}

-(void)drawWithContent:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 4, self.frame.size.height);
    
    [_RGBCOLOR(0xe3e4e6) setFill]; //f7f7f9
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:3];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    for (SLKMessageComponent* component in self.subComponents) {
        [component drawWithContent:context];
    }
}

@end

@implementation SLKMessagePreComponent


-(void)addSLKMessageTokens:(NSArray<SLKMessageToken*>*)tokens
{
    [super addSLKMessageTokens:tokens];
    [self.currentTextComponent.attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Menlo-Regular" size:14.f] range:NSMakeRange(0, self.currentTextComponent.attributedString.length)];

//    [self.currentTextComponent.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, self.currentTextComponent.attributedString.length)];
}
-(void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);


    [_RGBCOLOR(0xf7f7f9) setFill]; //f7f7f9
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:4];
    CGContextSetStrokeColorWithColor(context, _RGBCOLOR(0xe1e1e8).CGColor); //e1e1e8

    [bezierPath stroke];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    for (SLKMessageComponent* component in self.subComponents) {
        [component draw];
    }
    
    
}

-(void)drawWithContent:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    
    [_RGBCOLOR(0xf7f7f9) setFill]; //f7f7f9
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:4];
    CGContextSetStrokeColorWithColor(context, _RGBCOLOR(0xe1e1e8).CGColor); //e1e1e8
    
    [bezierPath stroke];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    for (SLKMessageComponent* component in self.subComponents) {
        [component drawWithContent:context];
    }

}

@end
