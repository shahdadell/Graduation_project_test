import 'package:graduation_project/Profile_screen/data/model/response/profile_screen_response/profile_screen_response.dart';


abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileScreenResponse profile;

  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}