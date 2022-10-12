import 'package:flutter/material.dart';
import 'package:gcaeco_app/bloc/bloc_new.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:gcaeco_app/helper/const.dart';
import 'package:gcaeco_app/model/model_category_new.dart';
import 'package:gcaeco_app/screen/Home_Fragments/screen_news.dart';

class ScreenFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config().colorMain,
        title: Text("Tin tức - Sự kiện"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: BlocNew().getCategoryNew(),
          builder: (_, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            final list = snapshot.data as List<ModelCategoryNew>;
            return GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              crossAxisCount: 2,
              childAspectRatio: 2,
              children: List.generate(
                  list.length, (index) => _itemNew(context, list[index])),
            );
          }),
    );
  }

  _itemNew(BuildContext context, ModelCategoryNew model) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenNews(
                category_id: model.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              model.icon == null
                  ? Icon(
                      Icons.category,
                      size: 30,
                      color: Config().colorMain,
                    )
                  : Image.network(
                      model.icon.toString(),
                      width: 40,
                      height: 40,
                    ),
              Text(
                model.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
