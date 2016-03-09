//
//  MainContainerNode.m
//  lines
//
//  Created by lozhnikov on 18.12.13.
//  Copyright 2013 lozhnikov. All rights reserved.
//

#import "MainContainerNode.h"

@interface MainContainerNode ()
- (void) createBalls;
- (NSString*) convertPointToKey:(CGPoint)point;
- (void) callFillBalls;
- (void) redraw;
- (BOOL) clean;
- (void) defrag;
- (void) fillBalls;

@end

@implementation MainContainerNode
@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self)
    {
        collisions = [[NSMutableDictionary alloc] initWithCapacity:12 * 12];
        [self createBalls];
        
        // create responder
        [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:1];
        [self performSelector:@selector(redraw) withObject:nil afterDelay:1.0];
    }
    
    return self;
}

#pragma mark - Event Handlers

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!capturedBall)
    {
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView: [touch view]];
        CGPoint glPoint = [[CCDirector sharedDirector] convertToGL:touchLocation];
        
        // find node
        NSInteger x = (int)(glPoint.x - self.position.x) / 60 * 60 + 30;
        NSInteger y  = (int)(glPoint.y - self.position.y) / 60 * 60 + 30;
        CGPoint point = CGPointMake(x, y);
        NSString* key = [self convertPointToKey:point];
        capturedBall = [collisions objectForKey:key];
        
        inProcess = NO;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // move node
    if (!inProcess)
    {
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView: [touch view]];
        CGPoint glPoint = [[CCDirector sharedDirector] convertToGL:touchLocation];
        
        NSInteger x = (int)(glPoint.x - self.position.x) / 60 * 60 + 30;
        NSInteger y  = (int)(glPoint.y - self.position.y) / 60 * 60 + 30;
        
        CGPoint capturedPoint = capturedBall.position;
        
        if (x > capturedPoint.x || x < capturedPoint.x || y > capturedPoint.y || y < capturedPoint.y)
        {
            inProcess = YES;
            
            CGPoint point1 = CGPointMake(x, y);
            CGPoint point2 = CGPointMake(capturedBall.position.x, capturedBall.position.y);
            
            NSString* key = [self convertPointToKey:point1];
            BallNode* nextBall = [collisions objectForKey:key];
            
            CCCallBlockN* actionBlock = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                CCCallBlockN* actionBlock1 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    NSInteger tag1 = capturedBall.tag;
                    NSInteger tag2 = nextBall.tag;
                    
                    capturedBall.tag = tag2;
                    nextBall.tag = tag1;
                    
                    [collisions setObject:capturedBall forKey:[self convertPointToKey:point1]];
                    [collisions setObject:nextBall forKey:[self convertPointToKey:point2]];
                    
                    capturedBall = nil;
                    cleaned = NO;
                    //inProcess = NO;
                }];
                
                CCMoveTo* actionMove2 = [CCMoveTo actionWithDuration:0.3 position:point2];
                CCCallFunc* action3 = [CCCallFunc actionWithTarget:self selector:@selector(redraw)];
                CCSequence* seq1 = [CCSequence actions:actionMove2, actionBlock1, action3, nil];
                [nextBall runAction:seq1];
            }];
            
            CCMoveTo* actionMove1 = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(x, y)];
            CCSequence* seq = [CCSequence actions:actionMove1, actionBlock, nil];
            [capturedBall runAction:seq];
        }
    }
}

- (void)ballMoveComplete
{
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark - Private Methods

- (void) redraw
{
    CCCallBlock* actionBlock1 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [delegate performSelector:@selector(didUpdateScore:) withObject:[NSNumber numberWithInteger:score]];
        if (!cleaned)
        {
            CCCallFuncO* action2 = [CCCallFuncO actionWithTarget:self selector:@selector(defrag)];
            CCSequence* seq2 = [CCSequence actions:action2, nil];
            [self runAction:seq2];
        }
        else
        {
            capturedBall = nil;
        }
    }];
    
    CCCallFunc* action1 = [CCCallFunc actionWithTarget:self selector:@selector(clean)];
    CCSequence* seq1 = [CCSequence actions:action1, actionBlock1, nil];
    [self runAction:seq1];
}

- (void) callFillBalls
{
    CCCallBlock* actionBlock3 = [CCCallBlock actionWithBlock:^{
        capturedBall = nil;
        [self redraw];
    }];
    
    CCCallFuncO* action3 = [CCCallFuncO actionWithTarget:self selector:@selector(fillBalls)];
    CCSequence* seq3 = [CCSequence actions:action3, actionBlock3, nil];
    [self runAction:seq3];
}

- (BOOL) clean
{
    NSMutableArray* garbage1 = [NSMutableArray array];
    NSMutableArray* garbage2 = [NSMutableArray array];
    
    // collect horizontal balls
    for (unsigned int h = 0; h < 12; h++)
    {
        NSInteger tag =  12 * h;
        
        NSMutableDictionary* line = [NSMutableDictionary dictionary];
        
        BallNode* previousBall = (BallNode*)[self getChildByTag:tag];
        BallType previousBallType = previousBall.ballType;
        
        NSString* key1 = [self convertPointToKey:previousBall.position];
        if (previousBall)
        {
            [line setObject:previousBall forKey:key1];
        }
        
        for (unsigned int w = 1; w < 12; w++)
        {
            tag =  12 * h + w;
            BallNode* ball = (BallNode*)[self getChildByTag:tag];
            BallType ballType = ball.ballType;
            
            NSString* key2 = [self convertPointToKey:ball.position];
            if (ballType == previousBallType)
            {
                if (ball)
                {
                    [line setObject:ball forKey:key2];
                }
            }
            if (ballType != previousBallType)
            {
                if ([line count] >= 3)
                {
                    [garbage1 addObject:line];
                }
                
                line = [NSMutableDictionary dictionary];
                if (ball)
                {
                    [line setObject:ball forKey:key2];
                }
            }
            
            previousBallType = ballType;
            
            if (w == 11 && [line count] >= 3)
            {
                [garbage1 addObject:line];
            }
        }
    }
    
    // collect vertical balls
    unsigned int w = 0;
    unsigned int h = 0;
    for (w = 0; w < 12; w++)
    {
        NSInteger tag = w;
        
        NSMutableDictionary* line = [NSMutableDictionary dictionary];
        
        BallNode* previousBall = (BallNode*)[self getChildByTag:tag];
        BallType previousBallType = previousBall.ballType;
        
        NSString* key1 = [self convertPointToKey:previousBall.position];
        if (previousBall)
        {
            [line setObject:previousBall forKey:key1];
        }
        
        for (h = 1; h < 12; h++)
        {
            tag =  12 * h + w;
            
            BallNode* ball = (BallNode*)[self getChildByTag:tag];
            BallType ballType = ball.ballType;
            
            NSString* key2 = [self convertPointToKey:ball.position];
            if (ballType == previousBallType)
            {
                if (ball)
                {
                    [line setObject:ball forKey:key2];
                }
            }
            if (ballType != previousBallType)
            {
                if ([line count] >= 3)
                {
                    [garbage2 addObject:line];
                }
                
                line = [NSMutableDictionary dictionary];
                if (ball)
                {
                    [line setObject:ball forKey:key2];
                }
            }
            
            previousBallType = ballType;
            
            if (h == 11 && [line count] >= 3)
            {
                [garbage1 addObject:line];
            }
        }
    }
    
    // cleanup
    BOOL success = NO;
    
    // cleanup horizontal
    for (NSDictionary* line in garbage1)
    {
        success = YES;
        for (BallNode* ball in [line allValues])
        {
            [self removeChild:ball];
            
            score += ball.ballType;
            
            NSString* key = [self convertPointToKey:ball.position];
            [collisions removeObjectForKey:key];
        }
    }
    
    // cleanup vertical
    for (NSDictionary* line in garbage2)
    {
        success = YES;
        for (BallNode* ball in [line allValues])
        {
            [self removeChild:ball];
            
            score += ball.ballType;
            
            NSString* key = [self convertPointToKey:ball.position];
            [collisions removeObjectForKey:key];
        }
    }
    
    cleaned = !success;
    return success;
}

- (void) defrag
{
    NSMutableArray* actions = [NSMutableArray array];
    
    for (unsigned int h = 0; h < 12; h++)
    {
        for (unsigned int w = 0; w < 12; w++)
        {
            NSInteger tag =  12 * h + w;
            BallNode* ball = (BallNode*)[self getChildByTag:tag];
            
            if (!ball)
            {
                // find first ball upper
                for (unsigned int h1 = h + 1; h1 < 12; h1++)
                {
                    NSInteger tag1 = 12 * h1 + w;
                    BallNode* ball1 = (BallNode*)[self getChildByTag:tag1];
                    if (ball1)
                    {
                        // move it to the current position
                        CGPoint point = CGPointMake(60 * w + 30, 60 * h + 30);
                        
                        ball1.tag = tag;
                        [collisions setObject:ball1 forKey:[self convertPointToKey:point]];
                        
                        ball1.tempPosition = CGPointMake(point.x, point.y);
                        [actions addObject:ball1];
                        
                        break;
                    }
                }

            }
        }
    }
    
    for (BallNode* ball in actions)
    {
        CCMoveTo* actionMove = [CCMoveTo actionWithDuration:0.3 position:ball.tempPosition];
        CCCallBlockN* actionBlock = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            if ([actions indexOfObject:ball] == [actions count] - 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self callFillBalls];
                });
            }
        }];
        CCSequence* seq = [CCSequence actions:actionMove, actionBlock, nil];
        [ball runAction:seq];
    }
    
    if ([actions count] == 0 && !cleaned)
    {
        cleaned = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self callFillBalls];
        });
    }
    
}

- (void) fillBalls
{
    for (unsigned int h = 0; h < 12; h++)
    {
        for (unsigned int w = 0; w < 12; w++)
        {
            NSInteger tag =  12 * h + w;
            BallNode* ball = (BallNode*)[self getChildByTag:tag];
            
            if (!ball)
            {
                // create a new ball
                ball = [BallNode randomizeNode];
                ball.position = CGPointMake(60 * w + 30, 60 * h + 30);
                ball.contentSize = CGSizeMake(60, 60);
                
                [self addChild:ball z:0];
                [collisions setObject:ball forKey:[self convertPointToKey:ball.position]];
            }
            
            ball.tag = 12 * h + w;
        }
    }
}

- (void) createBalls
{
    for (int h = 0; h < 12; h++)
    {
        for (int w = 0; w < 12; w++)
        {
            BallNode* ball = [BallNode randomizeNode];
            ball.tag = 12 * h + w;
            ball.position = CGPointMake(60 * w + 30, 60 * h + 30);
            ball.contentSize = CGSizeMake(60, 60);
            
            [self addChild:ball z:0];
            [collisions setObject:ball forKey:[self convertPointToKey:ball.position]];
        }
    }
}

- (NSString*) convertPointToKey:(CGPoint)point
{
    NSString* key = [NSString stringWithFormat:@"%d,%d", (int)point.x, (int)point.y];
    return key;
}

@end
