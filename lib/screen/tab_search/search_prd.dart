import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/layouts/grid_view_custom.dart';
import 'package:gcaeco_app/screen/layouts/products/item_product_grid.dart';

class SearchPrd extends StatefulWidget {
  @override
  _SearchPrdState createState() => _SearchPrdState();
}

class _SearchPrdState extends State<SearchPrd> {
  ProductBloc bloc = new ProductBloc();
  TextEditingController _textController = TextEditingController();
  int page = 1;
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getProduct(_textController.text, page, false);
    _scrollController.addListener(() {
      _scrollListener();
    });
  }

  _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page++;
      isLoading = true;
      setState(() {});
      await bloc.getProduct(_textController.text, page, false);
      isLoading = false;
      setState(() {});
    }
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
                await bloc.getProduct(_textController.text, page, true);
                LoadingDialog.hideLoadingDialog(context);
              },
              decoration: InputDecoration(
                  hintText: 'Bạn đang muốn tìm...',
                  contentPadding: EdgeInsets.all(11),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  )),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(70),
      ),
      body: StreamBuilder(
        stream: bloc.allProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return GridViewCustom(
                itemCount: snapshot.data.length,
                maxWight: 180,
                mainAxisExtent: 300,
                showFull: true,
                padding: EdgeInsets.all(10),
                controller: _scrollController,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemBuilder: (context, index) =>
                    (index == snapshot.data.length - 1 && isLoading)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ItemProductGrid(snapshot.data[index]),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text("Không có sản phẩm nào được tìm thấy"),
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
}
