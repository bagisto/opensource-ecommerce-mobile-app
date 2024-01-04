import '../data_model/get_categories_drawer_data_model.dart';

///class used to pass data on subcategories screen
class DrawerSubCategories {
  DrawerSubCategories({this.category, this.title});

  String? title;
  HomeCategories? category;
}

class PassProductData {
  PassProductData({this.title, this.productId, this.urlKey});

  String? urlKey;
  int? productId;
  String? title;
}