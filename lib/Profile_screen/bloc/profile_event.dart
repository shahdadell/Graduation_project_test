abstract class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {
  final String userId;

  FetchProfileEvent(this.userId);
}