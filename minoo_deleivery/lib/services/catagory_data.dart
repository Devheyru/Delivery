import 'package:minoo_deleivery/model/category_model.dart';

List<CatagoryModel> getCagories() {
  List<CatagoryModel> catagory = [];
  CatagoryModel catagoryModel = new CatagoryModel();
  catagoryModel.catagoryName = "Pizza";
  catagoryModel.imageUrl = "assets/images/pizza.png";
  catagory.add(catagoryModel);
  catagoryModel = new CatagoryModel();

  catagoryModel.catagoryName = "Burger";
  catagoryModel.imageUrl = "assets/images/burger.png";
  catagory.add(catagoryModel);
  catagoryModel = new CatagoryModel();

  catagoryModel.catagoryName = "Pizza";
  catagoryModel.imageUrl = "assets/images/pizza.png";
  catagory.add(catagoryModel);
  catagoryModel = new CatagoryModel();

  catagoryModel.catagoryName = "Chinese";
  catagoryModel.imageUrl = "assets/images/chinese.png";
  catagory.add(catagoryModel);
  catagoryModel = new CatagoryModel();

  catagoryModel.catagoryName = "Mexican";
  catagoryModel.imageUrl = "assets/images/mexican.png";
  catagory.add(catagoryModel);
  catagoryModel = new CatagoryModel();
  return catagory;
}
