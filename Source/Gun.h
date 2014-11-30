//
//  CCNode+Asteroid.h
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "Player.h"
#import "SpaceShip.h"

@interface Gun : NSObject
- (id) init :(SpaceShip *) ship;
- (void)shot;
- (void)shot3;
@end
