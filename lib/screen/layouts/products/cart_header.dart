import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/model/cartItem.dart';
import 'package:provider/provider.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */

class CartHeader extends StatelessWidget {
  var product_bloc = new ProductBloc();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartItem>(
      builder:(_,model,child)=> model.count > 0 ? Container(
        // color: Colors.orange,
        padding: EdgeInsets.only(left: 4, right: 4),
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          model.count.toString(),
          style: TextStyle(
              fontSize: 12, color: Colors.white),
        ),
      ) : SizedBox(),
    );
  }
}