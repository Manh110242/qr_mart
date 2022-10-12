import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_home_new.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/flash_sale.dart';

import 'layouts/CountdownTimer.dart';
import 'layouts/products/item_product_grid.dart';

class ScreenFlashSale extends StatefulWidget {
  ModelFlashSale item;

  ScreenFlashSale(this.item);

  @override
  _ScreenFlashSaleState createState() => _ScreenFlashSaleState();
}

class _ScreenFlashSaleState extends State<ScreenFlashSale> {
  BlocHomeNew bloc = BlocHomeNew();
  int page = 1;
  ScrollController controller = new ScrollController();
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getFlashSale(page);
    controller.addListener(() {
      loading();
    });
  }

  loading() async {
    if(controller.position.pixels == controller.position.maxScrollExtent){
      setState(() {
        load = true;
      });
      page++;
      await bloc.getFlashSale(page);
      setState(() {
        load = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Flash Sale",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: StreamBuilder(
        stream: bloc.flashStream,
        builder: (_, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                SizedBox(height:  10,),
                Image.asset("assets/images/flas.png"),
                SizedBox(height:  10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time,color: Color(0xffaeb127), size: 20,),
                    SizedBox(width:  5,),
                    Text("Kết thúc sau : ".toUpperCase(), style: TextStyle(fontSize: 15, color: Color(0xffaeb127)),),
                    CountdownTimerItem(widget.item.enddate, 17),
                  ],
                ),
                GridView.count(
                  crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  childAspectRatio: 0.64,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: List.generate(
                    snap.data.length,
                        (index) => ItemProductGrid(snap.data[index], check: false,),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: load ? CircularProgressIndicator() : Container(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
