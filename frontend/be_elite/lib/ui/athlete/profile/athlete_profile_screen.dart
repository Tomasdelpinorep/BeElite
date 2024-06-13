import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/misc/Method_Classes/profile_screen_methods.dart';
import 'package:be_elite/misc/Widgets/circular_avatar.dart';
import 'package:be_elite/models/Athlete/athlete_details_dto/athlete_details_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthleteProfileScreen extends StatefulWidget {
  final AthleteDetailsDto athleteDetails;
  const AthleteProfileScreen({super.key, required this.athleteDetails});

  @override
  State<AthleteProfileScreen> createState() => _AthleteProfileScreenState();
}

class _AthleteProfileScreenState extends State<AthleteProfileScreen> {
  late AthleteBloc _athleteBloc;
  late AthleteRepository athleteRepository;
  int totalSessionsCompleted = 0;

  ProfileSreenMethods methods = ProfileSreenMethods();

  @override
  void initState() {
    athleteRepository = AthleteRepositoryImpl();
    _athleteBloc = AthleteBloc(athleteRepository);
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
          BlocProvider.value(value: _athleteBloc),
        ], child: _blocManager()),
      ),
    );
  }

  Widget _blocManager() {
    return Placeholder();
  }

  Widget _buildProfilePageNoStats(String errorMessage) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: CircularProfileAvatar(
              imageUrl: widget.athleteDetails.profilePicUrl!, radius: 100),
        ),
        const SizedBox(height: 20),
        Text(widget.athleteDetails.name!, style: const TextStyle(fontSize: 24)),
        Text(widget.athleteDetails.email!,
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
              imageUrl: widget.athleteDetails.profilePicUrl!, radius: 100),
        ),
        const SizedBox(height: 20),
        Text(widget.athleteDetails.name!, style: const TextStyle(fontSize: 24)),
        Text(widget.athleteDetails.email!,
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
                  onTap: () {}),
              GestureDetector(
                  child: _profilePageOption(Icons.person, 'Account'),
                  onTap: () {}),
              GestureDetector(
                  child: _profilePageOption(Icons.settings, 'Settings'),
                  onTap: () {})
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
              children: const [Text("Stats will appear here.")],
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
