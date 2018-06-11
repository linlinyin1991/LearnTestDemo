//
//  LockDemoController.m
//  LearnTest
//
//  Created by yin linlin on 2018/6/11.
//  Copyright © 2018年 yin linlin. All rights reserved.
//

#import "LockDemoController.h"
#import <pthread.h>

@interface LockDemoController ()
{
    NSInteger       _testCount;
}

@property (nonatomic, assign) NSInteger testCount;

@end

@implementation LockDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _testCount = 10000000;
    
    self.title = @"iOS lock Test";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

- (void)setUI {
    NSArray *titles = @[@"NSLockTest",@"@synchronized",@"dispatch_semaphore",@"pthread_mutex",@"NSConditionTest",@"NSConditionLockTest",@"NSRecursiveLockTest"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.tag = 110 + i;
        [button addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(50, 100 + 70 * i, self.view.bounds.size.width - 100, 44);
        [self.view addSubview:button];
    }
}

- (void)btnPressed:(UIButton *)sender {
    NSInteger tag = sender.tag - 110;
    switch (tag) {
        case 0:
            [self lockTest];
            break;
        case 1:
            [self synchronizedTest];
            break;
        case 2:
            [self dispatch_semaphoreTest];
            break;
        case 3:
            [self pthread_mutexTest];
            break;
        case 4:
            [self conditionTest];
            break;
        case 5:
            [self conditionLockTest];
            break;
        case 6:
            [self recursiveLockTest];
            break;
        default:
            break;
    }
}

- (void)lockTest {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_testCount];
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSLock *lock = [[NSLock alloc] init];
    //存储数据
    for (NSInteger i = 0; i < _testCount; i ++) {
        [lock lock];
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
        [lock unlock];
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime timeSpace = end - start;
    NSLog(@"NSLock加锁1000万次所需时间：%f",timeSpace);
}

- (void)conditionTest {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_testCount];
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSCondition *lock = [[NSCondition alloc] init];
    //存储数据
    for (NSInteger i = 0; i < _testCount; i ++) {
        [lock lock];
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
        [lock unlock];
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime timeSpace = end - start;
    NSLog(@"NSCondition加锁1000万次所需时间：%f",timeSpace);
}

- (void)conditionLockTest {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_testCount];
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSConditionLock *lock = [[NSConditionLock alloc] init];
    //存储数据
    for (NSInteger i = 0; i < _testCount; i ++) {
        [lock lock];
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
        [lock unlock];
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime timeSpace = end - start;
    NSLog(@"NSConditionLock加锁1000万次所需时间：%f",timeSpace);
}

- (void)recursiveLockTest {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_testCount];
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    //存储数据
    for (NSInteger i = 0; i < _testCount; i ++) {
        [lock lock];
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
        [lock unlock];
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime timeSpace = end - start;
    NSLog(@"NSRecursiveLock加锁1000万次所需时间：%f",timeSpace);
}


- (void)synchronizedTest {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_testCount];
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    //存储数据
    for (NSInteger i = 0; i < _testCount; i ++) {
        @synchronized(array) {
            [array addObject:[NSString stringWithFormat:@"%ld",i]];
        }
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime timeSpace = end - start;
    NSLog(@"synchronized加锁1000万次所需时间：%f",timeSpace);
}


- (void)pthread_mutexTest {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_testCount];
    pthread_mutex_t lock;
    pthread_mutex_init(&lock, NULL);
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    //存储数据
    for (NSInteger i = 0; i < _testCount; i ++) {
        pthread_mutex_lock(&lock);
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
        pthread_mutex_unlock(&lock);
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime timeSpace = end - start;
    NSLog(@"pthread_mutex加锁1000万次所需时间：%f",timeSpace);
}


- (void)dispatch_semaphoreTest {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_testCount];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    //存储数据
    for (NSInteger i = 0; i < _testCount; i ++) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
        dispatch_semaphore_signal(semaphore);
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime timeSpace = end - start;
    NSLog(@"dispatch_semaphore加锁1000万次所需时间：%f",timeSpace);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
