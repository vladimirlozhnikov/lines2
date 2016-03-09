//
//  MainContainerNode.h
//  lines
//
//  Created by lozhnikov on 18.12.13.
//  Copyright 2013 lozhnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BallNode.h"
#import "Protocol.h"

@interface MainContainerNode : CCNode <CCTouchAllAtOnceDelegate>
{
    NSMutableDictionary* collisions;
    BallNode* capturedBall;
    BOOL inProcess;
    BOOL cleaned;
    NSInteger score;
    
    id <MainContainerNodeProtocol> delegate;
}

@property (assign) id <MainContainerNodeProtocol> delegate;

@end
