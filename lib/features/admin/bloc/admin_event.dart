import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user details from Firebase
class LoadUserDetailsEvent extends AdminEvent {
  const LoadUserDetailsEvent();
}

/// Event to save user details to Firebase
class SaveUserDetailsEvent extends AdminEvent {
  final String name;
  final String mobileNumber;
  final String emailId;
  final String designation;

  const SaveUserDetailsEvent({
    required this.name,
    required this.mobileNumber,
    required this.emailId,
    required this.designation,
  });

  @override
  List<Object?> get props => [name, mobileNumber, emailId, designation];
}

/// Event to clear error message
class ClearErrorEvent extends AdminEvent {
  const ClearErrorEvent();
}

