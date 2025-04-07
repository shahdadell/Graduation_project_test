abstract class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {
  final String userId;

  FetchProfileEvent(this.userId);
}

class UpdateProfileEvent extends ProfileEvent {
  final String userId;
  final String username;
  final String email;
  final String phone;

  UpdateProfileEvent(this.userId, this.username, this.email, this.phone);
}