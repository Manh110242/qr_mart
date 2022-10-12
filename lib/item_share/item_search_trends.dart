import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/home_api.dart';

import 'package:gcaeco_app/model/search_trend.dart';

// ignore: camel_case_types
class Item_Search_Trends extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final Search_Trend search_trend;

  const Item_Search_Trends(this.search_trend);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: 120,
                  child: Image.network(Const().domain +"static"+ search_trend.avatar_path+search_trend.avatar_name, fit: BoxFit.fill,))
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width/3.5 ,
                child: Text(search_trend.keyword, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 3, textAlign: TextAlign.center, overflow:TextOverflow.ellipsis,)),
          )
        ],
      ),
    );
  }
}
