import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_new.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/model_news.dart';
import 'package:gcaeco_app/screen/layouts/layout_notification/notification_item.dart';
import 'package:intl/intl.dart';

class ScreenNews extends StatefulWidget {
  String category_id;
  ScreenNews({this.category_id});
  @override
  _ScreenNewsState createState() => _ScreenNewsState();
}

class _ScreenNewsState extends State<ScreenNews> {
  BlocNew bloc = new BlocNew();
  int page = 1;

  ScrollController controller = ScrollController();

  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getNew(page, widget.category_id);
    controller.addListener(() async {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        load = true;
        setState(() {});
        page++;
        await bloc.getNew(page, widget.category_id);
        load = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        centerTitle: true,
        title: Text("Tin tức - Sự kiện"),
      ),
      body: StreamBuilder(
        stream: bloc.newStream,
        builder: (_, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final list = snapshot.data as List<ModelNews>;
          return list.isEmpty
              ? Center(
                  child: Text("Danh sách trống"),
                )
              : SingleChildScrollView(
                  controller: controller,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          list.length,
                          (index) => ItemNews(list[index]),
                        ),
                      ),
                      load
                          ? Container(
                              height: 100,
                              alignment: Alignment.topCenter,
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: 100,
                              width: double.infinity,
                            ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  ItemNews(ModelNews model) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationItem(
                      title: model.title,
                      noidung: model.description,
                    )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildImage(Const().image_host +
              model.avatarPath.toString() +
              model.avatarName.toString()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  model.title ?? "",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy', 'en_US').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(model.createdAt) * 1000)),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                    Text(
                      "  |  Tác giả: ${model.author}",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String url) {
    return Image.network(
      url,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 180,
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 70,
              color: Colors.grey,
            ),
          ),
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          height: 180,
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: Platform.isIOS
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}
