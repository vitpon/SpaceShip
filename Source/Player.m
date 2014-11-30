//
//  CCNode+Asteroid.m
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "Player.h"

@implementation Player : CCSprite

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"play";
}

- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
}

@end
