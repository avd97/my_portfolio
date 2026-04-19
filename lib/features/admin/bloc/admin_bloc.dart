import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_portfolio/core/constants.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  late final DatabaseReference dbRef;

  AdminBloc() : super(const AdminState()) {
    dbRef = FirebaseDatabase.instance.ref(Constants.userDetails);

    on<LoadUserDetailsEvent>(_onLoadUserDetails);
    on<SaveUserDetailsEvent>(_onSaveUserDetails);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Handle loading user details
  Future<void> _onLoadUserDetails(
    LoadUserDetailsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final snapshot = await dbRef.child('admin_info').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        debugPrint('✅ Loaded user details: ${data['name']}');

        emit(state.copyWith(
          isLoading: false,
          name: data['name'] ?? '',
          mobileNumber: data['mobileNumber'] ?? '',
          emailId: data['emailId'] ?? '',
          designation: data['designation'] ?? '',
        ));
      } else {
        debugPrint('⚠️ No user details found in database.');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      debugPrint('❌ Error loading user details: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load data: $e',
      ));
    }
  }

  /// Handle saving user details
  Future<void> _onSaveUserDetails(
    SaveUserDetailsEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      await dbRef.child('admin_info').update({
        'name': event.name,
        'mobileNumber': event.mobileNumber,
        'emailId': event.emailId,
        'designation': event.designation,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      debugPrint('✅ User details saved successfully');
      emit(state.copyWith(
        isSaving: false,
        isSuccess: true,
        name: event.name,
        mobileNumber: event.mobileNumber,
        emailId: event.emailId,
        designation: event.designation,
      ));

      // Reset success flag after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(isSuccess: false));
    } catch (e) {
      debugPrint('❌ Error saving data: $e');
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save data: $e',
      ));
    }
  }

  /// Handle clearing error message
  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null));
  }
}

