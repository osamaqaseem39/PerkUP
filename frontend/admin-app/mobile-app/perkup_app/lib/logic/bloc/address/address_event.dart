import 'package:equatable/equatable.dart';
import 'package:perkup_app/data/models/address/address_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final Address address;

  const AddAddressEvent({
    required this.address,
  });

  @override
  List<Object?> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final Address address;

  const UpdateAddressEvent({
    required this.address,
  });

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final int addressId;

  const DeleteAddressEvent({
    required this.addressId,
  });

  @override
  List<Object?> get props => [addressId];
}