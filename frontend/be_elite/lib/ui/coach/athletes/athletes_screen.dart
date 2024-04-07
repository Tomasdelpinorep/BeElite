import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/bloc/program/program_bloc.dart';
import 'package:be_elite/bloc/session/session_bloc.dart';
import 'package:be_elite/misc/Widgets/beElite_logo.dart';
import 'package:be_elite/misc/Widgets/circular_avatar.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/models/Session/post_session_dto/session_card_dto/session_card_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/repositories/program/program_repository_impl.dart';
import 'package:be_elite/repositories/session/session_repository.dart';
import 'package:be_elite/repositories/session/session_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
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
  String? selectedAthleteUsername;
  List<SessionCardDto> athleteSessions = [];

  late String selectedProgramName;
  late AthleteBloc _athleteBLoc;
  late AthleteRepository athleteRepository;
  late List<UserDto> athletes;
  late SessionBloc _sessionBloc;
  late SessionRepository sessionRepository;
  late ProgramRepository programRepository;
  late ProgramBloc _programBloc;

  @override
  void initState() {
    athleteRepository = AthleteRepositoryImpl();
    _athleteBLoc = AthleteBloc(athleteRepository);
    sessionRepository = SessionRepositoryImpl();
    _sessionBloc = SessionBloc(sessionRepository);
    programRepository = ProgramRepositoryImpl();
    _programBloc = ProgramBloc(programRepository);
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
          BlocProvider.value(value: _sessionBloc),
          BlocProvider.value(value: _programBloc)
        ], child: _blocManager()),
      ),
    );
  }

  Widget _blocManager() {
    return Column(
      children: [
        BlocConsumer<AthleteBloc, AthleteState>(
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
          listener: (context, state) {},
        ),
        BlocConsumer<SessionBloc, SessionState>(
          buildWhen: (context, state) {
            return state is SessionLoadingState ||
                state is SessionErrorState ||
                state is GetSessionCardDataSuccessState;
          },
          builder: (context, state) {
            if (state is SessionLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SessionErrorState) {
              return Text(state.errorMessage);
            } else if (state is GetSessionCardDataSuccessState) {
              athleteSessions = state.sessionPage.sessionCardDto!;
              return _athleteSessionCardsWidget(athleteSessions);
            }
            return const SizedBox(height: 0);
          },
          listener: (context, state) {},
        ),
        BlocListener<ProgramBloc, ProgramState>(
          listener: (context, state) {
            if (state is SendInviteSuccessState) {
            } else if (state is ProgramErrorState) {}
          },
          child: const SizedBox(),
        )
      ],
    );
  }

  Widget _buildHome() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _topBarWidget(widget.coachDetails),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_inviteAthleteButton()]),
                  _athleteSelectorWidget(athletes),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyHome() {
    return Container(
      height: 800,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topBarWidget(widget.coachDetails),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$selectedProgramName has no athletes yet.'),
                const SizedBox(height: 30),
                _bigInviteAthleteButton()
              ],
            ),
          )
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
                    child: SizedBox(
                        height: 100,
                        child: _programSelectorWidget(coachDetails))),
              ),
              const BeEliteLogo()
            ],
          ),
        ),
        const SizedBox(
          height: 10,
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
                  _athleteBLoc.add(GetAthletesByProgramEvent(
                      program.program_name!, coachDetails.username!));
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

  Widget _athleteSelectorWidget(List<UserDto> athletes) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        border: Border.all(color: AppColors.mainYellow),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton(
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 32.0,
        isExpanded: true,
        hint: const Text(
          'Select an athlete to view their feedback.',
          style: TextStyle(fontSize: 16.0),
        ),
        onChanged: (newValue) {
          setState(() {
            athleteSessions.clear();
            selectedAthleteUsername = newValue;
          });
          _sessionBloc.add(GetSessionCardDataEvent(selectedAthleteUsername!));
        },
        items: athletes.map((athlete) {
          return DropdownMenuItem(
            value: athlete.username,
            child: Text(
              athlete.name!,
              style: const TextStyle(fontSize: 16.0), // Adjust item text style
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _inviteAthleteButton() {
    return Row(children: [
      ElevatedButton.icon(
        icon: const Icon(Icons.outgoing_mail, color: Colors.black),
        label: const Text(
          'Invite new athlete',
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      )
    ]);
  }

  Widget _bigInviteAthleteButton() {
    return SizedBox(
      height: 100,
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          openInviteDialog();
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: AppColors.mainYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.outgoing_mail,
              size: 32,
              color: Colors.black,
            ),
            SizedBox(height: 8),
            Text(
              'Invite an athlete',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _athleteSessionCardsWidget(List<SessionCardDto> athleteSessions) {
    if (athleteSessions.isEmpty) {
      return Center(
        child: Container(color: Colors.red),
      );
    } else {
      return ListView.builder(
        itemCount: athleteSessions.length,
        itemBuilder: (context, index) {
          return Center(child: Text(athleteSessions[index].title!));
        },
      );
    }
  }

  void openInviteDialog() {
    final athleteUsernameTextController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Invite Athlete'),
              content: TextFormField(
                controller: athleteUsernameTextController,
                decoration: const InputDecoration(
                  hintText: 'Athlete username',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white54), // Underline color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white), // Focused underline color
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Athlete username cannot be empty';
                  }
                  return null;
                },
              ),
              actions: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.outgoing_mail, color: Colors.black),
                  label: const Text(
                    'Send invite',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ],
            ));
  }
}
