import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/products/CategoryItem.dart';
import 'package:gcaeco_app/screen/category_screen.dart';

class displayCategoryItem extends StatelessWidget {
  CategoryItem categoryItem;
  displayCategoryItem(this.categoryItem);

  @override
  Widget build(BuildContext context) {
    bool icon_url = true;
    bool avatar_url = true;
    if(categoryItem.icon_path == null){
      icon_url = false;
    }
    if(categoryItem.bgr_path == null){
      avatar_url = false;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => Category_screen(
              category_id: categoryItem.id,
              title: categoryItem.name,
              banner: avatar_url ? Const().image_host +
                  categoryItem.bgr_path+
                  categoryItem.bgr_name : '',
              limit: 12,
            )));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
          children: [
            icon_url ?
            Image.network(
              Const().image_host +
                  categoryItem.icon_path +
                  categoryItem.icon_name,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ): Image.asset('assets/images/no-image.png',width: 40,
                height: 40),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(categoryItem.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}
