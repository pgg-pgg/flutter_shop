import 'package:flutter/material.dart';
import '../model/category_model.dart';

class ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList = [];//商品列表
  int childIndex = 0;//子类索引值
  String categoryId = '4';//大类ID
  String subId =''; //小类ID
  int page=1;  //列表页数，当改变大类或者小类时进行改变
  String noMoreText=''; //显示更多的标识

  getChildCategory(List<BxMallSubDto> list,String id){

    page=1;
    noMoreText = '';

    categoryId=id;
    childIndex=0;
    subId=''; //点击大类时，把子类ID清空
    BxMallSubDto all=  BxMallSubDto();
    all.mallSubId='';
    all.mallCategoryId='00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList=[all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //改变子类索引
  changeChildIndex(index,String id){
    page=1;
    noMoreText = ''; //显示更多的表示

    childIndex=index;
    subId=id;
    notifyListeners();
  }

  //增加Page的方法f
  addPage(){
    page++;
  }

  //改变noMoreText数据
  changeNoMore(String text){
    noMoreText=text;
    notifyListeners();
  }
}