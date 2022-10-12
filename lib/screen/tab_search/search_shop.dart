import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/configs/db_keys.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/shop_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchShop extends StatefulWidget {

  @override
  _SearchShopState createState() => _SearchShopState();
}

class _SearchShopState extends State<SearchShop> {
  ShopBloc shopBloc = new ShopBloc();
  int page = 1;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopBloc.searchShop(_textController.text, page, false);
    _scrollController.addListener(() {_scrollListener();});
  }
  _scrollListener() async {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page++;
      isLoading = true;
      setState(() {});
      await shopBloc.searchShop(_textController.text, page, false);
      isLoading = false;
      setState(() {});
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    shopBloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: TextField(
              textInputAction: TextInputAction.search,
              controller: _textController,
              onSubmitted: (value) async {
                page = 1;
                LoadingDialog.showLoadingDialog(context, "Đang tải...");
                await shopBloc.searchShop(_textController.text, page, true);
                LoadingDialog.hideLoadingDialog(context);
              },
              decoration: InputDecoration(
                  hintText: 'Bạn đang muốn tìm...',
                  contentPadding: EdgeInsets.all(11),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  )
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(70),
      ),
      body: StreamBuilder(
        stream: shopBloc.searchshopStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return (index == snapshot.data.length - 1 && isLoading)
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : itemShop(snapshot.data[index]);
                  });
            } else {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text("Không có doanh nghiệp nào được tìm thấy"),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  Widget itemShop(data) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs =
            await SharedPreferences
            .getInstance();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopDetail(
          shop_id:
          data
              .id,
          currentUserNo:
          prefs
              .getString(
            Dbkeys.phone,
          ),
          shopNo: data.phoneUser,
        )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                    width: 64,
                    height: 64,
                    child: Image.network(
                      Const().image_host + data.avatar_path + data.avatar_name,
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: double.parse(data.rate != null ? data.rate : 0),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20,
                          direction: Axis.horizontal,
                        ),
                        Text("(${data.rate_count})",
                            style: TextStyle(
                              color: Colors.grey,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        ),
                        Flexible(
                            flex: 9,
                            child: Text(
                              data.address,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
