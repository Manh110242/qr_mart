import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/shop_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:image_picker/image_picker.dart';

class UploadAvatarShop extends StatefulWidget {
  @override
  _UploadAvatarShopState createState() => _UploadAvatarShopState();
}

class _UploadAvatarShopState extends State<UploadAvatarShop> {
  ShopBloc _bloc = new ShopBloc();
  Future<File> file;
  List imgs = [];
  List images = [];
  bool addimg = true;
  bool addimg1 = true;
  List iddel = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Ảnh doanh nghiệp"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.justify,
                maxLines: 5,
                text: TextSpan(
                  text: 'Gợi ý: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                  children: const <TextSpan>[
                    TextSpan(
                        text: "Thêm ảnh để khách đến thăm doanh nghiệp có thêm hình ảnh trực quan về doanh nghiệp của bạn. Ngoài ra, Bạn cũng có thể chỉ sửa ảnh bìa và ảnh đại diện phần bên tiêu đề.",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () {
                   if((imgs.length + images.length) > 20){
                     showToastErr("Tối đa 20 ảnh cho 1 shop", context, Colors.red, Icons.error_outline);
                   }else{
                     addimg = true;
                     file = ImagePicker.pickImage(
                         source: ImageSource.gallery);
                   }
                  setState(() {});
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Config().colorMain
                  ),
                  child: Center(child: Text('Thêm ảnh', style: TextStyle(color: Colors.white, fontSize: 17),)),
                ),
              ),
              SizedBox(height: 10,),
              FutureBuilder(
                future: _bloc.getImageShop(),
                builder: (_,snapshot){
                  if(snapshot.hasData){
                    if(addimg1){
                      images = [];
                      images.addAll(snapshot.data);
                    }
                    return showAvt(images);
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only( top: 10, bottom: 10),
                child: InkWell(
                  onTap: () async {
                      var res = await _bloc.upLoadAvatar(imgs,iddel);
                      if(res != null){
                        if(res['code'] == 1){
                          imgs= [];
                          images = [];
                          addimg1 = true;
                          addimg = false;
                          showToastDone("Cập nhật ảnh shop thành công", context, Colors.red, Icons.check);
                       setState(() {});
                        }else{
                          showToastErr(res['error'], context, Colors.red, Icons.error_outline);
                        }
                      }else{
                        showToastErr("Lỗi kết nối", context, Colors.red, Icons.error_outline);
                      }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  Config().colorMain
                    ),
                    child: Center(child: Text('Lưu', style: TextStyle(color: Colors.white, fontSize: 17),)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showAvt(List images) {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          if(imgs.length > 0){
            if(imgs[imgs.length - 1] != snapshot.data && addimg){
              imgs.add(snapshot.data);
            }
          }else if(addimg){
            imgs.add(snapshot.data);
          }
          if(images.length >0 && imgs.length>0){
            return avatarSuccess(imgs,images);
          }else if(images.length >0 && imgs.length == 0){
            return avatarSuccess(imgs,images);
          }else if(images.length == 0 && imgs.length > 0){
            return avatarSuccess(imgs,images);
          }else{
            return avatarSuccess(imgs,images);
          }

        } else  if(images.length>0){
          return avatarSuccess(imgs,images);
        }else{
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey,width: 1)
            ),
          );
        }
      },
    );
  }
  Widget avatarSuccess(List imgs, List images) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey,width: 1)
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.8,
        children: List.generate(images.length + imgs.length, (index) =>Container(
          color: Colors.grey.shade100,
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
             images.length > 0 && index <= (images.length-1) ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          Const().image_host + images[index].path + images[index].name,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: (){
                          showMsgDialog1(context, "Bạn có muốn xóa ảnh này không", index);
                        },
                        child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black.withOpacity(0.8),
                            child: Icon(Icons.close, color: Colors.white)
                        ),
                      )
                  )
                ],
              ):Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          imgs[index - images.length],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: (){
                          showMsgDialog(context, "Bạn có muốn xóa ảnh này không", index);
                        },
                        child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black.withOpacity(0.8),
                            child: Icon(Icons.close, color: Colors.white)
                        ),
                      )
                  )
                ],
              ),

            ],
          ),
        )),
      ),
    );
  }
  showMsgDialog(
      BuildContext context, String title,  index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Xóa'),
              onPressed: () {
                imgs.removeAt(index);
                setState(() {
                  addimg = false;
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  showMsgDialog1(
      BuildContext context, String title,  index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Xóa'),
              onPressed: () {
                iddel.add(images[index].id);
                images.removeAt(index);
                setState(() {
                  addimg1 = false;
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
