import 'package:equatable/equatable.dart';

class AdminState extends Equatable {
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String name;
  final String mobileNumber;
  final String emailId;
  final String designation;
  final bool isSuccess;

  const AdminState({
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.name = '',
    this.mobileNumber = '',
    this.emailId = '',
    this.designation = '',
    this.isSuccess = false,
  });

  AdminState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? name,
    String? mobileNumber,
    String? emailId,
    String? designation,
    bool? isSuccess,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      designation: designation ?? this.designation,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaving,
        errorMessage,
        name,
        mobileNumber,
        emailId,
        designation,
        isSuccess,
      ];
}

