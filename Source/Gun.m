//
//  CCNode+Asteroid.m
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "Gun.h"
#import "CCActionCallFuncO.h"
#import "SpaceShip.h"
#import "Bullet.h"

#define kNumLasers      30

@implementation Gun {
    NSMutableArray  *_shipLasers;
    int _nextShipLaser;
    CCNode *_ship;
}

- (id) init :(SpaceShip *) ship{
    _ship = ship;
    _shipLasers = [NSMutableArray arrayWithCapacity : kNumLasers];
    for(int i = 0; i < kNumLasers; ++i) {
        CCSprite *bullet = (CCSprite*)[CCBReader load:@"Bullet"];
        bullet.visible = NO;
        [ship.container addChild:bullet];
        [_shipLasers insertObject: bullet atIndex: i ];
    }
    return self;
}

- (void)shot1{
    [[OALSimpleAudio sharedInstance] playEffect:@"laser_ship.caf"];
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    CCSprite *bullet = [_shipLasers objectAtIndex:_nextShipLaser];
    _nextShipLaser++;
    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
    
    bullet.position = ccpAdd(_ship.position, ccp(0, bullet.contentSize.height/2+_ship.contentSize.height/2));
    bullet.visible = YES;
    [bullet stopAllActions];
    
    
    [bullet runAction:[CCActionSequence actions:
                       [CCActionMoveBy actionWithDuration:3 position:ccp(0,winSize.height)],
                       [CCActionCallFunc actionWithTarget:bullet selector:@selector(setInvisible)],
                       nil]];
    
    CCSprite *bullet2 = [_shipLasers objectAtIndex:_nextShipLaser];
    _nextShipLaser++;
    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
    
    bullet2.position = ccpAdd(_ship.position, ccp(5, bullet2.contentSize.height/2+_ship.contentSize.height/2));
    bullet2.visible = YES;
    [bullet2 stopAllActions];
    
    
    [bullet2 runAction:[CCActionSequence actions:
                       [CCActionMoveBy actionWithDuration:3 position:ccp(20,winSize.height)],
                       [CCActionCallFunc actionWithTarget:bullet2 selector:@selector(setInvisible)],
                       nil]];
    
    
    
    
}

- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
    node.position = ccp(-100, -100);
}

- (void)shot {
    [[OALSimpleAudio sharedInstance] playEffect:@"laser_ship.caf"];
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    

    
    CCSprite *shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
    _nextShipLaser++;
    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
    
//    CGPoint  position =_ship.position;
    
    shipLaser.position = ccpAdd(_ship.position, ccp(0, shipLaser.contentSize.height/2+_ship.contentSize.height/2));
    shipLaser.visible = YES;
    [shipLaser stopAllActions];
    
    
    [shipLaser runAction:[CCActionSequence actions:
                          [CCActionMoveBy actionWithDuration:3 position:ccp(0,winSize.height)],
                          [CCActionCallFuncO actionWithTarget:self selector:@selector(setInvisible:)  object:shipLaser],
                          nil]];
    
    
    
    CCSprite *shipLaser1 = [_shipLasers objectAtIndex:_nextShipLaser];
    _nextShipLaser++;
    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
    
    shipLaser1.position = ccpAdd(_ship.position, ccp(5, shipLaser1.contentSize.height/2+_ship.contentSize.height/2));
    shipLaser1.visible = YES;
    [shipLaser1 stopAllActions];
    
    
    [shipLaser1 runAction:[CCActionSequence actions:
                          [CCActionMoveBy actionWithDuration:3 position:ccp(20,winSize.height)],
                          [CCActionCallFuncO actionWithTarget:self selector:@selector(setInvisible:)  object:shipLaser1],
                          nil]];
    
    
    
    
    CCSprite *shipLaser2 = [_shipLasers objectAtIndex:_nextShipLaser];
    _nextShipLaser++;
    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
    
    shipLaser2.position = ccpAdd(_ship.position, ccp(-5, shipLaser2.contentSize.height/2+_ship.contentSize.height/2));
    shipLaser2.visible = YES;
    [shipLaser2 stopAllActions];
    
    
    [shipLaser2 runAction:[CCActionSequence actions:
                          [CCActionMoveBy actionWithDuration:3 position:ccp(-20,winSize.height)],
                          [CCActionCallFuncO actionWithTarget:self selector:@selector(setInvisible:)  object:shipLaser2],
                          nil]];
    
    
}


@end
