import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Profile_screen/data/repo/profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Profilerepo profileRepo;

  ProfileBloc(this.profileRepo) : super(ProfileInitial()) {
    on<FetchProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await profileRepo.fetchProfile(event.userId);
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}