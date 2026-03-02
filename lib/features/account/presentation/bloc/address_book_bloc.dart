import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';
import '../../data/repository/account_repository.dart';

// ─── EVENTS ───

abstract class AddressBookEvent extends Equatable {
  const AddressBookEvent();

  @override
  List<Object?> get props => [];
}

/// Load all customer addresses (shows full-screen loading)
class LoadAddresses extends AddressBookEvent {
  const LoadAddresses();
}

/// Refresh addresses (pull-to-refresh — caller awaits completer)
class RefreshAddresses extends AddressBookEvent {
  final Completer<void>? completer;

  const RefreshAddresses({this.completer});

  @override
  List<Object?> get props => []; // completer is not part of equality
}

/// Set an address as default
class SetDefaultAddress extends AddressBookEvent {
  final int addressId;

  final String? firstName;
  final String? lastName;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postcode;
  final String? phone;
  final String? email;

  final bool useForShipping;

  const SetDefaultAddress({
    required this.addressId,
    this.useForShipping = false,

    this.firstName,
    this.lastName,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.phone,
    this.email,
  });

  @override
  List<Object?> get props => [
        addressId,
        firstName,
        lastName,
        address,
        city,
        state,
        country,
        postcode,
        phone,
        email,
        useForShipping,
      ];
}
/// Delete an address
class DeleteAddress extends AddressBookEvent {
  final String addressId;

  const DeleteAddress({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

/// Create a new address
class CreateAddress extends AddressBookEvent {
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final String phone;
  final String? email;
  final String? companyName;
  final String? vatId;
  final bool defaultAddress;
  final bool useForShipping;

  const CreateAddress({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.phone,
    this.email,
    this.companyName,
    this.vatId,
    this.defaultAddress = false,
    this.useForShipping = false,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    address,
    city,
    state,
    country,
    postcode,
    phone,
    email,
    companyName,
    vatId,
    defaultAddress,
    useForShipping,
  ];
}

/// Update an existing address
class UpdateAddress extends AddressBookEvent {
  final int addressId;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final String phone;
  final String? email;
  final String? companyName;
  final String? vatId;
  final bool defaultAddress;
  final bool useForShipping;

  const UpdateAddress({
    required this.addressId,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.phone,
    this.email,
    this.companyName,
    this.vatId,
    this.defaultAddress = false,
    this.useForShipping = false,
  });

  @override
  List<Object?> get props => [
    addressId,
    firstName,
    lastName,
    address,
    city,
    state,
    country,
    postcode,
    phone,
    email,
    companyName,
    vatId,
    defaultAddress,
    useForShipping,
  ];
}

// ─── STATES ───

enum AddressBookStatus { initial, loading, loaded, error }

class AddressBookState extends Equatable {
  final AddressBookStatus status;
  final List<CustomerAddress> addresses;
  final String? errorMessage;
  final String? actionMessage; // Success message for set-default/delete
  final bool isPerformingAction; // Loading indicator for mutations
  final bool addressCreated; // Flag: newly created address — pop form page
  final bool addressUpdated; // Flag: address was updated — pop form page

  const AddressBookState({
    this.status = AddressBookStatus.initial,
    this.addresses = const [],
    this.errorMessage,
    this.actionMessage,
    this.isPerformingAction = false,
    this.addressCreated = false,
    this.addressUpdated = false,
  });

  AddressBookState copyWith({
    AddressBookStatus? status,
    List<CustomerAddress>? addresses,
    String? errorMessage,
    String? actionMessage,
    bool? isPerformingAction,
    bool? addressCreated,
    bool? addressUpdated,
  }) {
    return AddressBookState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage,
      actionMessage: actionMessage,
      isPerformingAction: isPerformingAction ?? this.isPerformingAction,
      addressCreated: addressCreated ?? false,
      addressUpdated: addressUpdated ?? false,
    );
  }

  @override
  List<Object?> get props => [
    status,
    addresses,
    errorMessage,
    actionMessage,
    isPerformingAction,
    addressCreated,
    addressUpdated,
  ];
}

// ─── BLOC ───

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  final AccountRepository repository;

  AddressBookBloc({required this.repository})
    : super(const AddressBookState()) {
    on<LoadAddresses>(_onLoad);
    on<RefreshAddresses>(_onRefresh);
    on<SetDefaultAddress>(_onSetDefault);
    on<DeleteAddress>(_onDelete);
    on<CreateAddress>(_onCreate);
    on<UpdateAddress>(_onUpdate);
  }

  Future<void> _onLoad(
    LoadAddresses event,
    Emitter<AddressBookState> emit,
  ) async {
    emit(state.copyWith(status: AddressBookStatus.loading));
    await _fetchAddresses(emit);
  }

  Future<void> _onRefresh(
    RefreshAddresses event,
    Emitter<AddressBookState> emit,
  ) async {
    try {
      await _fetchAddresses(emit);
    } finally {
      // Complete the completer so RefreshIndicator stops spinning
      event.completer?.complete();
    }
  }

  Future<void> _fetchAddresses(Emitter<AddressBookState> emit) async {
    try {
      final addresses = await repository.getCustomerAddresses(first: 100);

      emit(
        state.copyWith(
          status: AddressBookStatus.loaded,
          addresses: addresses,
          errorMessage: null,
        ),
      );

      debugPrint('✅ AddressBook loaded — ${addresses.length} addresses');
    } catch (e) {
      debugPrint('❌ AddressBook load error: $e');
      emit(
        state.copyWith(
          status: AddressBookStatus.error,
          errorMessage: e is AccountException ? e.message : e.toString(),
        ),
      );
    }
  }

  Future<void> _onSetDefault(
    SetDefaultAddress event,
    Emitter<AddressBookState> emit,
  ) async {
    // Guard: ignore if another mutation is already in progress
    if (state.isPerformingAction) return;

    emit(state.copyWith(isPerformingAction: true, actionMessage: null));

    try {
      // Find the address in state if fields are null
      final address = state.addresses.firstWhere(
        (a) => a.numericId == event.addressId,
        orElse: () => throw Exception('Selected address not found in state'),
      );

      await repository.setDefaultAddress(
        addressId: event.addressId,
        useForShipping: event.useForShipping,
      );

      // Optimistic update using model's copyWith — future-proof
      final updatedAddresses = state.addresses
          .map((addr) => addr.copyWith(isDefault: addr.numericId == event.addressId))
          .toList();

      emit(
        state.copyWith(
          addresses: updatedAddresses,
          isPerformingAction: false,
          actionMessage: 'Address set as default',
        ),
      );

      debugPrint('✅ Set default address: ${event.addressId}');
    } catch (e) {
      debugPrint('❌ Set default error: $e');
      emit(
        state.copyWith(
          isPerformingAction: false,
          actionMessage: e is AccountException
              ? e.message
              : 'Failed to update address',
        ),
      );
    }
  }

  Future<void> _onDelete(
    DeleteAddress event,
    Emitter<AddressBookState> emit,
  ) async {
    // Guard: ignore if another mutation is already in progress
    if (state.isPerformingAction) return;

    emit(state.copyWith(isPerformingAction: true, actionMessage: null));

    try {
      await repository.deleteAddress(addressId: event.addressId);

      // Remove from local list
      final updatedAddresses = state.addresses
          .where((a) => a.id != event.addressId)
          .toList();

      emit(
        state.copyWith(
          addresses: updatedAddresses,
          isPerformingAction: false,
          actionMessage: 'Address deleted',
        ),
      );

      debugPrint('✅ Deleted address: ${event.addressId}');
    } catch (e) {
      debugPrint('❌ Delete address error: $e');
      emit(
        state.copyWith(
          isPerformingAction: false,
          actionMessage: e is AccountException
              ? e.message
              : 'Failed to delete address',
        ),
      );
    }
  }

  Future<void> _onCreate(
    CreateAddress event,
    Emitter<AddressBookState> emit,
  ) async {
    // Guard: ignore if another mutation is already in progress
    if (state.isPerformingAction) return;

    emit(state.copyWith(isPerformingAction: true, actionMessage: null));

    try {
      final newAddress = await repository.createAddress(
        firstName: event.firstName,
        lastName: event.lastName,
        address: event.address,
        city: event.city,
        state: event.state,
        country: event.country,
        postcode: event.postcode,
        phone: event.phone,
        email: event.email,
        companyName: event.companyName,
        vatId: event.vatId,
        defaultAddress: event.defaultAddress,
        useForShipping: event.useForShipping,
      );

      final updatedAddresses = [...state.addresses, newAddress];

      emit(
        state.copyWith(
          addresses: updatedAddresses,
          isPerformingAction: false,
          actionMessage: 'Address added successfully',
          addressCreated: true,
        ),
      );

      debugPrint('✅ Created address: ${newAddress.id}');
    } catch (e) {
      debugPrint('❌ Create address error: $e');
      emit(
        state.copyWith(
          isPerformingAction: false,
          actionMessage: e is AccountException
              ? e.message
              : 'Failed to add address',
        ),
      );
    }
  }

  Future<void> _onUpdate(
    UpdateAddress event,
    Emitter<AddressBookState> emit,
  ) async {
    // Guard: ignore if another mutation is already in progress
    if (state.isPerformingAction) return;

    emit(state.copyWith(isPerformingAction: true, actionMessage: null));

    try {
      final updatedAddress = await repository.updateAddress(
        addressId: event.addressId,
        firstName: event.firstName,
        lastName: event.lastName,
        address: event.address,
        city: event.city,
        state: event.state,
        country: event.country,
        postcode: event.postcode,
        phone: event.phone,
        email: event.email,
        companyName: event.companyName,
        vatId: event.vatId,
        defaultAddress: event.defaultAddress,
        useForShipping: event.useForShipping,
      );

      // Replace the old address in the local list
      final updatedAddresses = state.addresses.map((addr) {
        if (addr.numericId == event.addressId || addr.id == updatedAddress.id) {
          return updatedAddress;
        }
        return addr;
      }).toList();

      emit(
        state.copyWith(
          addresses: updatedAddresses,
          isPerformingAction: false,
          actionMessage: 'Address updated successfully',
          addressUpdated: true,
        ),
      );

      debugPrint('✅ Updated address: ${updatedAddress.id}');
    } catch (e) {
      debugPrint('❌ Update address error: $e');
      emit(
        state.copyWith(
          isPerformingAction: false,
          actionMessage: e is AccountException
              ? e.message
              : 'Failed to update address',
        ),
      );
    }
  }
}
