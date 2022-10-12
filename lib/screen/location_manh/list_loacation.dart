import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_location_mah.dart';
import 'package:gcaeco_app/bloc/user_bloc.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/model/locaiton_manh.dart';

class ListLocation extends StatefulWidget {
  String title, idTinh, idQuan, index;

  ListLocation({this.title, this.idTinh, this.idQuan, this.index});

  @override
  _ListLocationState createState() => _ListLocationState();
}

class _ListLocationState extends State<ListLocation> {
  var bloc;
  var bloc2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = LocationBloc();
    bloc2 = UserBloc();
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
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: (widget.idTinh == '' &&
                widget.idQuan == '' &&
                widget.index == "")
            ? bloc.loacationBlocManh()
            : (widget.idTinh != '' && widget.idQuan == '' && widget.index == "")
                ? bloc.locationQuan(widget.idTinh)
                : (widget.idTinh == '' &&
                        widget.idQuan == '' &&
                        widget.index != null && widget.index != "")
                    ? bloc2.getGroups()
                    : bloc.locationPhuong(widget.idQuan),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  LocationManh loca = snapshot.data[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, loca);
                      },
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: Text(loca.name.toString())),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
