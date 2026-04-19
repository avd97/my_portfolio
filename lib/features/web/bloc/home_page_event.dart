part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object?> get props => [];
}

class InitializeHomePageEvent extends HomePageEvent {
  const InitializeHomePageEvent();
}

class NavigateToSectionEvent extends HomePageEvent {
  final String section;

  const NavigateToSectionEvent(this.section);

  @override
  List<Object?> get props => [section];
}

