//
//  MenuScene.m
//  lines2
//
//  Created by lozhnikov on 26.12.13.
//  Copyright 2013 lozhnikov. All rights reserved.
//

#import "MenuScene.h"

@interface MenuScene()
- (void) startClicked;

@end

@implementation MenuScene

// -----------------------------------------------------------------------

+ (MenuScene*)scene
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
        CCMenuItem* item1 = [CCMenuItem itemWithTarget:self selector:@selector(startClicked)];
        CCMenu* menu = [CCMenu menuWithItems:item1, nil];
        
        [self addChild:menu];
    }
	
	return self;
}

#pragma mark - Private Methods

- (void) startClicked
{
}

@end
