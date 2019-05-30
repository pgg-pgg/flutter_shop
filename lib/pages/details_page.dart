import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/details_tabBar.dart';
import './details_page/details_web.dart';
import './details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;

  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品详情"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder(builder: (context, snapShot) {
        if (snapShot.hasData) {
          return Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  DetailsTopArea(),
                  DetailsExplain(),
                  DetailsTabBar(),
                  DetailsWeb(),
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailsBottom(),
              )
            ],
          );
        } else {
          return Text('加载中...');
        }
      },future: _getBackInfo(context),),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return "加载完成";
  }
}
