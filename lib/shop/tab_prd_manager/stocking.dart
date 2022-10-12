import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';
import 'package:gcaeco_app/shop/add_prd.dart';
import 'package:gcaeco_app/shop/item_shop/item_prd.dart';
import 'package:gcaeco_app/shop/update_prd.dart';

class Stocking extends StatefulWidget {
  @override
  _StockingState createState() => _StockingState();
}

class _StockingState extends State<Stocking> {
  ShopBloc _bloc = ShopBloc();
  TextEditingController  search = new TextEditingController();
  int page = 1;
  ScrollController sc = new ScrollController();
  bool load ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sc.addListener(() async {
      if(sc.position.pixels == sc.position.maxScrollExtent){
        setState(() {load = true;});
        page = page ++;
        await  _bloc.getPrdShop(1,search.text,search.text != null ? true : false, page);
        setState(() {load = false;});
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
   _bloc.getPrdShop(1,search.text,search.text != null ? true : false, page);
    Size size =  MediaQuery.of(context).size;
    return  StreamBuilder(
        stream: _bloc.allPrdShop,
        builder: (_,snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width*0.75,
                          height: 50,
                          child: TextField(
                            controller: search,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Tìm Kiếm ..",
                              contentPadding: EdgeInsets.only(top: 5, right: 10, left: 10),
                              errorText: null,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffc4a95a)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff8f8b21), width: 3),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xffc4a95a))),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Config().colorMain,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: IconButton(icon: Icon(Icons.search, color: Colors.white,),onPressed: () async {
                            await  _bloc.getPrdShop(1,search.text,search.text != null ? true : false, page);
                          },),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    GridView.count(
                        controller: sc,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?  0.60 : 0.67,
                        crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
                        primary: false,
                        children: List.generate(
                          snapshot.data.length,
                              (index) {
                            return index == (snapshot.data.length - 1) && load == true ? Center(child: CircularProgressIndicator(),): ItemPrd(
                              item: snapshot.data[index],
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      color: Colors.white,
                                      height: 100,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: ()async {
                                                Navigator.pop(context);
                                                var res = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                            UpdatePrd(
                                                              item: snapshot
                                                                  .data[index],
                                                            )));
                                                if(res!= null){
                                                  setState(() {});
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                EdgeInsets.all(10),
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Colors.white,
                                                child: Text(
                                                    "Cập nhật sản phẩm"),
                                              ),
                                            ),
                                            Divider(),
                                            InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                MsgDialog.showDeleteProduc(context, "Bạn có chắc chắn muốn xóa sản phẩm này", "Xóa sản phẩm", snapshot.data[index].id,xoa);
                                              },
                                              child: Container(
                                                padding:
                                                EdgeInsets.all(10),
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Colors.white,
                                                child:
                                                Text("Xóa sản phẩm"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        )),
                  ],
                ),
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        });
  }
  xoa(){
    setState(() {});
  }
}
