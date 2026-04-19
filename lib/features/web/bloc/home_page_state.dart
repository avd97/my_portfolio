part of 'home_page_bloc.dart';

class HomePageState extends Equatable {
  final String userName;
  final String mobileNumber;
  final String emailId;
  final String profilePic;
  final String bgImage;
  final bool isLoading;
  final String? errorMessage;

  const HomePageState({
    this.userName = 'Loading...',
    this.mobileNumber = 'Loading...',
    this.emailId = 'Loading...',
    this.profilePic = '',
    this.bgImage = '',
    this.isLoading = true,
    this.errorMessage,
  });

  HomePageState copyWith({
    String? userName,
    String? mobileNumber,
    String? emailId,
    String? profilePic,
    String? bgImage,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomePageState(
      userName: userName ?? this.userName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emailId: emailId ?? this.emailId,
      profilePic: profilePic ?? this.profilePic,
      bgImage: bgImage ?? this.bgImage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    userName,
    mobileNumber,
    emailId,
    profilePic,
    bgImage,
    isLoading,
    errorMessage,
  ];
}

