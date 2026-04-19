part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class ToggleServiceEvent extends ServicesEvent {
  final String service;

  const ToggleServiceEvent(this.service);

  @override
  List<Object?> get props => [service];
}

class ProceedToFormEvent extends ServicesEvent {
  const ProceedToFormEvent();
}

class BackToServicesEvent extends ServicesEvent {
  const BackToServicesEvent();
}

class SendRequestViaEmailEvent extends ServicesEvent {
  final String name;
  final String project;
  final String costing;
  final String deadline;

  const SendRequestViaEmailEvent({
    required this.name,
    required this.project,
    required this.costing,
    required this.deadline,
  });

  @override
  List<Object?> get props => [name, project, costing, deadline];
}

class SendRequestViaWhatsAppEvent extends ServicesEvent {
  final String name;
  final String project;
  final String costing;
  final String deadline;
  final String phoneNumber;

  const SendRequestViaWhatsAppEvent({
    required this.name,
    required this.project,
    required this.costing,
    required this.deadline,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [name, project, costing, deadline, phoneNumber];
}

class UpdateOtherServiceEvent extends ServicesEvent {
  final String value;

  const UpdateOtherServiceEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class ResetFormEvent extends ServicesEvent {
  const ResetFormEvent();
}

