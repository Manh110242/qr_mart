import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/rate_model.dart';
import 'package:gcaeco_app/model/shop.dart';
import 'package:gcaeco_app/screen/send_comment.dart';

// ignore: camel_case_types
class Tab_Evaluate_Product extends StatefulWidget {
  String producId;

  Tab_Evaluate_Product({this.producId});

  @override
  _Tab_Evaluate_Product_State createState() => _Tab_Evaluate_Product_State();
}

// ignore: camel_case_types
class _Tab_Evaluate_Product_State extends State<Tab_Evaluate_Product> {
  double rate = 4.0;
  int itemCount = 5;
  Shop shopRate;

  ProductBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new ProductBloc();
    getRatings();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  getRatings() async {
    var rate = await bloc.getRate(widget.producId);
    setState(() {
      shopRate = rate['shop'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: RatingTab(),
      ),
    );
  }

  Widget RatingTab() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendComment(
                        id: widget.producId,
                      )));
              if (res != null) {
                await getRatings();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'ĐÁNH GIÁ SẢN PHẨM',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )),
                shopRate != null
                    ? Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: shopRate.rate != "null"
                          ? Row(
                        children: [
                          Ratting(double.parse(shopRate.rate)),
                          Text(
                            " ${shopRate.rate} | ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(" ${shopRate.rate_count} đánh giá",
                              style: TextStyle(fontSize: 15)),
                        ],
                      )
                          : Row(
                        children: [
                          Ratting(0),
                          Text(
                            " 0 | ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(" 0 đánh giá",
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    )
                    : Container(),
              ],
            ),
          ),
          Divider(),
          ListRate(),
        ],
      ),
    );
  }

  Widget ListRate() {
    return StreamBuilder(
        stream: bloc.rating,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data['ratings'].length,
                itemBuilder: (context, index) {
                  RateModel rate = snapshot.data['ratings'][index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                              Border.all(color: Colors.grey, width: 0.5),
                              image: DecorationImage(
                                  image: NetworkImage(Const().image_host +
                                      rate.avatar_path +
                                      rate.avatar_name),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Flexible(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                      flex: 5,
                                      child: Text(
                                        rate.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      flex: 4,
                                      child:
                                      Ratting(double.parse(rate.rating))),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                rate.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              rate.images != null && rate.images.length > 0 ?GridView.count(
                                crossAxisCount: ((MediaQuery.of(context)
                                    .size
                                    .width /
                                    70) -
                                    (MediaQuery.of(context).size.width /
                                        70)
                                        .floor()) >
                                    0.8
                                    ? (MediaQuery.of(context).size.width / 70)
                                    .round()
                                    : (MediaQuery.of(context).size.width / 70)
                                    .floor(),
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                childAspectRatio: 1,
                                children: List.generate(rate.images.length, (index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(Const().image_host +rate.images[index]['path'] + rate.images[index]['name'] , fit: BoxFit.cover,),
                                )),
                              ) : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget Ratting(double rate) {
    return  RatingBarIndicator(
      rating: rate,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 15,
      direction: Axis.horizontal,
    );
  }
}
