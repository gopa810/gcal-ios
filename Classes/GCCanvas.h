//
//  GCCanvas.h
//  GCAL
//
//  Created by Peter Kollath on 28/02/15.
//
//

#import <Foundation/Foundation.h>
@class GCEngine;
@class GCDisplaySettings;

@interface GCCanvas : NSObject

@property BOOL suppressDrawing;
@property (strong) NSDictionary * styles;
@property CGFloat currX;
@property CGFloat currY;
@property CGFloat lineHeight;
@property CGFloat subLinesIndent;
@property CGFloat leftMargin;
@property CGFloat rightMargin;
@property (weak) GCEngine * engine;
@property (weak) GCDisplaySettings * dispSettings;

-(void)drawSubheader:(NSString *)string style:(NSString *)style;
-(void)drawString:(NSString *)string style:(NSString *)style;
-(void)drawLine:(NSString *)string style:(NSString *)style;
-(void)strokeRoundRect:(CGRect)rect cornerDiameter:(CGFloat)diam foregroundColor:(CGColorRef)fc backgroundColor:(CGColorRef)bc;
-(CGSize)sizeOfLine:(NSString *)string style:(NSString *)style;
-(CGSize)sizeOfString:(NSString *)string style:(NSString *)style;
-(CGSize)drawCenterString:(NSString *)string style:(NSString *)style left:(CGFloat)left right:(CGFloat)right;
-(void)fillRect:(CGRect)rc color:(CGColorRef)clr;
-(void)newLine;
-(void)addY:(CGFloat)cgy;

@end
