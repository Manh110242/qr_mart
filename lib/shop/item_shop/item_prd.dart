import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:gcaeco_app/model/products/productItem.dart';
import 'package:gcaeco_app/screen/layouts/products/star_rating.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:gcaeco_app/shop/update_prd.dart';

class ItemPrd extends StatelessWidget {
 ProductItem  item;
 Function onTap;
 ItemPrd({this.item,this.onTap});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width - 30)/2;
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.avatar_path != '' && item.avatar_path != null ?
            Container(
                height: itemWidth -10,
                width: 50000,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  child: Image.network(
                      Const().image_host +
                          item.avatar_path + 's400_400/'+
                          item.avatar_name,
                      fit: BoxFit.cover),
                )) :
            Container(
                height: itemWidth -10,
                width: 50000,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  child: Image.asset('assets/images/no-image.png',
                      fit: BoxFit.cover),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
              child: SizedBox(
                height: (itemWidth/6),
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5),
              child: Text(
                Config().formatter.format(item.price) + 'đ',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StarRating(
                    rating: item.rate,
                    color: Colors.orange,
                  ),
                  item.in_wish ? InkWell(
                    onTap: (){
                      addWishlist(context,item.id);
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.orange,
                      size: 14,
                    ),
                  ) : InkWell(
                    onTap: (){
                      addWishlist(context,item.id);
                    },
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.black38,
                      size: 14,
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
 addWishlist(context,product_id) async {
   Const.web_api.checkLogin().then((value)async{
     if(value == ''){
       Navigator.push(context, MaterialPageRoute(
           builder: (context) => Login_Screen()
       ));
     }else{
       var user_id = await Const.web_api.getUserId();
       var token = await Const.web_api.getTokenUser();
       Map<String, dynamic> request_body = new Map<String, dynamic>();
       request_body['user_id'] = user_id;
       request_body['product_id'] = product_id;
       var response = await Const.web_api
           .postAsync("/app/user/wish-product", token, request_body);
       if(response != null){
         if (response['code'] == 1) {
           showToast(response['message'],
               context, Colors.green, Icons.check_circle);
         }else{
           showToast(response['error'],
               context, Colors.yellow, Icons.error);
         }
       }else{
         showToast("Kết nối server thất bại",
             context, Colors.yellow, Icons.error);
       }
     }
   });
 }
}
