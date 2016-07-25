#UITableView结合Masonry实现自动行高  

##实现原理  
1. 通过给cell添加分类，在分类中通过属性关联的方式，动态添加两个缓存池，一个是cellCachePool， 一个是heightCachePool
2. 不同的数据模型，对应cell高度不一样，所以，需要给每个数据模型都进行编码uid
3. 一个UITableView可以有多种不同类型的cell，需要对不同的cell设置不同的标识码
4. cellCachePool 是一个字典，通过cell的标识码，可以取出对应的cell
5. heightCachePool 是一个字典，字典里存放的是每个cell的字典，一个cell可能对应多个数据，使用模型uid取出height

  
##使用方式
###1. cell高度自动计算，但是不缓存  
***使用方法:***    
*a.在自定义cell中，指定那个view为cell的最后一个控件,以及，最后一个控件到cell底部的距离*   

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {  
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {  
  	
  	    self.gapLineView = gapLineView;
        //必须配置最后一个view
        self.lastViewInCell = self.gapLineView;
        self.lastViewOffset = 0;
 }

*b.在控制器中，计算行高时，需要先配置cell数据*  
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
'return [FDTableViewCell heightForTableView:tableView cellConfig:^(UITableViewCell *cell) {  
        FDTableViewCell *heightCell = (FDTableViewCell *)cell;  
        [heightCell configCellWithModel:model];  
    }];'  
}

###2. cell高度自动计算，同时缓存起来
***使用方法:***    
*a.在自定义cell中，指定那个view为cell的最后一个控件,以及，最后一个控件到cell底部的距离*   

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {  
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {  
  	
  	    self.gapLineView = gapLineView;
        //必须配置最后一个view
        self.lastViewInCell = self.gapLineView;
        self.lastViewOffset = 0;
 }

*b.在控制器中，计算行高时，需要先配置cell数据*  
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    NSDictionary *cellInfo = @{kCellIdKey : [NSString stringWithFormat:@"%d", model.statusId],  
                               kCellStatusIdKey : [NSString stringWithFormat:@"%d", model.isExpanded]};
    
    return [FDTableViewCell heightForTableView:tableView cellConfig:^(UITableViewCell *cell) {
        FDTableViewCell *heightCell = (FDTableViewCell *)cell;
        [heightCell configCellWithModel:model];
    } cache:cellInfo];
}

