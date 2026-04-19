
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(const ServicesState()) {
    on<ToggleServiceEvent>(_onToggleService);
    on<ProceedToFormEvent>(_onProceedToForm);
    on<BackToServicesEvent>(_onBackToServices);
    on<UpdateOtherServiceEvent>(_onUpdateOtherService);
    on<SendRequestViaEmailEvent>(_onSendEmailRequest);
    on<SendRequestViaWhatsAppEvent>(_onSendWhatsAppRequest);
    on<ResetFormEvent>(_onResetForm);
  }

  Future<void> _onToggleService(
    ToggleServiceEvent event,
    Emitter<ServicesState> emit,
  ) async {
    final services = Set<String>.from(state.selectedServices);
    bool isOthersSelected = state.isOthersSelected;

    if (event.service == 'Others') {
      isOthersSelected = !isOthersSelected;
      if (!isOthersSelected) {
        services.remove(event.service);
      } else {
        services.add(event.service);
      }
    } else {
      if (services.contains(event.service)) {
        services.remove(event.service);
      } else {
        services.add(event.service);
      }
    }

    emit(state.copyWith(
      selectedServices: services,
      isOthersSelected: isOthersSelected,
      otherServiceError: null,
    ));
  }

  Future<void> _onProceedToForm(
    ProceedToFormEvent event,
    Emitter<ServicesState> emit,
  ) async {
    if (state.selectedServices.isNotEmpty) {
      emit(state.copyWith(showForm: true));
    }
  }

  Future<void> _onBackToServices(
    BackToServicesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(state.copyWith(showForm: false));
  }

  Future<void> _onUpdateOtherService(
    UpdateOtherServiceEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(state.copyWith(otherServiceName: event.value));
  }

  Future<void> _onSendEmailRequest(
    SendRequestViaEmailEvent event,
    Emitter<ServicesState> emit,
  ) async {
    if (event.name.isEmpty || event.project.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Name and Project Description are required',
      ));
      return;
    }

    if (state.isOthersSelected && state.otherServiceName.isEmpty) {
      emit(state.copyWith(
        otherServiceError: 'Please enter custom service name',
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final services = _buildFinalServicesList();
      final servicesText = services.join(', ');
      final subject = 'Service Request from ${event.name}';
      final body = _buildEmailBody(
        name: event.name,
        project: event.project,
        costing: event.costing.isEmpty ? 'NA' : event.costing,
        deadline: event.deadline.isEmpty ? 'NA' : event.deadline,
        services: servicesText,
      );

      final emailUri = Uri(
        scheme: 'mailto',
        path: 'abhishekdeshpande.dev@gmail.com',
        queryParameters: {'subject': subject, 'body': body},
      );

      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      emit(state.copyWith(
        isSubmitting: false,
        requestSent: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to send request: $e',
      ));
    }
  }

  Future<void> _onSendWhatsAppRequest(
    SendRequestViaWhatsAppEvent event,
    Emitter<ServicesState> emit,
  ) async {
    if (event.name.isEmpty || event.project.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Name and Project Description are required',
      ));
      return;
    }

    if (state.isOthersSelected && state.otherServiceName.isEmpty) {
      emit(state.copyWith(
        otherServiceError: 'Please enter custom service name',
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final services = _buildFinalServicesList();
      final servicesText = services.join(', ');
      final message = _buildWhatsAppMessage(
        name: event.name,
        project: event.project,
        costing: event.costing.isEmpty ? 'NA' : event.costing,
        deadline: event.deadline.isEmpty ? 'NA' : event.deadline,
        services: servicesText,
      );

      String phoneNumber = event.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91$phoneNumber';
      }

      final whatsappUri = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
      );

      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      emit(state.copyWith(
        isSubmitting: false,
        requestSent: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to send request: $e',
      ));
    }
  }

  Future<void> _onResetForm(
    ResetFormEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(const ServicesState());
  }

  List<String> _buildFinalServicesList() {
    List<String> finalServicesList = List.from(state.selectedServices);
    if (state.isOthersSelected) {
      finalServicesList.remove('Others');
      if (state.otherServiceName.isNotEmpty) {
        finalServicesList.add(state.otherServiceName);
      }
    }
    return finalServicesList;
  }

  String _buildEmailBody({
    required String name,
    required String project,
    required String costing,
    required String deadline,
    required String services,
  }) {
    return '''
═══════════════════════════════════════════
          SERVICE REQUEST INQUIRY
═══════════════════════════════════════════

Dear Admin,

I hope you are doing well.

I am writing to submit a formal service request for your consideration.

───────────────────────────────────────────
CLIENT INFORMATION
───────────────────────────────────────────

Name:                    $name
Date:                    ${DateTime.now().toString().split('.')[0]}

───────────────────────────────────────────
PROJECT DETAILS
───────────────────────────────────────────

Project Description:     $project
Budget/Costing:          $costing
Expected Deadline:       $deadline

───────────────────────────────────────────
REQUESTED SERVICES
───────────────────────────────────────────

$services

───────────────────────────────────────────

Thank you for considering this service request. I look forward to discussing the project details and exploring how we can collaborate to achieve the desired outcomes.

Please feel free to reach out if you require any additional information or clarification regarding this request.

Best regards,
$name

═══════════════════════════════════════════
''';
  }

  String _buildWhatsAppMessage({
    required String name,
    required String project,
    required String costing,
    required String deadline,
    required String services,
  }) {
    return '''
*═══════════════════════════════════════════*
*          SERVICE REQUEST INQUIRY*
*═══════════════════════════════════════════*

Hi Admin,

I wanted to reach out regarding a service request. Please find the details below.

*───────────────────────────────────────────*
*CLIENT INFORMATION*
*───────────────────────────────────────────*

*Name:* $name
*Date:* ${DateTime.now().toString().split('.')[0]}

*───────────────────────────────────────────*
*PROJECT DETAILS*
*───────────────────────────────────────────*

*Project Description:* $project
*Budget/Costing:* $costing
*Expected Deadline:* $deadline

*───────────────────────────────────────────*
*REQUESTED SERVICES*
*───────────────────────────────────────────*

$services

*───────────────────────────────────────────*

Thanks for considering this request. Looking forward to hearing from you!

*Best regards,*
*$name*

*═══════════════════════════════════════════*
''';
  }
}

