part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {
  @override
  List<Object?> get props => [];
}

final class OnboardingReady extends OnboardingState {
  @override
  List<Object?> get props => [];
}

final class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class OnboardingDone extends OnboardingState {
  @override
  List<Object?> get props => [];
}
