//
//  ViewController.m
//  LearnTest
//
//  Created by yin linlin on 2018/6/4.
//  Copyright © 2018年 yin linlin. All rights reserved.
//

#import "ViewController.h"
#import "LockDemoController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Learn Test";
    [self.titleArray addObject:@"LockTest"];
    [self.titleArray addObject:@"BKJKEncrypt"];
    [self.titleArray addObject:@"BKJKWedgets"];
    [self.titleArray addObject:@"BKJKImagePicker"];
    [self.view addSubview:self.table];
    
    // Do any additional setup after loading the view, typically from a nib.
//    [self removeDuplicatedString:@"abadghdhkb"];
//    [self GCDTest];
}

- (void)GCDTest {
    dispatch_queue_t queue = dispatch_queue_create("com.apple.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTime:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)actionTime:(NSTimer *)timer {
    NSLog(@"%@",[NSDate date]);
}

- (void)removeDuplicatedString:(NSString *)string {
    const char *charArray = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    [string getCharacters:&charArray range:NSMakeRange(0, string.length)];
    
    NSMutableString *newString = [NSMutableString stringWithString:string];
    for (NSInteger i = 0; i < string.length - 2; i ++ ) {
        NSString *str = [newString substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@" "]) {
            continue;
        }
        NSInteger searchBegin = i + 2;
        NSInteger searchLength = string.length - searchBegin;
        NSRange searchRange = NSMakeRange(searchBegin, searchLength);
        NSString *searchString = [newString substringWithRange:searchRange];
        NSString *newRangeString = [searchString stringByReplacingOccurrencesOfString:str withString:@" "];
        [newString replaceCharactersInRange:searchRange withString:newRangeString];
    }
    NSString *result = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",result);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableReuse = @"cellTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableReuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableReuse];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[LockDemoController new] animated:YES];
            break;
        case 1:
//            [self.navigationController pushViewController:[BKJKEncryptDemoViewController new] animated:YES];
            break;
        case 2:
//            [self.navigationController pushViewController:[BKJKWedgetsDemoViewController new] animated:YES];
            break;
        case 3:
//            [self.navigationController pushViewController:[BKJKImagePickerDemoViewController new] animated:YES];
            break;
        default:
            break;
    }
}

- (UITableView *)table {
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
