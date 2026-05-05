part of 'services_bloc.dart';

class ServicesState extends Equatable {
  final Set<String> selectedServices;
  final bool showForm;
  final bool isOthersSelected;
  final String otherServiceName;
  final String? otherServiceError;

  // ✅ ADD THESE
  final String? nameError;
  final String? projectError;

  final bool isSubmitting;
  final String? errorMessage;
  final bool requestSent;

  const ServicesState({
    this.selectedServices = const {},
    this.showForm = false,
    this.isOthersSelected = false,
    this.otherServiceName = '',
    this.otherServiceError,

    this.nameError,        // ✅ NEW
    this.projectError,     // ✅ NEW

    this.isSubmitting = false,
    this.errorMessage,
    this.requestSent = false,
  });

  ServicesState copyWith({
    Set<String>? selectedServices,
    bool? showForm,
    bool? isOthersSelected,
    String? otherServiceName,
    String? otherServiceError,

    String? nameError,        // ✅ NEW
    String? projectError,     // ✅ NEW

    bool? isSubmitting,
    String? errorMessage,
    bool? requestSent,
  }) {
    return ServicesState(
      selectedServices: selectedServices ?? this.selectedServices,
      showForm: showForm ?? this.showForm,
      isOthersSelected: isOthersSelected ?? this.isOthersSelected,
      otherServiceName: otherServiceName ?? this.otherServiceName,
      otherServiceError: otherServiceError ?? this.otherServiceError,

      nameError: nameError,
      projectError: projectError,

      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      requestSent: requestSent ?? this.requestSent,
    );
  }

  @override
  List<Object?> get props => [
    selectedServices,
    showForm,
    isOthersSelected,
    otherServiceName,
    otherServiceError,
    nameError,        // ✅ NEW
    projectError,     // ✅ NEW
    isSubmitting,
    errorMessage,
    requestSent,
  ];
}

