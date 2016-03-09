//
//  BallNode.m
//  lines
//
//  Created by lozhnikov on 18.12.13.
//  Copyright 2013 lozhnikov. All rights reserved.
//

#import "BallNode.h"

@interface BallNode ()
- (id) initWithRandom;

@end

@implementation BallNode
@synthesize ballType, tempPosition;

+ (BallNode*) randomizeNode
{
    return [[[BallNode alloc] initWithRandom] autorelease];
}

- (id) initWithRandom
{
    ballType = arc4random() % (SIX - NONE) + NONE + 1;
    NSString* imageName = [NSString stringWithFormat:@"ball_%d.png", ballType];
    
    self = [super initWithCGImage:[[UIImage imageNamed:imageName] CGImage] key:imageName];
    if (self)
    {
        // create batch animation
        
        // create action
    }
    
    return self;
}

- (void) animate
{
}

@end
