import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_portfolio/core/constants.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  StreamSubscription? _userSubscription;

  HomePageBloc() : super(const HomePageState()) {
    on<InitializeHomePageEvent>(_onInitialize);
    on<NavigateToSectionEvent>(_onNavigate);
  }

  Future<void> _onInitialize(
    InitializeHomePageEvent event,
    Emitter<HomePageState> emit,
  ) async {
    final ref = FirebaseDatabase.instance
        .ref(Constants.userDetails)
        .child('admin_info');

    _userSubscription = ref.onValue.listen(
      (DatabaseEvent event) {
        final snapshot = event.snapshot;

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;

          emit(state.copyWith(
            userName: data['name'] ?? 'Unknown User',
            mobileNumber: data['mobileNumber'] ?? '',
            emailId: data['emailId'] ?? '',
            profilePic: data['profilePic'] ?? '',
            bgImage: data['bgImage'] ?? '',
            isLoading: false,
            errorMessage: null,
          ));
        } else {
          emit(state.copyWith(
            userName: 'No Name Found',
            isLoading: false,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          userName: 'Error Loading Name',
          isLoading: false,
          errorMessage: error.toString(),
        ));
      },
    );
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
    return super.close();
  }
}

