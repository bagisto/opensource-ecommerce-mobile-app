abstract class DrawerEvent {}

class FetchDrawerPageEvent extends DrawerEvent {
  List<Map<String, dynamic>>? filters;
  FetchDrawerPageEvent(this.filters);

}
class CurrencyLanguageEvent extends DrawerEvent {}