import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/bloc/program/program_bloc.dart';
import 'package:be_elite/bloc/session/session_bloc.dart';
import 'package:be_elite/misc/Method_Classes/athletes_screen_methods.dart';
import 'package:be_elite/misc/Widgets/beElite_logo.dart';
import 'package:be_elite/misc/Widgets/circular_avatar.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/user_dto.dart';
import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/models/Program/post_invite_dto.dart';
import 'package:be_elite/models/Program/program_dto.dart';
import 'package:be_elite/models/Session/session_card_dto/session_card_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/repositories/program/program_repository_impl.dart';
import 'package:be_elite/repositories/session/session_repository.dart';
import 'package:be_elite/repositories/session/session_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
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

  List<InviteDto> invitesSent = [];
  bool showInvitationStatusWidget = false;
  bool showEmptySessionCard = true;
  AthleteScreenMethods methods = AthleteScreenMethods();

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
          widget.coachDetails.programs?.first.programName)!;
    });

    _athleteBLoc.add(GetAthletesByProgramEvent(
        selectedProgramName, widget.coachDetails.username!));
    _programBloc.add(GetInvitesSentEvent(
        widget.coachDetails.username!, selectedProgramName));
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
              _programBloc.add(GetInvitesSentEvent(
                  widget.coachDetails.username!, selectedProgramName));
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
          builder: (context, state) {
            if (state is SessionLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SessionErrorState) {
              return Text(state.errorMessage);
            }
            return const SizedBox(height: 0);
          },
          listener: (context, state) {
            if (state is GetSessionCardDataIsEmptyState) {
              setState(() {
                showEmptySessionCard = false;
              });
            } else if (state is GetSessionCardDataSuccessState) {
              setState(() {
                athleteSessions = state.sessionPage.sessionCardDtos!;
                showEmptySessionCard = false;
              });
            }
          },
        ),
        BlocListener<ProgramBloc, ProgramState>(
          listener: (context, state) {
            if (state is SendInviteSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Show dialog
                    return AlertDialog(
                      title: const Text('Success!',
                          style: TextStyle(color: Colors.white)),
                      content: const Text('Invite has been sent.',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: AppColors.successGreen,
                    );
                  },
                );
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CoachMainScreen()),
                  );
                });
              });
            } else if (state is ProgramErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Show dialog
                    return AlertDialog(
                      title: const Text('Error',
                          style: TextStyle(color: Colors.white)),
                      content: Text(state.errorMessage,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: AppColors.errorRed,
                    );
                  },
                );
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CoachMainScreen()),
                  );
                });
              });
            } else if (state is GetInvitesSentSuccessState) {
              setState(() {
                invitesSent = state.invites;
              });
            }
          },
          child: const SizedBox(),
        )
      ],
    );
  }

  Widget _buildHome() {
    return Expanded(
      child: Container(
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
                        children: [
                          _inviteAthleteButton(),
                          _viewInvitationStatusButton(),
                          _kickAthleteButton()
                        ]),
                    _athleteSelectorWidget(athletes),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            showInvitationStatusWidget
                ? _invitationStatusWidget()
                : const SizedBox(),
            selectedAthleteUsername != null && athleteSessions.isNotEmpty
                ? Expanded(child: _athleteSessionCardsWidget())
                : Column(
                    children: [
                      const SizedBox(height: 150),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(child: _emptySessionCard())),
                    ],
                  ),
          ],
        ),
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
                _bigInviteAthleteButton(),
              ],
            ),
          ),
          const Text('Invitations', style: TextStyle(fontSize: 20)),
          SizedBox(
              height: 150,
              child: SingleChildScrollView(child: _invitationStatusWidget()))
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
                      'https://i.imgur.com/jNNT4LE.png',
                  radius: 40),
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
                value: program.programName,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      program.programPicUrl!.isNotEmpty
                          ? Image.network(
                              program.programPicUrl!,
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
                        program.programName!,
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
                      program.programName!, coachDetails.username!));
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
                invitesSent = [];
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
        value: selectedAthleteUsername,
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
    return SizedBox(
      width: 100,
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
              size: 24,
              color: Colors.black,
            ),
            Text(
              'Invite',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
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

  void openInviteDialog() {
    final athleteUsernameTextController = TextEditingController();
    final GlobalKey<FormState> inviteFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Athlete'),
        content: Form(
          key: inviteFormKey,
          child: TextFormField(
            controller: athleteUsernameTextController,
            decoration: const InputDecoration(
              hintText: 'Athlete username',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Athlete username cannot be empty';
              }
              return null;
            },
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.outgoing_mail, color: Colors.black),
              label: const Text(
                'Send invite',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              onPressed: () {
                if (inviteFormKey.currentState!.validate()) {
                  _programBloc.add(SendInviteEvent(PostInviteDto(
                      athleteUsername: athleteUsernameTextController.text,
                      programName: selectedProgramName,
                      coachId: widget.coachDetails.id)));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _invitationStatusWidget() {
    if (invitesSent.isEmpty) {
      return DataTable(
        columns: const [
          DataColumn(label: Text('Athlete Username')),
          DataColumn(label: Text('Invitation Status'))
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('This program has sent no invitations yet.')),
            DataCell(Text(""))
          ])
        ],
      );
    } else {
      return DataTable(
        columns: const [
          DataColumn(label: Text('Athlete Username')),
          DataColumn(label: Text('Invitation Status'))
        ],
        rows: invitesSent.map((invite) {
          return DataRow(cells: [
            DataCell(Text(invite.athleteUsername!)),
            DataCell(Text(invite.status!))
          ]);
        }).toList(),
      );
    }
  }

  Widget _viewInvitationStatusButton() {
    return SizedBox(
      width: 100,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            if (showInvitationStatusWidget) {
              showInvitationStatusWidget = false;
            } else {
              showInvitationStatusWidget = true;
            }
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_email_unread,
              size: 24,
              color: Colors.black,
            ),
            Text(
              'Status',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kickAthleteButton() {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          // openKickDialog();
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: AppColors.errorRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_remove_alt_1_rounded,
              size: 24,
              color: Colors.black,
            ),
            Text(
              'Kick',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _athleteSessionCardsWidget() {
    return SizedBox(
      width: 330,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 30),
        itemCount: athleteSessions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.mainYellow,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            methods.getSessionCardTitle(
                                athleteSessions[index].date!),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: athleteSessions[index].blocks!.isNotEmpty
                                ? methods.getNumberOfWorkoutsCompleted(
                                        athleteSessions[index].blocks!) /
                                    athleteSessions[index].blocks!.length
                                : 0,
                            backgroundColor: Colors.black,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.yellow[900]!),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${methods.getNumberOfWorkoutsCompleted(athleteSessions[index].blocks!)}/${athleteSessions[index].blocks!.length} workouts completed',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      shrinkWrap: true,
                      itemCount: (athleteSessions.length / 2).ceil(),
                      itemBuilder: (context, blockIndex) {
                        final leftIndex = blockIndex * 2;
                        final rightIndex = leftIndex + 1;

                        if (athleteSessions[index].blocks!.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Wrap(
                              runSpacing: 8.0,
                              alignment: WrapAlignment.center,
                              children: [
                                leftIndex <
                                        athleteSessions[index].blocks!.length
                                    ? SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            athleteSessions[index]
                                                    .blocks![leftIndex]
                                                    .isCompleted!
                                                ? Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .successGreen,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.75),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              0, 3),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.errorRed,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.75),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              0, 3),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            Text(
                                              athleteSessions[index]
                                                  .blocks![leftIndex]
                                                  .movement!,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),

                                // If there's another block on the right, put the divider there
                                // I think +1 should work but it doesn't, +2 works fine though :/
                                athleteSessions[index].blocks!.length >
                                        blockIndex + 2
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 8),
                                        child: SizedBox(
                                          height: 40,
                                          child: VerticalDivider(
                                            color: Colors.grey,
                                            thickness: 2.0,
                                            width: 10.0,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                rightIndex <
                                        athleteSessions[index].blocks!.length
                                    ? SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            athleteSessions[index]
                                                    .blocks![leftIndex]
                                                    .isCompleted!
                                                ? Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .successGreen,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.75),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              0, 3),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.errorRed,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 0.75),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              0, 3),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            Text(
                                              athleteSessions[index]
                                                  .blocks![rightIndex]
                                                  .movement!,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox(height: 10);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptySessionCard() {
    final List<String> data = [
      "Exercise 1",
      "Exercise 2",
      "Exercise 3",
      "Exercise 4"
    ];

    if (showEmptySessionCard) {
      return SizedBox(
        width: 300,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mainYellow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Athlete sessions will appear here',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: 0.5,
                        backgroundColor: Colors.black,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow[900]!),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '2/4 workouts completed',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  shrinkWrap: true,
                  itemCount: (data.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final leftIndex = index * 2;
                    final rightIndex = leftIndex + 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.successGreen,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 0.75),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  data[leftIndex],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              color: Colors.grey,
                              thickness: 2.0,
                              width: 10.0,
                            ),
                            rightIndex < 4
                                ? Column(
                                    children: [
                                      Container(
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          color: AppColors.errorRed,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 0.75),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        data[rightIndex],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (!showEmptySessionCard && athleteSessions.isEmpty) {
      return const Text("This athlete doesn't have any sessions yet.",
          style: TextStyle(fontSize: 18));
    } else {
      return const SizedBox();
    }
  }
}
