//
//  LogListViewController.m
//  Muevete
//
//  Created by Andres Abril on 3/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "LogListViewController.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]
@interface LogListViewController (){
    UITableView *tableview;
    NSMutableArray *trackList;
}

@end

@implementation LogListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    trackList=[[NSMutableArray alloc]init];
    
    UIView *topBanner=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topBanner.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.7];
    
    [self.view addSubview:topBanner];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(60, 27, 250, 30)];
    title.backgroundColor=[UIColor clearColor];
    [self.view setClipsToBounds:YES];
    title.textAlignment=NSTextAlignmentLeft;
    title.font=[UIFont boldSystemFontOfSize:25];
    title.textColor=[UIColor whiteColor];
    title.text=@"Recorridos Guardados";
    title.adjustsFontSizeToFitWidth=YES;
    [topBanner addSubview:title];
    
    PullActionButton *backButton=[[PullActionButton alloc]initWithFrame:CGRectMake(-100, 20, 150, 44)];
    backButton.the_delegate=self;
    backButton.tag=1;
    backButton.icon.image=[UIImage imageNamed:@"left.png"];
    [backButton setColor:kRedColor];
    [backButton setHilightColor:kYellowColor];
    [self.view addSubview:backButton];
    
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tableview];
    [self downloadTracks];
    [MBHUDView hudWithBody:@"Cargando Recorridos" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:1000 show:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
#pragma mark - pull button delegate
-(void)actionAccepted:(int)tag{
    if (tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - tableview datasource
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return trackList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *myCell=[[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (trackList.count>0) {
        NSDictionary *dic=[trackList objectAtIndex:indexPath.row];
        myCell.timeLabel.text=[NSString stringWithFormat:@"%.2ih %.2im %.2is",[[dic objectForKey:@"hours"] intValue],[[dic objectForKey:@"minutes"] intValue],[[dic objectForKey:@"seconds"] intValue]];
        myCell.dateLabel.text=[self dateConverterFromString:[dic objectForKey:@"date_created"]];
        double meters=[[dic objectForKey:@"meters"] doubleValue];
        myCell.metersLabel.text=[NSString stringWithFormat:@"%.1fKm",meters/1000];
    }
    return myCell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Deleting");
        if (indexPath.section==0) {
            NSDictionary *dic=[trackList objectAtIndex:indexPath.row];
            [self deleteTrackWithId:[dic objectForKey:@"_id"]];
            [tableview beginUpdates];
            [trackList removeObjectAtIndex:indexPath.row];
            [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableview endUpdates];
        }
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackMapViewController *tmVC=[[TrackMapViewController alloc]init];
    tmVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TrackMap"];
    tmVC.trackDic=[trackList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:tmVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - server request
-(void)downloadTracks{
    FileSaver *file=[[FileSaver alloc]init];
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=1;
    [server callServerWithGETMethod:@"GetTracks" andParameter:[[file getDictionary:@"user"]objectForKey:@"id" ]];
}
-(void)deleteTrackWithId:(NSString*)_id{
    ServerCommunicator *server=[[ServerCommunicator alloc]init];
    server.caller=self;
    server.tag=2;
    NSString *params=[NSString stringWithFormat:@"id=%@&",_id];
    NSLog(@"El ID: %@",_id);
    [server callServerWithPOSTMethod:@"DeleteTrack" andParameter:params httpMethod:@"POST"];
    [MBHUDView hudWithBody:@"Eliminando Recorrido" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:1000 show:YES];
}
#pragma mark - server response
-(void)receivedDataFromServer:(ServerCommunicator*)server{
    NSLog(@"Respuesta del server %@",server.dictionary);
    if (server.tag==1) {
        trackList=[[NSMutableArray alloc]initWithArray:(NSMutableArray*)server.dictionary];
        [MBHUDView dismissCurrentHUD];
    }
    else if(server.tag==2){
        if ([[server.dictionary objectForKey:@"status"]intValue] ==1) {
            NSLog(@"Success %@",server.dictionary);
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"Recorrido eliminado." type:MBAlertViewHUDTypeCheckmark hidesAfter:2 show:YES];
        }
        else{
            NSLog(@"Error %@",server.dictionary);
            [MBHUDView dismissCurrentHUD];
        }
    }
    [tableview reloadData];
}
-(void)receivedDataFromServerWithError:(ServerCommunicator*)server{
    NSLog(@"Respuesta error %@",server.dictionary);
    if (server.tag==1) {
    }
    else if(server.tag==2){
        
    }
    [MBHUDView dismissCurrentHUD];
    [MBHUDView hudWithBody:@"Error.\nRevisa tu conexión." type:MBAlertViewHUDTypeExclamationMark hidesAfter:5 show:YES];
}

#pragma mark - date converter
-(NSString*)dateConverterFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter2 setDateFormat:@"dd 'de' MMMM, HH:mm"];
    NSString *strDate = [dateFormatter2 stringFromDate:dateFromString];
    return strDate;
}
@end
