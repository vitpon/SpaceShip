//
//  CCNode+Asteroid.h
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "Player.h"

@interface SpaceShip : Player

@property (assign) CCNode *container;

- (void) shot;
- (void) fire;
- (void) setGun;
@end
