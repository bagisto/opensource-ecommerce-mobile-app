import 'dart:async';

class RecentViewController {
  RecentViewController._();

  static StreamController<String?> controller = StreamController.broadcast();

  static final RecentViewController _instance = RecentViewController._();

  factory RecentViewController() {
    return _instance;
  }

  closeController(){
    controller.close();
  }
}
