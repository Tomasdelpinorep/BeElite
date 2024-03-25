import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/misc/Widgets/beElite_logo.dart';
import 'package:be_elite/misc/Widgets/circular_avatar.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/ui/coach/programs/add_program_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AthletesScreen extends StatefulWidget {
  final CoachDetails coachDetails;
  const AthletesScreen({super.key, required this.coachDetails});

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen> {
  late String selectedProgramName;
  late AthleteBloc _athleteBLoc;
  late AthleteRepository athleteRepository;
  late List<UserDto> athletes;

  @override
  void initState() {
    athleteRepository = AthleteRepositoryImpl();
    _athleteBLoc = AthleteBloc(athleteRepository);
    _loadDropDownValue();
    super.initState();
  }

  // loads the selected program name from shared preferences
  Future<void> _loadDropDownValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedProgramName = (prefs.getString('selectedProgramName') ??
          widget.coachDetails.programs?.first.program_name)!;
    });

    _athleteBLoc.add(GetAthletesByProgramEvent(
        selectedProgramName, widget.coachDetails.username!));
  }

  Future<void> _saveDropDownValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProgramName', value);
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
          BlocProvider.value(value: _athleteBLoc),
        ], child: _blocManager()),
      ),
    );
  }

  Widget _blocManager() {
    return Column(
      children: [
        Expanded(
          child: BlocConsumer<AthleteBloc, AthleteState>(
            buildWhen: (context, state) {
              return state is AthleteLoadingState ||
                  state is AthleteErrorState ||
                  state is GetAthletesByProgramEmptyState ||
                  state is GetAthletesByProgramSuccessState;
            },
            builder: (context, state) {
              if (state is AthleteLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AthleteErrorState) {
                return Text(
                    'Error fetching athletes for program with name: $selectedProgramName.');
              } else if (state is GetAthletesByProgramEmptyState) {
                athletes = [];
                return _buildEmptyHome();
              } else if (state is GetAthletesByProgramSuccessState) {
                athletes = state.athletes;
                return _buildHome();
              } else {
                return const Placeholder();
              }
            },
            // listenWhen: (context,state){},
            listener: (context, state) {},
          ),
        )
      ],
    );
  }

  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topBarWidget(widget.coachDetails),
          Expanded(
            child: Stack(
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHome() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topBarWidget(widget.coachDetails),
          Expanded(
            child: Stack(
              children: [
                Center(
                    child: Text('$selectedProgramName has no athletes yet.')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget(CoachDetails coachDetails) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              CircularProfileAvatar(
                  imageUrl: coachDetails.profilePicUrl ??
                      'https://i.imgur.com/jNNT4LE.png'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right:
                          40), //This centers the welcome message over the program selector, 40 is avatar's radius
                  child: Column(
                    children: [
                      Text('Hello ${coachDetails.name}'),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              const BeEliteLogo()
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _programSelectorWidget(coachDetails),
          ]),
        ),
      ],
    );
  }

  Widget _programSelectorWidget(CoachDetails coachDetails) {
    List<ProgramDto>? programs = coachDetails.programs;

    programs ??= [];

    return Container(
      width: 472,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          underline: Container(),
          items: [
            // Existing programs
            ...programs.map((ProgramDto program) {
              return DropdownMenuItem<String>(
                value: program.program_name,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      program.image!.isNotEmpty
                          ? Image.network(
                              program.image!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://i.imgur.com/95vlMNd.jpg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                      const SizedBox(width: 25),
                      Text(
                        program.program_name!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _athleteBLoc.add(GetAthletesByProgramEvent(program.program_name!, coachDetails.username!));
                },
              );
            }),
            // "Create New" option
            const DropdownMenuItem<String>(
              value: 'new',
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline,
                      color: Colors.white), // Icon for "Create New"
                  SizedBox(width: 8),
                  Text(
                    'Create New Program',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
          value: selectedProgramName,
          onChanged: (String? newValue) {
            if (newValue != selectedProgramName) {
              switch (newValue) {
                case 'new':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoachAddProgramScreen(
                              coachDetails: coachDetails)));
                  break;
              }

              setState(() {
                selectedProgramName = newValue!;
                _saveDropDownValue(selectedProgramName);
              });
            }
          },
        ),
      ),
    );
  }
}
