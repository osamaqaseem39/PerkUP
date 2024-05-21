import 'package:equatable/equatable.dart';
import 'package:perkup_app/data/models/address/address_model.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<Address> addresses;

  const AddressLoaded({
      required this.addresses,
  });

  @override
  List<Object?> get props => [addresses];
}

class AddressAdded extends AddressState {
  final Address newAddress;

  const AddressAdded({
    required this.newAddress,
  });

  @override
  List<Object?> get props => [newAddress];
}

class AddressUpdated extends AddressState {
  final Address updatedAddress;

  const AddressUpdated({
    required this.updatedAddress,
  });

  @override
  List<Object?> get props => [updatedAddress];
}

class AddressDeleted extends AddressState {
  final int deletedAddressId;

  const AddressDeleted({
    required this.deletedAddressId,
  });

  @override
  List<Object?> get props => [deletedAddressId];
}

class AddressError extends AddressState {
  final String error;

  const AddressError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}