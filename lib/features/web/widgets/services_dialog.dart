import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/features/web/bloc/services_bloc.dart';
import 'package:my_portfolio/features/web/models/service_item.dart';

class ServicesDialog extends StatefulWidget {
  final String? adminPhoneNumber;

  const ServicesDialog({super.key, this.adminPhoneNumber});

  @override
  State<ServicesDialog> createState() => _ServicesDialogState();
}

class _ServicesDialogState extends State<ServicesDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController costingController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController otherServiceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    projectController.dispose();
    costingController.dispose();
    deadlineController.dispose();
    otherServiceController.dispose();
    super.dispose();
  }

  void _toggleService(String service) {
    context.read<ServicesBloc>().add(ToggleServiceEvent(service));
  }

  void _proceedToForm() {
    context.read<ServicesBloc>().add(const ProceedToFormEvent());
  }

  void _backToServices() {
    context.read<ServicesBloc>().add(const BackToServicesEvent());
    context.read<ServicesBloc>().add(const ResetFormEvent());
  }

  void _closeDialog() {
    context.read<ServicesBloc>().add(const ResetFormEvent());
    Navigator.of(context).pop();
  }

  String _buildSelectedServicesText(Set<String> selectedServices, bool isOthersSelected, String otherServiceName) {
    List<String> finalServicesList = List.from(selectedServices);
    if (isOthersSelected) {
      finalServicesList.remove('Others');
      if (otherServiceName.isNotEmpty) {
        finalServicesList.add(otherServiceName);
      }
    }
    return '✅ ${finalServicesList.join('\n✅ ')}';
  }

  void _sendRequest() {
    final name = nameController.text.trim();
    final project = projectController.text.trim();
    final costing = costingController.text.trim();
    final deadline = deadlineController.text.trim();

    context.read<ServicesBloc>().add(SendRequestViaEmailEvent(
      name: name,
      project: project,
      costing: costing,
      deadline: deadline,
    ));
    context.read<ServicesBloc>().add(const ResetFormEvent());
  }

  void _sendViaWhatsApp() {
    final name = nameController.text.trim();
    final project = projectController.text.trim();
    final costing = costingController.text.trim();
    final deadline = deadlineController.text.trim();
    final phoneNumber = widget.adminPhoneNumber ?? '';

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp number not available')),
      );
      return;
    }

    context.read<ServicesBloc>().add(SendRequestViaWhatsAppEvent(
      name: name,
      project: project,
      costing: costing,
      deadline: deadline,
      phoneNumber: phoneNumber,
    ));
    context.read<ServicesBloc>().add(const ResetFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServicesBloc, ServicesState>(
      listener: (context, state) {
        if (state.requestSent) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request sent successfully!')),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.white, // ✅ Proper white background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.shade300, // ✅ Border color
              width: 1.2,
            ),
          ),
          shadowColor: Colors.black,
          elevation: 12,
          clipBehavior: Clip.antiAlias, // ✅ Important to preserve rounded corners
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.build, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      state.showForm ? 'Project Requirements' : 'Select Services',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _closeDialog,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (!state.showForm) ...[
                  const Text(
                    'Choose the services you\'re interested in:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: servicesList.length,
                      itemBuilder: (context, index) {
                        final service = servicesList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              title: Row(
                                children: [
                                  Icon(service.icon, size: 20, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      service.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              value: state.selectedServices.contains(service.title),
                              onChanged: (bool? value) => _toggleService(service.title),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            // Show text field for Others service
                            if (service.title == 'Others' && state.isOthersSelected)
                              Padding(
                                padding: const EdgeInsets.only(left: 32, right: 8, bottom: 8),
                                child: TextField(
                                  controller: otherServiceController,
                                  onChanged: (value) {
                                    context.read<ServicesBloc>().add(UpdateOtherServiceEvent(value));
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter custom service name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _closeDialog,
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: state.selectedServices.isNotEmpty ? _proceedToForm : null,
                        child: const Text('Proceed'),
                      ),
                    ],
                  ),
                ] else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Please provide your project details:',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          // Display selected services
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xffeefbff),
                              border: Border.all(color: Colors.blue.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Selected Services:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Text(
                                    _buildSelectedServicesText(
                                      state.selectedServices,
                                      state.isOthersSelected,
                                      state.otherServiceName,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Your Name',
                              border: OutlineInputBorder(),
                              errorText: state.errorMessage?.contains('Name') == true ? 'Name is required' : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: projectController,
                            decoration: InputDecoration(
                              labelText: 'Project Description',
                              border: OutlineInputBorder(),
                              errorText: state.errorMessage?.contains('Project') == true ? 'Project description is required' : null,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: costingController,
                            decoration: const InputDecoration(
                              labelText: 'Budget/Costing (Optional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: deadlineController,
                            decoration: const InputDecoration(
                              labelText: 'Deadline (Optional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (state.isOthersSelected)
                            TextField(
                              controller: otherServiceController,
                              onChanged: (value) {
                                context.read<ServicesBloc>().add(UpdateOtherServiceEvent(value));
                              },
                              decoration: InputDecoration(
                                labelText: 'Custom Service Name',
                                border: OutlineInputBorder(),
                                errorText: state.otherServiceError,
                              ),
                            ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: _backToServices,
                                child: const Text('Back'),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                onPressed: state.isSubmitting ? null : _sendViaWhatsApp,
                                icon: const Icon(Icons.call),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: state.isSubmitting ? null : _sendRequest,
                                child: state.isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.mail),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
