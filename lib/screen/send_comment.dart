import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gcaeco_app/bloc/product_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/screen/dialog/loading_dialog.dart';
import 'package:gcaeco_app/screen/dialog/msg_dialog.dart';
import 'package:gcaeco_app/screen/screen_login.dart';
import 'package:image_picker/image_picker.dart';

class SendComment extends StatefulWidget {
  String id ;
  SendComment({ this.id});
  @override
  _SendCommentState createState() => _SendCommentState();
}

class _SendCommentState extends State<SendComment> {
  TextEditingController comment = new TextEditingController();
  List imageFiles = [];
  bool checkAdd = false;
  StreamController imagesController = new StreamController();
  Stream get imageStream => imagesController.stream;
  ProductBloc bloc = new ProductBloc();
  double rate = 0;


  sendComment() async {
    FocusScope.of(context).unfocus();
    Const.web_api.checkLogin().then((value) async {
      if (value != '1') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Login_Screen()));
      } else {
        if(comment.text != "" && rate >0){
          LoadingDialog.showLoadingDialog(context, "Đang tải...");
          var res = await bloc.postComment(
              type: 1,
              rating: rate,
              object_id: widget.id,
              listImage: imageFiles,
              content: comment.text
          );
          LoadingDialog.hideLoadingDialog(context);
          if(res != null){
            if(res['success']){
              MsgDialog.showMsgUpdate(context, 'Đánh giá sản phẩm thành công', "Thành công",(){
                Navigator.pop(context);
                Navigator.pop(context, 1);
              });
            }else{
              MsgDialog.showMsgDialog(context, 'Lỗi dữ liệu', "Lỗi");
            }
          }else{
            MsgDialog.showMsgDialog(context, 'Lỗi kết nối', "Lỗi");
          }
        }else{
          MsgDialog.showMsgDialog(context, 'Bình luận và số sao đánh giá không được để trống', "Lỗi");
        }

      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text('Viết bình luận'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Vui lòng gửi phản hồi của bạn về sản phẩm cho chúng tôi được biết',
                style: TextStyle(
                    color: Color(0xff4F4F4F),
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              SizedBox(
                height: 15,
              ),
              RatingBar.builder(
                initialRating: rate,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 32,
                itemPadding: const EdgeInsets.only(right: 5),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                unratedColor: Colors.grey.shade300,
                onRatingUpdate: (newValue) {
                  rate = newValue;
                },
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Bình luận của bạn',
                style: TextStyle(
                    color: Color(0xff4F4F4F),
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: comment,
                maxLines: 6,
                decoration: InputDecoration(
                    hintText: 'Nhập đánh giá của bạn',
                    hintStyle: TextStyle(color: Color(0xffBDBDBD), fontSize: 14),
                    errorText: null,
                    errorMaxLines: 2,
                    errorStyle: TextStyle(color: Colors.red, fontSize: 12),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Config().colorMain, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE0E0E0), width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Config().colorMain, width: 1),
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Thêm ảnh/Video',
                style: TextStyle(
                    color: Color(0xff4F4F4F),
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: imageStream,
                initialData: imageFiles,
                builder: (context, snapshot) {
                  return buildImage();
                }
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: sendComment,
        child: Container(
          height: 50,
          width: double.infinity,
          color: Config().colorMain,
          alignment: Alignment.center,
          child: Text('Gửi', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white),),
        ),
      ),
    );
  }

  Widget buildImage() {
    Size size = MediaQuery.of(context).size;
    return GridView.count(
      crossAxisCount:(size.width / 100).round(),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: List.generate(
          imageFiles.length + 1,
              (index) => index == 0
              ? InkWell(
            onTap: (){
              ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
                if(value != null){
                  imageFiles.add(value);
                  imagesController.sink.add(imageFiles);
                }
              });
            },
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Color(0xffBDBDBD),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Color(0xffBDBDBD),
                ),
              ),
            ),
          )
              : Container(
            width: double.infinity,
            height: 100,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    child: Image.file(
                      imageFiles[index -1],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 100,
                    ),
                  ),
                ),
                Positioned(
                  top: 3,
                  right: 3,
                  child: InkWell(
                    onTap: () {
                      imageFiles.removeAt(index - 1);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
