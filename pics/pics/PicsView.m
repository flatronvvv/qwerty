//
//  PicsView.m
//  pics
//
//  Created by Agasy on 01.02.13.
//  Copyright (c) 2013 Agasy. All rights reserved.
//

#import "PicsView.h"

#define k_maxHW 4.0
#define k_maxFrameCount1 15
#define k_maxFrameCount2 10
#define k_YEL_OVAL_MIN_RXY 0.5
#define k_YEL_OVAL_MAX_RX 0.7
#define k_YEL_OVAL_MAX_RY k_maxHW*0.8
#define k_RED colorWithRed:238.0/255 green:18.0/255 blue:0 alpha:1
#define k_YEL colorWithRed:255.0/255 green:133.0/255 blue:0 alpha:1
#define tOfFrame(x) ((x)*1.0/k_maxFrameCount1*(k_maxHW-1))
#define tOfFrameREV(x) (((x)-k_maxFrameCount1)*1.0/k_maxFrameCount2*(k_maxHW-1))

static float f(float x,float min,float max,float x1,float x2,BOOL up)
{
    float y;
    float y1=up?min:max;
    float y2=up?max:min;
    if (x<=x1) {
        y=y1;
    }
    else if (x>=x2)
    {
       y=y2;
    }
    else {
        float k=(y1-y2)/(x1-x2);
        float b=y1-k*x1;
        y=k*x+b;
    }    
    return y;
}

@implementation PicsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setReverse:(BOOL)reverse
{
    _reverse=reverse;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef  ctx=UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    if (!_reverse)
    {
        float w= rect.size.width;
        CGPoint center=CGPointMake(w/2, w/2);
        // float off=k_offset*w;
        float h= rect.size.height;
        float y1=w/2;
        float t=h/w-1;
        UIBezierPath * path1;
        path1=[self addSheetCenter:center ovalRadiusX:w/2 ovalRadiusY1:y1 ovalRadiusY2:f(t, y1, w*k_maxHW-y1, tOfFrame(0), tOfFrame(15), YES)] ;
        
        UIBezierPath * path2;
        path2=[self addOvalCP:CGPointMake(center.x, center.y-y1)  ovalRadiusX:f(t, 0, y1, tOfFrame(0), tOfFrame(4), NO) ovalRadiusY:f(t,y1, y1,tOfFrame(0),tOfFrame(4), YES) ];
        UIBezierPath * path3;
        float p3x,p3y,p3a;
        
        p3a=f(t, 0, 1,tOfFrame(6), tOfFrame(14), NO);
        p3x=p3y=f(t, y1*k_YEL_OVAL_MIN_RXY, y1*k_YEL_OVAL_MAX_RX, tOfFrame(0), tOfFrame(6), YES);
        p3x=f(t, y1*k_YEL_OVAL_MIN_RXY, p3x, tOfFrame(5), tOfFrame(13), NO);
        p3y=f(t, p3y, y1*k_YEL_OVAL_MAX_RY, tOfFrame(4), tOfFrame(13), YES);
        
        path3=[self addOvalCP:CGPointMake(center.x, center.y-y1+w*0.1)  ovalRadiusX:p3x ovalRadiusY:p3y];
        
        [[UIColor k_RED] setFill];
        [path1 fill];
        [path2 fill];
        [[[UIColor k_YEL] colorWithAlphaComponent:p3a] setFill];
        [path3 fill];
    }
    else
    {
        float w= rect.size.width;
                // float off=k_offset*w;
        float h= rect.size.height;
        float y1=w/2;
        float t=k_maxHW - (h/w);
        float c=f(t, w/3, w/2, tOfFrameREV(15), tOfFrameREV(20), NO);
        CGPoint center=CGPointMake(c, c);

        UIBezierPath * path1;
        float sx=f(t,w/7 , w/2, tOfFrameREV(15), tOfFrameREV(20), NO);
        float sy2=f(t,3*sx, w*k_maxHW-y1, tOfFrameREV(15), tOfFrameREV(20), NO);
        path1=[self addSheetCenter:center ovalRadiusX:sx ovalRadiusY1:sx ovalRadiusY2:sy2];
        
                
        float tcx=c;
        float tcy=c+sy2+y1*0.04;
        float tr1=f(t, 0, 50.0/180*M_PI, tOfFrameREV(20), tOfFrameREV(25), YES);
        float tr2=f(t, -25.0/180*M_PI, 0, tOfFrameREV(20), tOfFrameREV(25), NO);
        
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, tcx, tcy);
        CGContextRotateCTM(ctx, tr1);
        CGContextTranslateCTM(ctx, -tcx, -tcy);        
        [[UIColor k_YEL] setFill];
        [path1 fill];
        CGContextRestoreGState(ctx);
        
        
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, tcx, tcy);
        CGContextRotateCTM(ctx,tr2);
        CGContextTranslateCTM(ctx, -tcx, -tcy);
        [[UIColor k_RED] setFill];
        [path1 fill];
        CGContextRestoreGState(ctx);
             
        
    }
    
    CGContextRestoreGState(ctx);
}
-(UIBezierPath *)addOvalCP:(CGPoint)c ovalRadiusX:(float) rx ovalRadiusY:(float) ry
{
    return [UIBezierPath bezierPathWithOvalInRect:(CGRect){{c.x-rx,c.y},{2*rx,2*ry}}];
    
}



-(UIBezierPath *)addSheetCenter:(CGPoint)c ovalRadiusX:(float) rx ovalRadiusY1:(float) ry1 ovalRadiusY2:(float) ry2
{
    UIBezierPath * path=[UIBezierPath bezierPath];
    float ry3=ry1*(1-exp(-1000/(ry2-ry1)));
    [path moveToPoint:CGPointMake(c.x,c.y-ry1)];
    [path addCurveToPoint:CGPointMake(c.x,c.y+ry2) controlPoint1:CGPointMake(c.x-rx,c.y-ry1) controlPoint2:CGPointMake(c.x-rx,c.y+ry3)];
    [path moveToPoint:CGPointMake(c.x,c.y-ry1)];
    [path addCurveToPoint:CGPointMake(c.x,c.y+ry2) controlPoint1:CGPointMake(c.x+rx,c.y-ry1) controlPoint2:CGPointMake(c.x+rx,c.y+ry3)];
    return path;
}

     
     
@end
