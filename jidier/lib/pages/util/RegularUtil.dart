import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class RegularUtil{
  ///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
  /// 此方法中前三位格式有：
  /// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
  static bool isChinaPhoneLegal(String str) {
    return new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[0-9])|(147,145))\\d{8}\$').hasMatch(str);
  }
  static bool isCallnum(String str){

    return new RegExp('(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?))').hasMatch(str);
   // return RegExp(urlAndPhone).hasMatch(str);
  }
  //判断是否是网址
  static bool isUrl(String str){
    return new RegExp('\\b[h][t][t][p][s]{0,1}.?.?.?[w]{3}\.[a-z\.\\d]*\.[cn][oen][tm]{0,1}\\b').hasMatch(str);
   // return str.contains('baidu');
  }

  /*判断一个字符串中是否包含电话号码*/
  static bool isContainPhoneNum(String str){
    if(str.isEmpty){
      return false;
    }
    RegExp exp=RegExp('(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?))');
      Iterable<Match>  matches= exp.allMatches(str);

       if(matches==null||matches.length==0){
         return false;
       }else{
         for(Match m in matches){
          String match = m.group(0);
           print(match);
         }
         return true;
       }
  }

  static List<String>  getCutPhoneList (String content) {
   // content="我的电话号码是23012814913公司网站是https://www.baidu.com主页公司主页http://www.jdr321.com网址https://www.yifeiyang.net我的哈哈哈哈过";
    List<String> strs=List<String>();
    List<String> contents=List<String>();
    if(content.isEmpty){
      return strs;
    }
    //String urlAndPhone=url+'|'+phone;((?:https?):\/\/[^\s/\$.?#].[^\s]*)
    RegExp exp=RegExp('(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?)|(\\b[h][t][t][p][s]{0,1}.?.?.?[w]{3}\.[a-z\.\\d]*\.[cn][oen][tm]{0,1}\\b))');
    // RegExp exp=RegExp('\(\^https\)\*\(com\$\)');
   // RegExp exp=RegExp('(^\d+\$)');
    Iterable<Match>  matches= exp.allMatches(content);
    String myContent=""+content;

    if(matches==null||matches.length==0){
       strs.add(content);
    }else{
      for(Match m in matches){
        contents.add(m.group(0));
      }

      for(int i=0;i<contents.length;i++){
          String   item=contents[i];
         List<String> results=splitfirst(myContent,item);
         strs.add(results[0]);
         strs.add(results[1]);
         if(i==contents.length-1){
           strs.add(results[2]);
         }else{
           myContent=results[2];
         }

      }

    }




    return strs;

  }


  static List<String>  splitfirst(String content,String split){
    List<String> resultList=List<String>();
              int startPosition=content.indexOf(split);
              String firstStr= content.substring(0,startPosition);
              resultList.add(firstStr);
             // String   midStr=content.substring(startPosition,split.length);
              resultList.add(split);
              String      endStr= content.substring(startPosition+split.length,content.length);
              resultList.add(endStr);

              return resultList;

  }




}