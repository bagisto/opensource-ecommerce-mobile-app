abstract class DrawerSubCategoriesEvent{}

class FetchDrawerSubCategoryEvent extends DrawerSubCategoriesEvent {
  int? categoryId;

  FetchDrawerSubCategoryEvent(this.categoryId);
}