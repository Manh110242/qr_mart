import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';

// ignore: camel_case_types
class Tab_Posts extends StatefulWidget {
  @override
  _Tab_Posts_State createState() => _Tab_Posts_State();
}

// ignore: camel_case_types
class _Tab_Posts_State extends State<Tab_Posts> {
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight / 3),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.insert_chart_outlined_outlined,
                          color: Config().colorMain, size: 35),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 6.5* MediaQuery.of(context).size.width / 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phân tích",
                                style:
                                TextStyle(color: Colors.black, fontSize: 18),
                              ),
                              Text(
                                "Xem những chỉ số liên quan đến những bài viết của bạn",
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 10, bottom: 10, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tin nổi bật",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Hiển thị tin yêu thích trên trang của bạn",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(60)),
                                border: Border.all(color: Colors.black)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Icon(Icons.add, size: 25,),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              height: 100,
                              child: ListView.builder(
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 7,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    // if (index == 0) {
                                    //   return

                                    // ;
                                    // }
                                    return Icon(
                                      Icons.circle,
                                      size: 85,
                                      color: Colors.grey.shade300,
                                    );
                                  }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child:
                Opacity(
                  opacity: 0.3,
                  child:
                  Column(
                    children: [
                      Image.asset(
                        "assets/images/logo-V.png", width: 100, height: 150,),
                      Text("Chưa có bài đăng nào")
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
