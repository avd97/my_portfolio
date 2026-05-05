import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_portfolio/core/constants.dart';
import 'package:flutter/foundation.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  StreamSubscription? _userSubscription;
  Timer? _loadingTimeout;

  HomePageBloc() : super(const HomePageState()) {
    on<InitializeHomePageEvent>(_onInitialize);
    on<NavigateToSectionEvent>(_onNavigate);
    on<_FirebaseDataReceivedEvent>(_onFirebaseDataReceived);
    on<_FirebaseErrorEvent>(_onFirebaseError);
    on<_LoadingTimeoutEvent>(_onLoadingTimeout);
  }

  Future<void> _onInitialize(
    InitializeHomePageEvent event,
    Emitter<HomePageState> emit,
  ) async {
    // Cancel any existing subscription
    _userSubscription?.cancel();
    _loadingTimeout?.cancel();

    // Set a timeout to prevent infinite loading
    _loadingTimeout = Timer(const Duration(seconds: 10), () {
      debugPrint('Loading timeout reached - forcing loading to false');
      if (!isClosed) {
        add(const _LoadingTimeoutEvent());
      }
    });

    final ref = FirebaseDatabase.instance
        .ref(Constants.userDetails)
        .child('admin_info');

    debugPrint('Attempting to connect to Firebase path: ${Constants.userDetails}/admin_info');

    _userSubscription = ref.onValue.listen(
      (DatabaseEvent event) {
        if (!isClosed) {
          add(_FirebaseDataReceivedEvent(event.snapshot));
        }
      },
      onError: (error) {
        if (!isClosed) {
          add(_FirebaseErrorEvent(error));
        }
      },
    );
  }

  Future<void> _onFirebaseDataReceived(
    _FirebaseDataReceivedEvent event,
    Emitter<HomePageState> emit,
  ) async {
    _loadingTimeout?.cancel(); // Cancel timeout since we got data
    final snapshot = event.snapshot;

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      // Debug: Print all keys and values from Firebase
      debugPrint('Firebase data received:');
      data.forEach((key, value) {
        debugPrint('  $key: $value');
      });

      final profilePicUrl = data['profilePic'] ?? data['profile_pic'] ?? '';
      final bgImageUrl = data['bgImage'] ?? data['bg_image'] ?? data['backgroundImage'] ?? '';

      debugPrint('Profile Pic URL: $profilePicUrl');
      debugPrint('Background Image URL: $bgImageUrl');

      emit(state.copyWith(
        userName: data['name'] ?? 'Unknown User',
        mobileNumber: data['mobileNumber'] ?? data['mobile_number'] ?? '',
        emailId: data['emailId'] ?? data['email_id'] ?? '',
        profilePic: profilePicUrl,
        bgImage: bgImageUrl,
        isLoading: false,
        errorMessage: null,
      ));
    } else {
      debugPrint('Firebase snapshot does not exist');
      emit(state.copyWith(
        userName: 'No Name Found',
        isLoading: false,
        errorMessage: 'No admin info found in Firebase',
      ));
    }
  }

  Future<void> _onFirebaseError(
    _FirebaseErrorEvent event,
    Emitter<HomePageState> emit,
  ) async {
    _loadingTimeout?.cancel(); // Cancel timeout on error
    debugPrint('Firebase error: ${event.error}');
    emit(state.copyWith(
      userName: 'Error Loading Name',
      isLoading: false,
      errorMessage: event.error.toString(),
    ));
  }

  Future<void> _onLoadingTimeout(
    _LoadingTimeoutEvent event,
    Emitter<HomePageState> emit,
  ) async {
    debugPrint('Forcing loading state to false due to timeout');
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onNavigate(
    NavigateToSectionEvent event,
    Emitter<HomePageState> emit,
  ) async {
    // Navigation is handled in the UI layer with GlobalKeys
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _loadingTimeout?.cancel();
    return super.close();
  }
}

// Private events for handling Firebase callbacks
class _FirebaseDataReceivedEvent extends HomePageEvent {
  final DataSnapshot snapshot;

  const _FirebaseDataReceivedEvent(this.snapshot);

  @override
  List<Object?> get props => [snapshot];
}

class _FirebaseErrorEvent extends HomePageEvent {
  final Object error;

  const _FirebaseErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}

class _LoadingTimeoutEvent extends HomePageEvent {
  const _LoadingTimeoutEvent();
}
