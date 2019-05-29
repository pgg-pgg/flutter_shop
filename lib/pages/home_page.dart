import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  String homePageContent = '正在获取数据';

  @override
  bool get wantKeepAlive => true;
  int page=1;
  List<Map> hotGoodsList=[];


  @override
  void initState() {
    super.initState();
    _getHotGoods();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("百姓生活+"),
        ),
        body: SingleChildScrollView(child:FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //数据处理
              var data = json.decode(snapshot.data.toString());
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
              String leaderImage =
                  data['data']['shopInfo']['leaderImage']; //店长图片
              String leaderPhone =
                  data['data']['shopInfo']['leaderPhone']; //店长电话
              List<Map> recommendList = (data['data']['recommend'] as List).cast(); // 商品推荐
              String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
              String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
              String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
              List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片
              List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片
              List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片

            return Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiper),
                  TabNavigator(
                    navigatorList: navigatorList,
                  ),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone), //广告组件
                  Recommend(recommendList:recommendList),
                  FloorTitle(picture_address:floor1Title),
                  FloorContent(floorGoodsList:floor1),
                  FloorTitle(picture_address:floor2Title),
                  FloorContent(floorGoodsList:floor2),
                  FloorTitle(picture_address:floor3Title),
                  FloorContent(floorGoodsList:floor3),
                  _hotGoods()
                ],
              );
            } else {
              return Center(
                child: Text("正在加载。。。"),
              );
            }
          },
          future: request('homePageContext',formData:{'lon':'115.02932','lat':'35.76189'}),
        )));
  }

  void _getHotGoods(){
    var formData = {'page':page};
    request('homePageBelowConten', formData: formData).then((val){
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top:10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5.0),
    child: Text('火爆专区'),
  );

  Widget _wrapList(){
    if(hotGoodsList.length>0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width: ScreenUtil().setWidth(370),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow:TextOverflow.ellipsis ,
                  style: TextStyle(color:Colors.pink,fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough),

                    )
                  ],
                )

              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
      
    }else{
      return Text(' ');
    }
  }

  //火爆专区组合
  Widget _hotGoods(){

    return Container(

        child:Column(
          children: <Widget>[
            hotTitle,
            _wrapList(),
          ],
        )
    );
  }
}

/**
 * 首页轮播组件
 */
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({this.swiperDataList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(333),
      width: ScreenUtil.getInstance().setWidth(750),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swiperDataList[index]['image']}",
            fit: BoxFit.fitHeight,
          );
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

/**
 * 频道组件
 */
class TabNavigator extends StatelessWidget {
  final List navigatorList;

  TabNavigator({this.navigatorList});

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
        onTap: () {
          print("点击了导航");
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(
                item['image'],
                width: ScreenUtil().setWidth(95),
              ),
              Text(item['mallCategoryName']),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(250),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

/**
 * 广告栏
 */
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({this.adPicture});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

/**
 * 店长图片
 */
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话
  LeaderPhone({this.leaderImage, this.leaderPhone});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcherUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launcherUrl() async {
    String url = 'tel:' + this.leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

/**
 * 推荐模块
 */
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  /**
   * 商品单独项
   */
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('¥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  /**
   * 推荐商品标题
   */
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  /**
   * 横向列表组件
   */
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(270),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _item(index);
        },
        itemCount: recommendList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(330),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

/**
 * 楼层标题
 */
class FloorTitle extends StatelessWidget {
  final String picture_address; // 图片地址
  FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

/**
 * 楼层商品
 */
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  /**
   * 每个商品的子项
   */
  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap:(){print('点击了楼层商品');},
        child: Image.network(goods['image']),
      ),
    );
  }

  /**
   * 前三个商品的组合
   */
  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  /**
   * 其它商品的组合
   */
  Widget _otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }
}





