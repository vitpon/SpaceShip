#import "GamePlay.h"
#import "CCActionInterval.h"
//#import "SneakyJoystick.h"
//#import "SneakyJoystickSkinnedBase.h"
//#import "ColoredCircleSprite.h"
//#import "objc/message.h"
//#import "SneakyButton.h"
//#import "SneakyButtonSkinnedBase.h"

#import "CCPhysics+ObjectiveChipmunk.h"

//#import "CCActionCallFuncO.h"
#import "Asteroid.h"
#import "Player.h"
#import "SpaceShip.h"

#define kNumLasers      21

#define kNumAsteroids   15

#define life   3

@interface CGPointObject : NSObject
{
    CGPoint _ratio;
    CGPoint _offset;
    CCNode *__unsafe_unretained _child; // weak ref
}
@property (nonatomic,readwrite) CGPoint ratio;
@property (nonatomic,readwrite) CGPoint offset;
@property (nonatomic,readwrite,unsafe_unretained) CCNode *child;
+(id) pointWithCGPoint:(CGPoint)point offset:(CGPoint)offset;
-(id) initWithCGPoint:(CGPoint)point offset:(CGPoint)offset;
@end


typedef enum {
    kEndReasonWin,
    kEndReasonLose
} EndReason;

@implementation GamePlay {
    
    
    CCNode *_screan;
    
    CCNode *_bgDust1;
    CCNode *_bgDust2;
    NSArray *_bgDusts;

    CGPoint _cloudParallaxRatio;
    CGPoint _bushParallaxRatio;
    
    CCNode *_parallaxContainer;
    CCParallaxNode *_parallaxBackground;
    
    SpaceShip *_ship;

    
    NSMutableArray  *_shipLasers;
    int _nextShipLaser;
    CGPoint touchLocationOld;

    
    NSMutableArray *_asteroids;
    int _nextAsteroid;
    double _nextAsteroidSpawn;
    
    int _lives;
    
    double _gameOverTime;
    bool _gameOver;
    
//    SneakyJoystickSkinnedBase *leftJoy;
//    SneakyButtonSkinnedBase *rightBut;
    CCPhysicsNode *_physicsNode;
    
     NSMutableArray *_life;
    
}

- (void)didLoadFromCCB {
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
//    leftJoy = [[SneakyJoystickSkinnedBase alloc] init];
//    leftJoy.position = ccp(84,84);
//    
//    // Sprite that will act as the outter circle. Make this the same width as joystick.
//    leftJoy.backgroundSprite = [CCSprite spriteWithImageNamed:@"dpad.png"];
//    // Sprite that will act as the actual Joystick. Definitely make this smaller than outer circle.
//    leftJoy.thumbSprite = [CCSprite spriteWithImageNamed:@"joystick.png"];
//    
//    leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
//    [self addChild:leftJoy];
//    [self schedule:@selector(tick:) interval:1.0f/60.0f];

    
    
    
    
//    rightBut = [[SneakyButtonSkinnedBase alloc] init];
//    rightBut.position = ccp(winSize.width - 32 ,32);
//    CCColor *cc1 = [CCColor colorWithRed:255 green:255 blue:255 alpha:128];
//    rightBut.defaultSprite = [ColoredCircleSprite circleWithColor:cc1 radius:20];
//    CCColor *cc2 = [CCColor colorWithRed:255 green:255 blue:255 alpha:255];
//    rightBut.activatedSprite = [ColoredCircleSprite circleWithColor:cc2 radius:20];
//    CCColor *cc3 = [CCColor colorWithRed:255 green:0 blue:0 alpha:255];
//    rightBut.pressSprite = [ColoredCircleSprite circleWithColor:cc3 radius:20];
//    rightBut.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
//    //    rightBut.button.isToggleable = YES;
//    [self addChild:rightBut];
 
    _ship = (SpaceShip*)[CCBReader load:@"SpaceShip"];
    _ship.container = _physicsNode;
    [_ship setGun];
    _ship.position = ccp(winSize.width/2, winSize.width/10);
    [_physicsNode addChild:_ship];
//    [self addChild:_ship];
    
    
    [_ship schedule:@selector(shot) interval:0.3f];
    
    
    self.userInteractionEnabled = TRUE;
    _bgDusts = @[_bgDust1, _bgDust2];
    _parallaxBackground = [CCParallaxNode node];
    [_parallaxContainer addChild:_parallaxBackground];
    
    // Note that the bush ratio is larger than the cloud
    _bushParallaxRatio = ccp(0.9, 1);
    _cloudParallaxRatio = ccp(0.5, 1);
    
    //    for (CCNode *bush in _bushes) {
    //        CGPoint offset = bush.position;
    //        [self removeChild:bush];
    //        [_parallaxBackground addChild:bush z:0 parallaxRatio:_bushParallaxRatio positionOffset:offset];
    //    }
    
    for (CCNode *cloud in _bgDusts) {
        CGPoint offset = cloud.position;
        [_screan removeChild:cloud];
        [_parallaxBackground addChild:cloud z:0 parallaxRatio:_cloudParallaxRatio positionOffset:offset];
    }
    
    NSArray *starsArray = [NSArray arrayWithObjects:@"Stars1.plist", @"Stars2.plist", @"Stars3.plist", nil];
    //NSArray *starsArray = [NSArray arrayWithObjects:@"Stars1.plist", nil];
    for(NSString *stars in starsArray) {
        CCParticleSystem *starsEffect = [CCParticleSystem particleWithFile:stars];
        [_screan addChild:starsEffect z:1];
    }
    
    _lives = 3;
    double curTime = CACurrentMediaTime();
    _gameOverTime = curTime + 30.0;
    
    [[OALSimpleAudio sharedInstance] playBg:@"SpaceGame.caf" loop:YES];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"explosion_large.caf"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"laser_ship.caf"];
    
    
    
    
    _shipLasers = [NSMutableArray arrayWithCapacity : kNumLasers];
    for(int i = 0; i < kNumLasers; ++i) {
        CCSprite *bullet = (CCSprite*)[CCBReader load:@"Bullet"];
        bullet.visible = NO;
        bullet.position = ccp(-10, -10);
        //        [_screan addChild:bullet];
        [_physicsNode addChild:bullet];
        [_shipLasers insertObject: bullet atIndex: i ];
    }
    
    
    _asteroids = [NSMutableArray arrayWithCapacity : kNumAsteroids];
    for(int i = 0; i < kNumAsteroids; ++i) {
        CCSprite *asteroid = (CCSprite*)[CCBReader load:@"Asteroid"];
        asteroid.visible = NO;
        asteroid.position = ccp(-100, -100);
        [_physicsNode addChild:asteroid];
        //        [_screan addChild:shipLaser];
        [_asteroids insertObject: asteroid atIndex: i ];
    }
    
    
    _physicsNode.collisionDelegate = self;
    
    
    _life = [NSMutableArray arrayWithCapacity : life];
    for(int i = 0; i < life; ++i) {
        CCSprite *shipIcon = (CCSprite*)[CCBReader load:@"SpaceShipIcon"];
        shipIcon.position = ccp(15+(20 * i), 10);
        [_life insertObject: shipIcon atIndex: i ];
        [self addChild:shipIcon];
    }
    
    
}

//-(void) tick: (CCTime) dt{
//    if (leftJoy.joystick.velocity.x!=0 || leftJoy.joystick.velocity.y!=0 ){
//        CGFloat x = _ship.position.x+100*leftJoy.joystick.velocity.x*dt;
//        CGFloat y = _ship.position.y+100*leftJoy.joystick.velocity.y*dt;
//        CGSize winSize = [CCDirector sharedDirector].viewSize;
//        CGFloat xp = _ship.position.x;
//        if(x > 0 && x < winSize.width){
//            xp = x;
//        }
//        CGFloat yp = _ship.position.y;
//        if(y > 0 && y < winSize.height){
//            yp = y;
//        }
//        _ship.position = ccp(xp,yp);
//    }
//    
//    if (rightBut.button.active == YES){
//
//        [self fire];
//        
//    }
//}



// Add new method, above update loop
- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)restartTapped:(id)sender {
    
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

- (void)endScene:(EndReason)endReason {
    
    if (_gameOver) return;
    _gameOver = true;
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"You win!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lose!";
    }
    
    CCLabelBMFont *label;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial-hd.fnt"];
    } else {
        label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    }
    label.scale = 0.5;
    label.position = ccp(winSize.width/2, winSize.height * 0.6);
    [self addChild:label];
    
    CCLabelBMFont *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial-hd.fnt"];
    } else {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
    };
    

    CCButton*  calculationStepButton= [CCButton buttonWithTitle:@"Restart"];
    [calculationStepButton setTarget:self selector:@selector(restartTapped:)];
    // create second button
//    self.animationButton = [CCButton buttonWithTitle:LABEL_ANIMATE];
//    [self.animationButton setTarget:self selector:@selector(animateButtonTouched:)];
    // setup layoutbox and add items
    CCLayoutBox *layoutBox = [[CCLayoutBox alloc] init];
    layoutBox.anchorPoint = ccp(0.5, 0.5);
    [layoutBox addChild:calculationStepButton];
//    [layoutBox addChild:self.animationButton];
    layoutBox.spacing = 10.f;
    layoutBox.direction = CCLayoutBoxDirectionVertical;
    [layoutBox layout];
    layoutBox.position = ccp(winSize.width/2, winSize.height * 0.5);
    [self addChild:layoutBox];
    
    
}

- (void)update:(CCTime)delta {
    
    CGPoint backgroundScrollVel = ccp( 0, -500);
    _parallaxBackground.position = ccpAdd(_parallaxBackground.position, ccpMult(backgroundScrollVel, delta));
    
    // loop the clouds
    for (CCNode *cloud in _bgDusts) {
        // get the world position of the cloud
        CGPoint cloudWorldPosition = [_parallaxBackground convertToWorldSpace:cloud.position];
        // get the screen position of the cloud
        CGPoint cloudScreenPosition = [_screan convertToNodeSpace:cloudWorldPosition];
        
        // if the left corner is one complete width off the screen,
        // move it to the right
        if (cloudScreenPosition.y <= (-1 * cloud.contentSize.height)) {
            for (CGPointObject *child in _parallaxBackground.parallaxArray) {
                if (child.child == cloud) {
                    child.offset = ccp(child.offset.x , child.offset.y + 2*cloud.contentSize.height);
                }
            }
        }
    }
    
    
   CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    double curTime = CACurrentMediaTime();
    if (curTime > _nextAsteroidSpawn) {
        
        float randSecs = [self randomValueBetween:0.20 andValue:1.0];
        _nextAsteroidSpawn = randSecs + curTime;
        
        float randX = [self randomValueBetween:0.0 andValue:winSize.width];
        float randDuration = [self randomValueBetween:2.0 andValue:10.0];
        
        CCSprite *asteroid = [_asteroids objectAtIndex:_nextAsteroid];
        _nextAsteroid++;
        if (_nextAsteroid >= _asteroids.count) _nextAsteroid = 0;
        
        [asteroid stopAllActions];
        asteroid.position = ccp(randX,winSize.height + asteroid.contentSize.height);
        asteroid.visible = YES;

        
//        [asteroid runAction:[CCActionSequence actions:
//                             [CCActionMoveTo actionWithDuration:randDuration position:ccp(asteroid.position.x ,-asteroid.contentSize.height)],
//                             [CCActionCallFuncO actionWithTarget:self selector:@selector(setInvisibleAsteroid:)  object:asteroid],
//                             nil]];
        
        [asteroid runAction:[CCActionSequence actions:
                             [CCActionMoveTo actionWithDuration:randDuration position:ccp(asteroid.position.x ,-asteroid.contentSize.height)],
                             [CCActionCallFunc actionWithTarget:asteroid selector:@selector(setInvisible)],
                             nil]];
        
    }
    
//    for (CCSprite *asteroid in _asteroids) {
//        if (!asteroid.visible) continue;
//        
//        for (CCSprite *shipLaser in _shipLasers) {
//            if (!shipLaser.visible) continue;
//            
//            if (CGRectIntersectsRect(shipLaser.boundingBox, asteroid.boundingBox)) {
//                shipLaser.visible = NO;
//                asteroid.visible = NO;
//                [[OALSimpleAudio sharedInstance] playEffect:@"explosion_large.caf"];
//                continue;
//            }
//        }
//        
//        if (CGRectIntersectsRect(_ship.boundingBox, asteroid.boundingBox)) {
//            asteroid.visible = NO;
//            [[OALSimpleAudio sharedInstance] playEffect:@"explosion_large.caf"];
//            [_ship runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
//            _lives--;
//        }
//    }
    
    if (_lives <= 0) {
        [_ship stopAllActions];
        _ship.visible = FALSE;
        [self endScene:kEndReasonLose];
    } else if (curTime >= _gameOverTime) {
        [self endScene:kEndReasonWin];
    }

}
//- (void)fire{
//    [[OALSimpleAudio sharedInstance] playEffect:@"laser_ship.caf"];
//    CGSize winSize = [CCDirector sharedDirector].viewSize;
//    
//    CCSprite *shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
//    _nextShipLaser++;
//    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
//    
//    
//    shipLaser.position = ccpAdd(_ship.position, ccp(0, shipLaser.contentSize.height/2+_ship.contentSize.height/2));
//    shipLaser.visible = YES;
//    [shipLaser stopAllActions];
//    
//    
//    [shipLaser runAction:[CCActionSequence actions:
//                          [CCActionMoveBy actionWithDuration:2 position:ccp(0,winSize.height)],
//                          [CCActionCallFuncO actionWithTarget:self selector:@selector(setInvisible:)  object:shipLaser],
//                          nil]];
//    
//    
//    shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
//    _nextShipLaser++;
//    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
//    
//    
//    shipLaser.position = ccpAdd(_ship.position, ccp(0, shipLaser.contentSize.height/2+_ship.contentSize.height/2));
//    shipLaser.visible = YES;
//    [shipLaser stopAllActions];
//    
//    
//    [shipLaser runAction:[CCActionSequence actions:
//                          [CCActionMoveBy actionWithDuration:2 position:ccp(50,winSize.height)],
//                          [CCActionCallFuncO actionWithTarget:self selector:@selector(setInvisible:)  object:shipLaser],
//                          nil]];
//    
//    
//    shipLaser = [_shipLasers objectAtIndex:_nextShipLaser];
//    _nextShipLaser++;
//    if (_nextShipLaser >= _shipLasers.count) _nextShipLaser = 0;
//    
//    
//    shipLaser.position = ccpAdd(_ship.position, ccp(0, shipLaser.contentSize.height/2+_ship.contentSize.height/2));
//    shipLaser.visible = YES;
//    [shipLaser stopAllActions];
//    
//    
//    [shipLaser runAction:[CCActionSequence actions:
//                          [CCActionMoveBy actionWithDuration:2 position:ccp(-50,winSize.height)],
//                          [CCActionCallFuncO actionWithTarget:self selector:@selector(setInvisible:)  object:shipLaser],
//                          nil]];
//    
//}


- (void)setInvisible:(CCNode *)node {
    node.visible = NO;
    node.position = ccp(-100, -100);
}


- (void)setInvisibleAsteroid:(CCNode *)node {
    node.visible = NO;
    node.position = ccp(-500, -500);
}



-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{

    CGPoint touchLocation = [touch locationInNode:_screan];
    touchLocationOld = touchLocation;
    
}

- (void)touchMoved:(CCTouch *)touch withEvent:(UIEvent *)event
{

    CGPoint touchLocation = [touch locationInNode:_screan];
    
//    NSLog(@"touchLocationOld %@ %@", NSStringFromCGPoint(touchLocationOld), NSStringFromCGPoint(touchLocation));
    CGPoint move = ccpSub(touchLocation,touchLocationOld);
    CGPoint move2 = ccp(move.x,move.y);
    
    _ship.position = ccpAdd(_ship.position, move2);
    touchLocationOld = touchLocation;
}

-(void) touchEnded:(CCTouch *)touch withEvent:(UIEvent *)event
{
}

-(void) touchCancelled:(CCTouch *)touch withEvent:(UIEvent *)event
{
}


-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair asteroid:(Asteroid *)asteroid play:(Player *)player
{
    if (!asteroid.visible || !player.visible) return;
    [asteroid hit];
    CCLOG(@"SpaceShip %@",[player class]);
    if ([player isKindOfClass:[SpaceShip class]]){
        
        if(_life.count > 0){
            CCSprite* spaceShip = (CCSprite *)_life.lastObject;
            [spaceShip removeFromParent];
            [_life removeLastObject];
        }

    }else{
        player.visible = NO;
        player.position = ccp(-100,100);
    }

    
    
    
    
}
@end
