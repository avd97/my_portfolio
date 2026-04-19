import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/features/admin/bloc/admin_bloc.dart';
import 'package:my_portfolio/features/admin/bloc/admin_event.dart';
import 'package:my_portfolio/features/admin/bloc/admin_state.dart';

class AdminAccessScreen extends StatefulWidget {
  const AdminAccessScreen({super.key});

  @override
  State<AdminAccessScreen> createState() => _AdminAccessScreenState();
}

class _AdminAccessScreenState extends State<AdminAccessScreen> {
  late final TextEditingController userNameController;
  late final TextEditingController mobileNoController;
  late final TextEditingController emailIdController;
  late final TextEditingController designationController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    context.read<AdminBloc>().add(const LoadUserDetailsEvent());
  }

  void _initializeControllers() {
    userNameController = TextEditingController();
    mobileNoController = TextEditingController();
    emailIdController = TextEditingController();
    designationController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    userNameController.dispose();
    mobileNoController.dispose();
    emailIdController.dispose();
    designationController.dispose();
    super.dispose();
  }

  /// 🔹 Validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// 🔹 Validate mobile number format
  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }
    final phoneRegex = RegExp(r'^[\d\s\-+(). ]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// 🔹 Save or update user details
  void _saveUserDetails() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AdminBloc>().add(SaveUserDetailsEvent(
      name: userNameController.text.trim(),
      mobileNumber: mobileNoController.text.trim(),
      emailId: emailIdController.text.trim(),
      designation: designationController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio Admin'),
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            // Update controllers when state changes
            if (userNameController.text != state.name && state.name.isNotEmpty) {
              userNameController.text = state.name;
              mobileNoController.text = state.mobileNumber;
              emailIdController.text = state.emailId;
              designationController.text = state.designation;
            }

            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  children: [
                    if (state.errorMessage != null)
                      _buildErrorWidget(state.errorMessage!),
                    if (state.isSuccess)
                      _buildSuccessWidget(),
                    _buildForm(state),
                    const SizedBox(height: 20),
                    _buildSaveButton(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<AdminBloc>().add(const ClearErrorEvent());
            },
            child: Icon(Icons.close, color: Colors.red.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '✅ User details updated successfully!',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(AdminState state) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16,
        children: [
          TextFormField(
            controller: userNameController,
            enabled: !state.isSaving,
            decoration: const InputDecoration(
              labelText: 'Enter user name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: mobileNoController,
            enabled: !state.isSaving,
            decoration: const InputDecoration(
              labelText: 'Enter Mobile Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: _validateMobileNumber,
          ),
          TextFormField(
            controller: emailIdController,
            enabled: !state.isSaving,
            decoration: const InputDecoration(
              labelText: 'Enter Email Id',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          TextFormField(
            controller: designationController,
            enabled: !state.isSaving,
            decoration: const InputDecoration(
              labelText: 'Enter Designation',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.work),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(AdminState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: state.isSaving ? null : _saveUserDetails,
        icon: state.isSaving
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save),
        label: Text(state.isSaving ? 'Saving...' : 'Save User Details'),
      ),
    );
  }
}
