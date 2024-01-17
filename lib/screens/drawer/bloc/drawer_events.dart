abstract class DrawerEvent {}

class FetchDrawerPageEvent extends DrawerEvent {
  int? categoryId;
  FetchDrawerPageEvent(this.categoryId);

}
class CurrencyLanguageEvent extends DrawerEvent {}

class FetchCMSDataEvent extends DrawerEvent {}