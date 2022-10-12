import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/addressItem.dart';
import 'package:gcaeco_app/shop/address_shop.dart';
import 'package:gcaeco_app/shop/update_shop.dart';

class ItemAddress extends StatelessWidget {
  AddressItem item ;
  Function update;
  Function delete;
  Function isdefault;
  ItemAddress({this.item, this.update, this.delete,this.isdefault});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              flex: 4,
              child: Text("Họ và tên: ",style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),),
            ),
            Flexible(
              flex: 5,
              child: Text(item.name_contact,overflow: TextOverflow.ellipsis, style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              )),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Row(
          children: [
            Flexible(
              flex: 4,
              child: Text("Điện thoại: ",style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),),
            ),
            Flexible(
              flex: 5,
              child: Text(item.phone,overflow: TextOverflow.ellipsis, style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              )),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: Text("Địa chỉ: ",style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),),
            ),
            Flexible(
              flex: 9,
              child: Text(item.address+ ", " + item.ward_name+ ", " + item.district_name + ", "+item.province_name,overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              )),
            ),
          ],
        ),
        SizedBox(height: 10,),
        item.isdefault != null && item.isdefault == "1"? Row(
          children: [
            InkWell(
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:  Config().colorMain
                ),
                child: Center(child: Text('Mặc định', style: TextStyle(color: Colors.white, fontSize: 17),)),
              ),
            ),
            SizedBox(width: 20,),
            Icon(Icons.check, color: Config().colorMain, size: 25,),
            Text("Địa chỉ gửi đến", style: TextStyle(color:Config().colorMain, fontSize: 17),)
          ],
        ) : Center(),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: delete,
              child: Row(
                children: [
                  Icon(Icons.close),
                  Text("Xóa", style: TextStyle(color: Colors.grey, fontSize: 17),)
                ],
              ),
            ),
            SizedBox(width: 10,),
            InkWell(
              onTap:update,
              child: Row(
                children: [
                  Icon(Icons.edit),
                  Text("Cập nhật", style: TextStyle(color: Colors.grey, fontSize: 17),)
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10,),
        item.isdefault != null && item.isdefault == "1"?Center():Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: isdefault,
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color:  Config().colorMain, width: 1)
                ),
                child: Center(child: Text('Chọn làm mặc định', style: TextStyle(color: Colors.black, fontSize: 17),)),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Divider()
      ],
    );
  }
}
