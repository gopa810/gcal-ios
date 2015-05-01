//
//  GCCanvas.m
//  GCAL
//
//  Created by Peter Kollath on 28/02/15.
//
//

#import "GCCanvas.h"
#import "GCEngine.h"

@implementation GCCanvas

-(id)init
{
    self = [super init];
    if (self)
    {
        self.currX = 0.0;
        self.currY = 0.0;
        self.lineHeight = 4.0;
        self.subLinesIndent = 20;
        self.suppressDrawing = NO;
    }
    return self;
}

-(void)drawSubheader:(NSString *)string style:(NSString *)style
{

    NSDictionary * d = [self.styles valueForKey:style];
    CGSize sz = [string sizeWithAttributes:d];

    if (!self.suppressDrawing)
    {
        CGFloat lineY;
        CGFloat x = (self.rightMargin + self.leftMargin - sz.width) / 2;
        lineY = self.currY + sz.height * 1.5;

        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGMutablePathRef path = CGPathCreateMutable();
        CGContextSetStrokeColorWithColor(ctx, self.engine.subheaderBackground.CGColor);
        CGContextSetFillColorWithColor(ctx, self.engine.subheaderBackground.CGColor);
        CGPathMoveToPoint(path, NULL, self.currX + 10, lineY);
        CGPathAddLineToPoint(path, NULL, x - 10, lineY);
        CGPathMoveToPoint(path, NULL, x + sz.width + 10, lineY);
        CGPathAddLineToPoint(path, NULL, self.rightMargin - 10, lineY);
        CGPathAddRoundedRect(path, NULL, CGRectMake(x - 5, lineY - sz.height/2 - 3, sz.width + 10, sz.height + 6), 3, 3);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        CGPathRelease(path);
        CGContextRestoreGState(ctx);
        
        [string drawAtPoint:CGPointMake(x, self.currY + sz.height)
             withAttributes:d];
    }
    
    self.currY += 3 * sz.height;
    self.currX = self.leftMargin;

}

-(void)drawString:(NSString *)string style:(NSString *)style
{
    NSDictionary * d = [self.styles valueForKey:style];
    CGSize sz = [string sizeWithAttributes:d];
    
    if (!self.suppressDrawing)
    {
        [string drawAtPoint:CGPointMake(self.currX, self.currY)
             withAttributes:d];
    }
    
    self.lineHeight = MAX(self.lineHeight, sz.height);
    
    self.currX += sz.width;
    
}

-(void)drawLine:(NSString *)line style:(NSString *)style
{
    NSDictionary * d = [self.styles valueForKey:style];
    NSArray * parts = [line componentsSeparatedByString:@" "];
    CGSize spaceSize = [@" " sizeWithAttributes:d];
    BOOL first = YES;
    
    for (NSString * string in parts) {
        CGSize sz = [string sizeWithAttributes:d];

        if (!first)
        {
            self.currX += spaceSize.width;
        }
        else
        {
            first = NO;
        }
        
        if (sz.width + self.currX > self.rightMargin)
        {
            self.currX = self.leftMargin + self.subLinesIndent;
            self.currY += self.lineHeight;
            self.lineHeight = 4;
        }

        if (!self.suppressDrawing)
        {
            [string drawAtPoint:CGPointMake(self.currX, self.currY)
                 withAttributes:d];
        }
        
        self.lineHeight = MAX(self.lineHeight, sz.height);        
        self.currX += sz.width;
    }
    
    self.currY += self.lineHeight;
    self.currX = self.leftMargin;
    
}

-(CGSize)sizeOfLine:(NSString *)line style:(NSString *)style
{
    NSDictionary * d = [self.styles valueForKey:style];
    NSArray * parts = [line componentsSeparatedByString:@" "];
    CGSize spaceSize = [@" " sizeWithAttributes:d];
    BOOL first = YES;

    CGFloat lh = 4;
    CGFloat cx = self.currX;
    CGFloat cy = self.currY;
    CGFloat x = self.currX, y = self.currY, w = self.currX, h = self.currY;
    
    for (NSString * string in parts) {
        CGSize sz = [string sizeWithAttributes:d];
        
        if (!first)
        {
            cx += spaceSize.width;
        }
        else
        {
            first = NO;
        }

        if (sz.width + cx > self.rightMargin)
        {
            cx = self.leftMargin + self.subLinesIndent;
            cy += lh;
            lh = 4;
        }
        
        x = MIN(x, cx);
        y = MIN(y, cy);
        w = MAX(w, cx + sz.width);
        h = MAX(h, cy + sz.height);
        
        lh = MAX(lh, sz.height);
        
        cx += sz.width;
    }

    return CGSizeMake(w - x, h - y);
}

-(CGSize)sizeOfString:(NSString *)line style:(NSString *)style
{
    NSDictionary * d = [self.styles valueForKey:style];
    return [line sizeWithAttributes:d];
}


-(CGSize)drawCenterString:(NSString *)string style:(NSString *)style left:(CGFloat)left right:(CGFloat)right
{
    NSDictionary * d = [self.styles valueForKey:style];
    CGSize sz = [string sizeWithAttributes:d];
    
    if (!self.suppressDrawing)
    {
        [string drawAtPoint:CGPointMake((right + left - sz.width)/2, self.currY)
             withAttributes:d];
    }
    
    self.lineHeight = MAX(self.lineHeight, sz.height);
    
    self.currY += sz.height;
    
    return sz;
}

-(void)fillRect:(CGRect)rc color:(CGColorRef)clr
{
    if (!self.suppressDrawing)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, clr);
        CGContextFillRect(ctx, rc);
        CGContextRestoreGState(ctx);
    }
}

-(void)strokeRoundRect:(CGRect)rect cornerDiameter:(CGFloat)diam foregroundColor:(CGColorRef)fc backgroundColor:(CGColorRef)bc
{
    if (!self.suppressDrawing)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGMutablePathRef path = CGPathCreateMutable();
        if (fc != NULL)
            CGContextSetStrokeColorWithColor(ctx, fc);
        if (bc != NULL)
            CGContextSetFillColorWithColor(ctx, bc);
        CGPathAddRoundedRect(path, NULL, rect, diam, diam);
        CGContextAddPath(ctx, path);
        if (fc != NULL && bc != NULL)
            CGContextDrawPath(ctx, kCGPathFillStroke);
        else if (fc != NULL)
            CGContextDrawPath(ctx, kCGPathStroke);
        else if (bc != NULL)
            CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);
        CGContextRestoreGState(ctx);
    }

}

-(void)newLine
{
    self.currX = self.leftMargin;
    self.currY += 1.25 * self.lineHeight;
    self.lineHeight = 4;
}

-(void)addY:(CGFloat)cgy
{
    self.currY += cgy;
}

@end
