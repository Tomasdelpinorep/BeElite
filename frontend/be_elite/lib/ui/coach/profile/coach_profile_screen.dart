import 'package:be_elite/bloc/coach/coach_details_bloc.dart';
import 'package:be_elite/misc/Method_Classes/profile_screen_methods.dart';
import 'package:be_elite/misc/Widgets/circular_avatar.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/repositories/user/user_repository.dart';
import 'package:be_elite/repositories/user/user_repository_impl.dart';
import 'package:be_elite/ui/coach/profile/coach_settins_screen.dart';
import 'package:be_elite/ui/coach/profile/manage_account_screen.dart';
import 'package:be_elite/ui/coach/profile/manage_programs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachProfileScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  const CoachProfileScreen({super.key, required this.coachDetails});

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  late CoachDetailsBloc _coachBloc;
  late UserRepository userRepository;
  late CoachDetails coachDetails;

  UserDto? oldestAthlete;
  int totalSessionsCompleted = 0;

  ProfileSreenMethods methods = ProfileSreenMethods();

  @override
  void initState() {
    userRepository = UserRepositoryImpl();
    _coachBloc = CoachDetailsBloc(userRepository)..add(GetCoachDetailsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.grey[800]!, Colors.grey[900]!],
            radius: 0.5,
          ),
        ),
        child: MultiBlocProvider(providers: [
          BlocProvider.value(value: _coachBloc),
        ], child: _blocManager()),
      ),
    );
  }

  Widget _blocManager() {
    return Column(
      children: [
        BlocConsumer<CoachDetailsBloc, CoachDetailsState>(
            builder: (context, state) {
              if (state is CoachDetailsLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is CoachDetailsErrorState) {
                return Text(state.errorMessage);
              } else if (state is CoachDetailsSuccessState) {
                coachDetails = state.coachDetails;
                _coachBloc
                    .add(GetProfileScreenStatsEvent(coachDetails.username!));
              } else if (state is GetProfileStatsSuccessState) {
                oldestAthlete = state.oldestAthlete;
                totalSessionsCompleted = state.totalSessionsCompleted;
                return _buildProfilePage();
              } else if (state is GetProfileStatsErrorState) {
                return _buildProfilePageNoStats(state.errorMessage);
              }
              return const SizedBox();
            },
            listener: (context, state) {})
      ],
    );
  }

  Widget _buildProfilePageNoStats(String errorMessage) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: CircularProfileAvatar(
              imageUrl: coachDetails.profilePicUrl!, radius: 100),
        ),
        const SizedBox(height: 20),
        Text(coachDetails.name!, style: const TextStyle(fontSize: 24)),
        Text(coachDetails.email!,
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              _profilePageOption(Icons.data_usage_rounded, 'Manage Programs'),
              _profilePageOption(Icons.person, 'Account'),
              _profilePageOption(Icons.settings, 'Settings')
            ],
          ),
        ),
        const SizedBox(height: 100),
        const Text(
          'There has been an unexpected error while loading your statistics.',
          style: TextStyle(fontSize: 16),
        ),
        Text(errorMessage)
      ],
    );
  }

  Widget _buildProfilePage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: CircularProfileAvatar(
              imageUrl: coachDetails.profilePicUrl!, radius: 100),
        ),
        const SizedBox(height: 20),
        Text(coachDetails.name!, style: const TextStyle(fontSize: 24)),
        Text(coachDetails.email!,
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              GestureDetector(
                  child: _profilePageOption(
                      Icons.data_usage_rounded, 'Manage Programs'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageProgramsScreen(
                                programs: coachDetails.programs!,
                                coachDetails: coachDetails)));
                  }),
              GestureDetector(
                  child: _profilePageOption(Icons.person, 'Account'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageAccountScreen(
                                coachDetails: coachDetails)));
                  }),
              GestureDetector(
                  child: _profilePageOption(Icons.settings, 'Settings'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CoachSettingsScreen()));
                  })
            ],
          ),
        ),
        const SizedBox(height: 100),
        const Text(
          'Your Stats:',
          style: TextStyle(fontSize: 22),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                coachDetails.programs!.length > 1
                    ? _buildBulletPoint(
                        '${coachDetails.programs!.length} training programs')
                    : _buildBulletPoint(
                        '${coachDetails.programs!.length} training program'),
                coachDetails.athletes!.length > 1
                    ? _buildBulletPoint(
                        '${coachDetails.athletes!.length} athletes')
                    : _buildBulletPoint(
                        '${coachDetails.athletes!.length} athlete'),
                oldestAthlete != null
                    ? _buildBulletPoint(
                        '${oldestAthlete!.name} has been with you the longest (${methods.getDaysInProgram(oldestAthlete!.joinedProgramDate!)} days)')
                    : const SizedBox(),
                _buildBulletPoint(
                    '$totalSessionsCompleted total sessions completed')
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _profilePageOption(IconData icon, String text) {
    return SizedBox(
      height: 125,
      width: 125,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white10,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 70, color: Colors.white),
            ),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w100))
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return ListTile(
      leading: const Icon(Icons.circle, size: 10), // Bullet point icon
      title: Text(text),
    );
  }
}
