//
//  LinesScene.h
//  lines
//
//  Created by lozhnikov on 18.12.13.
//  Copyright lozhnikov 2013. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "MainContainerNode.h"
#import "Protocol.h"

// -----------------------------------------------------------------------

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayeßr now, is to make colored backgrounds (rectangles)
 *
 */
@interface LinesScene : CCScene <CCTouchAllAtOnceDelegate, MainContainerNodeProtocol>
{
    MainContainerNode* mainContainerNode;
}

// -----------------------------------------------------------------------

+ (LinesScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end