//
//  BallNode.h
//  lines
//
//  Created by lozhnikov on 18.12.13.
//  Copyright 2013 lozhnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum BALL_TYPE
{
    NONE,
    ONE,
    TWO,
    THREE,
    FOUR,
    FIVE,
    SIX
} BallType;

@interface BallNode : CCSprite
{
    BallType ballType;
    CGPoint tempPosition;
}

@property (readonly) BallType ballType;
@property (nonatomic,readwrite,assign) CGPoint tempPosition;

+ (BallNode*) randomizeNode;
- (void) animate;

@end
