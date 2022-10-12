import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';

import '../main.dart';
import 'upload_avatar_shop.dart';

class Transport extends StatefulWidget {
  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  bool check1 = false;
  bool check2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Vận chuyển"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text("Hãy chọn ít nhất 1 đơn vị vận chuyển",
                  style: TextStyle(
                    color: Color(0xffdbbf6d),
                    fontSize: 17,
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Với việc chọn đơn vị vận chuyển, người mua hàng sẽ được thông báo thông tin theo dõi đơn hàng qua $appName",
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  )),
              SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.justify,
                maxLines: 5,
                text: TextSpan(
                  text: 'Gợi ý: ',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                  children: const <TextSpan>[
                    TextSpan(
                        text: "Nhấn vào nút ở dưới cột trạng thái "
                            "để kích hoạt những dịch vụ chuyển "
                            "mà bạn sẽ sử dụng cho tất cả sản phẩm. "
                            "Cột mặc định để chọn hình thức mặc định"
                            " cho những đơn hàng. ",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        )),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Text(
                        "Dịch vụ vận chuyển",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Trạng thái",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Mặc định",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Text(
                        "Giao hàng thủ công",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Switch(
                              value: check1,
                              activeColor: Config().colorMain,
                              onChanged: (value) {
                                setState(() {
                                  check1 = !check1;
                                });
                              }),
                          Switch(
                              value: check2,
                              activeColor: Config().colorMain,
                              onChanged: (value) {
                                setState(() {
                                  check2 = !check2;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadAvatarShop()));
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffdbbf6d)),
                        child: Center(
                            child: Text(
                          'Tìm hiểu thêm',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffdbbf6d)),
                        child: Center(
                            child: Text(
                          'Bỏ qua',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
