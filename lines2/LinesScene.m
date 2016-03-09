//
//  LinesScene.m
//  lines
//
//  Created by lozhnikov on 18.12.13.
//  Copyright lozhnikov 2013. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "LinesScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

NSString *preview =
@"Cosos2D Version 3 (preview)\n\n\
For evaluation only\n\
Do not use for new development";

// -----------------------------------------------------------------------

@implementation LinesScene

// -----------------------------------------------------------------------

+ (LinesScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (self)
    {
        CGPoint position = CGPointMake(250.0, 30.0);
        CGSize size = CGSizeMake(12 * 60, 12 * 60);
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Score: " fontName:@"Arial" fontSize:32];
        label.tag = 10000;
        label.color = ccc3(255, 255, 255);
        label.position = CGPointMake(100.0, 700.0);
        [self addChild: label];
        
        // create background node
        CCLayerColor* layerColor = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:size.width height:size.height];
        layerColor.position = position;
        [self addChild:layerColor z:0];
        
        // create game field node
        mainContainerNode = [MainContainerNode node];
        mainContainerNode.delegate = self;
        mainContainerNode.position = position;
        mainContainerNode.contentSize = size;
        [self addChild:mainContainerNode z:1];
    }
	
	return self;
}

#pragma mark -  MainContainerNodeProtocol

- (void) didUpdateScore:(NSNumber*)score
{
    CCLabelTTF* label = (CCLabelTTF*)[self getChildByTag:10000];
    NSString* scoreText = [NSString stringWithFormat:@"Score: %@", score];
    label.string = scoreText;
}

// -----------------------------------------------------------------------
@end