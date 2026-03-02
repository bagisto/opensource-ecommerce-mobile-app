import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// State for the Settings bottom sheet.
/// Manages notification toggles, offline data toggles, and theme mode.
///
/// Figma node-id: 248-8062 (pop-over-settings-light)
class SettingsState extends Equatable {
  final bool allNotifications;
  final bool ordersNotification;
  final bool offersNotification;
  final bool trackRecentlyViewed;
  final bool showSearchTag;

  const SettingsState({
    this.allNotifications = true,
    this.ordersNotification = false,
    this.offersNotification = false,
    this.trackRecentlyViewed = false,
    this.showSearchTag = false,
  });

  SettingsState copyWith({
    bool? allNotifications,
    bool? ordersNotification,
    bool? offersNotification,
    bool? trackRecentlyViewed,
    bool? showSearchTag,
  }) {
    return SettingsState(
      allNotifications: allNotifications ?? this.allNotifications,
      ordersNotification: ordersNotification ?? this.ordersNotification,
      offersNotification: offersNotification ?? this.offersNotification,
      trackRecentlyViewed: trackRecentlyViewed ?? this.trackRecentlyViewed,
      showSearchTag: showSearchTag ?? this.showSearchTag,
    );
  }

  @override
  List<Object?> get props => [
    allNotifications,
    ordersNotification,
    offersNotification,
    trackRecentlyViewed,
    showSearchTag,
  ];
}

/// Cubit to manage Settings page state.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleAllNotifications(bool value) {
    if (value) {
      // When "All Notifications" is turned on, enable all sub-toggles
      emit(
        state.copyWith(
          allNotifications: true,
          ordersNotification: true,
          offersNotification: true,
        ),
      );
    } else {
      // When "All Notifications" is turned off, disable all sub-toggles
      emit(
        state.copyWith(
          allNotifications: false,
          ordersNotification: false,
          offersNotification: false,
        ),
      );
    }
  }

  void toggleOrdersNotification(bool value) {
    final newState = state.copyWith(ordersNotification: value);
    // If both sub-toggles are on, auto-enable "All Notifications"
    // If any sub-toggle is off, disable "All Notifications"
    final allOn = newState.ordersNotification && newState.offersNotification;
    emit(newState.copyWith(allNotifications: allOn));
  }

  void toggleOffersNotification(bool value) {
    final newState = state.copyWith(offersNotification: value);
    final allOn = newState.ordersNotification && newState.offersNotification;
    emit(newState.copyWith(allNotifications: allOn));
  }

  void toggleTrackRecentlyViewed(bool value) {
    emit(state.copyWith(trackRecentlyViewed: value));
  }

  void toggleShowSearchTag(bool value) {
    emit(state.copyWith(showSearchTag: value));
  }
}
