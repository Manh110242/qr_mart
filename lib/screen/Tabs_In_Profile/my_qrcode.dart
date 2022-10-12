import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcaeco_app/bloc/qr_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/toast.dart';
import 'package:image_downloader/image_downloader.dart';

/**
 * Created by trungduc.vnu@gmail.com.
 */
class MyQrcode extends StatefulWidget {
  @override
  _MyQrcodeState createState() => _MyQrcodeState();
}

class _MyQrcodeState extends State<MyQrcode> {
  var qr_bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qr_bloc = new QrBloc();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width - 30) / 2;

    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Config().colorMain,
          title: Text('Mã QrCode của tôi'),
        ),
        body: FutureBuilder(
          future: qr_bloc.getImageMyQr(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Widget> list = new List<Widget>();
              snapshot.data['response']['data'].forEach((k, v) {
                if (v != '') {
                  String title = '';
                  String us_id = '';
                  if (k == 'qr_senv') {
                    title = 'Mã QR chuyển V';
                  }
                  if (k == 'qr_service') {
                    title = 'Mã QR dịch vụ';
                  }
                  if (k == 'qr_gtshop') {
                    title = 'Mã QR giới thiệu';
                    us_id = snapshot.data['user_id'];
                  }
                  list.add(itemQr(title, v, us_id, itemWidth, itemHeight));
                }
              });
              return Container(
                margin: EdgeInsets.only(top: 15),
                child: GridView.count(
                    crossAxisCount: ((MediaQuery.of(context).size.width / 170) -
                                (MediaQuery.of(context).size.width / 170)
                                    .floor()) >
                            0.8
                        ? (MediaQuery.of(context).size.width / 170).round()
                        : (MediaQuery.of(context).size.width / 170).floor(),
                    childAspectRatio: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?  0.60 : 0.67,
                    padding: const EdgeInsets.all(4.0),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: list),
              );
            } else {
              return Center();
            }
          },
        ));
  }

  Widget itemQr(title, url, user_id, itemWidth, itemHeight) {
    return Column(
      children: [
        Image.network(
          url,
          height: itemWidth - 10,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(color: Colors.black, fontSize: 13.0),
          ),
        ),
        Text(
          user_id,
          style: TextStyle(color: Colors.red),
        ),
        Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 5, top: 5),
            child: InkWell(
              onTap: () {
                downloadImage(url);
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.orange),
                child: Text(
                  'Tải ảnh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )),
      ],
    );
  }

  downloadImage(url) async {
    try {
      var imageId = await ImageDownloader.downloadImage(url);
      showToast(
          "Tải ảnh thành công", context, Colors.green, Icons.check_circle);
    } catch (error) {
      showToast(
          "Tải ảnh thất bại", context, Colors.yellow, Icons.error_outline);
    }
  }
}
