//
//  STGraphView.h
//  STGraphView
//
//  Created by Shinone Tetsuya on 2013/02/24.
//  Copyright (c) 2013 Shinone Tetsuya. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_GRAPH_PLOT_POINTS 32

typedef enum STGraphViewType : NSInteger {
    STGraphViewTypeLine,
    STGraphViewTypeBar,
    STGraphViewTypePie
} STGraphViewType;

typedef enum STGraphViewValueType : NSInteger {
    STGraphViewValueTypeNormal,
    STGraphViewValueTypeCumulative
} STGraphViewValueType;

@protocol STGraphViewDelegate
@required
- (int)numberOfValue;
- (int)valueOfIndex:(int)index;
- (UIColor *)lineColorOfValue;
- (UIColor *)fillColorOfValue;
@optional
@end

@interface STGraphView : UIView
{
    id _delegate;
    float _paddingWidth;
    float _paddingHeight;
    float _lineWidth;
    float _axisLineWidth;
    
    int _type;
    int _valueType;
}

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) float paddingWidth;
@property (assign, nonatomic) float paddingHeight;

@property (assign, nonatomic) int type;
@property (assign, nonatomic) int valueType;

- (void)setPaddingWithWidth:(float)width height:(float)height;

@end
