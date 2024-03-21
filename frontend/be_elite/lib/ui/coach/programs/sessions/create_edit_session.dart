import 'package:be_elite/bloc/session/session_bloc.dart';
import 'package:be_elite/misc/Method_Classes/edit_session_methods.dart';
import 'package:be_elite/models/Session/post_session_dto/post_block_dto.dart';
import 'package:be_elite/models/Session/post_session_dto/post_session_dto.dart';
import 'package:be_elite/models/Session/post_session_dto/post_set_dto.dart';
import 'package:be_elite/models/Week/content.dart';
import 'package:be_elite/repositories/session/session_repository.dart';
import 'package:be_elite/repositories/session/session_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CoachCreateOrEditSessionScreen extends StatefulWidget {
  final WeekContent week;
  final String coachUsername;
  final String programName;
  final String weekName;
  final int weekNumber;
  final int? sessionNumber;
  const CoachCreateOrEditSessionScreen(
      {super.key,
      required this.week,
      required this.coachUsername,
      required this.programName,
      required this.weekName,
      required this.weekNumber,
      this.sessionNumber});

  @override
  State<CoachCreateOrEditSessionScreen> createState() =>
      _CoachCreateOrEditSessionScreenState();
}

class _CoachCreateOrEditSessionScreenState
    extends State<CoachCreateOrEditSessionScreen> {
  final formKey = GlobalKey<FormState>();
  final editMethods = EditSessionMethods();

  //Session controllers
  final titleTextController = TextEditingController();
  final subtitleTextController = TextEditingController();

  //Block controllers
  List<TextEditingController> movementControllers = [];
  List<TextEditingController> blockInstructionsTextControllers = [];
  List<TextEditingController> restBetweenSetsTextControllers = [];

  //Set controllers
  List<TextEditingController> numberOfSetsTextControllers = [];
  List<TextEditingController> numberOfRepsTextControllers = [];
  List<TextEditingController> percentageTextControllers = [];

  List<String> blockLetters = ['A'];
  List<int> setsPerBlock = [1];
  // ignore: prefer_final_fields
  int _selectedDayIndex = 0;
  String? selectedDayString;
  int totalNumberOfSets = 0;
  String? uneditedDateString;

  late SessionBloc _sessionBloc;
  late SessionRepository sessionRepository;

  @override
  void initState() {
    sessionRepository = SessionRepositoryImpl();
    if (widget.sessionNumber != null && widget.sessionNumber! > 0) {
      _sessionBloc = SessionBloc(sessionRepository)
        ..add(GetPostSessionDtoEvent(widget.coachUsername, widget.weekName,
            widget.programName, widget.weekNumber, widget.sessionNumber!));
    } else {
      //I found this necessary to be able to load the controllers for an existing session before the form loads and throws errors.
      _sessionBloc = SessionBloc(sessionRepository)..add(LoadNewSessionEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.grey[800]!, Colors.grey[900]!],
              radius: 0.5,
            ),
          ),
          child: BlocProvider.value(
              value: _sessionBloc,
              child: BlocConsumer<SessionBloc, SessionState>(
                buildWhen: (context, state) {
                  return state is SessionErrorState ||
                      state is SessionLoadingState ||
                      state is SaveNewSessionSuccessState ||
                      state is GetPostSessionDtoSuccessState ||
                      state is LoadNewSessionSuccessState ||
                      state is SaveEditedSessionSuccessState;
                },
                builder: (context, state) {
                  if (state is SessionErrorState) {
                    return const Text('There was an error saving the session.');
                  } else if (state is SessionLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SaveNewSessionSuccessState ||
                      state is SaveEditedSessionSuccessState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success!',
                                style: TextStyle(color: Colors.white)),
                            content: state is SaveNewSessionSuccessState
                                ? const Text(
                                    'New session has been successfully created.',
                                    style: TextStyle(color: Colors.white))
                                : const Text(
                                    'Session has been successfully updated.',
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
                  } else if (state is GetPostSessionDtoSuccessState) {
                    return SingleChildScrollView(child: newSessionForm());
                  } else if (state is LoadNewSessionSuccessState) {
                    return SingleChildScrollView(child: newSessionForm());
                  }
                  return Container();
                },
                listenWhen: (context, state) =>
                    state is GetPostSessionDtoSuccessState ||
                    state is DeleteSessionSuccessState,
                listener: (context, state) {
                  if (state is GetPostSessionDtoSuccessState) {
                    setsPerBlock = editMethods.getSetsPerBlock(state.session);
                    blockLetters =
                        editMethods.setBlockLetters(state.session.blocks!);
                    editMethods.setSessionControllerValues(state.session,
                        titleTextController, subtitleTextController);
                    editMethods.setBlockAndSetControllerValues(
                        state.session,
                        movementControllers,
                        blockInstructionsTextControllers,
                        restBetweenSetsTextControllers,
                        numberOfSetsTextControllers,
                        numberOfRepsTextControllers,
                        percentageTextControllers);
                    _selectDay(editMethods.getDayIndex(
                        widget.week.span!, state.session.date!));
                    uneditedDateString = selectedDayString;
                  } else if (state is DeleteSessionSuccessState) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CoachMainScreen()));
                  }
                },
              ))),
    );
  }

  Widget newSessionForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(left: 50, right: 50),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Session inputs
              Center(
                child: widget.sessionNumber == null
                    ? const Text('New Session',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            fontStyle: FontStyle.italic))
                    : const Text('Edit Session',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 30),
              _sessionDayField(),
              const SizedBox(height: 30),
              _sessionTitleField(),
              const SizedBox(height: 30),
              _sessionSubtitleField(),
              const SizedBox(height: 30),

              //Block form, nested within are the set forms
              ...blockLetters.asMap().entries.map((entry) {
                int blockIndex = entry.key;
                String blockLetter = entry.value;
                return _newBlockForm(blockLetter, blockIndex);
              }).toList(),

              _addBlockButton(),
              const SizedBox(height: 30),
              widget.sessionNumber != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [_deleteSessionButton(), _saveSessionButton()],
                    )
                  : Align(
                      alignment: Alignment.center, child: _saveSessionButton()),
              const SizedBox(height: 30),
            ]),
      ),
    );
  }

  Widget _sessionDayField() {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          const Text('Session Date', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(widget.week.span?.length ?? 7, (index) {
                final dayName = _getDayName(index + 1);
                return OutlinedButton(
                  onPressed: () => _selectDay(index),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      return _selectedDayIndex == index
                          ? AppColors.mainYellow
                          : Colors.transparent;
                    }),
                    foregroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      return _selectedDayIndex == index
                          ? Colors.black
                          : Colors.white;
                    }),
                    overlayColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      return _selectedDayIndex == index
                          ? AppColors.mainYellow.withOpacity(0.5)
                          : Colors.white10;
                    }),
                    side:
                        MaterialStateProperty.resolveWith<BorderSide>((states) {
                      return BorderSide(
                        color: _selectedDayIndex == index
                            ? Colors.black
                            : Colors.white,
                      );
                    }),
                  ),
                  child: Column(children: [
                    Text(dayName),
                    Text(widget.week.span?[index],
                        style: const TextStyle(fontSize: 10))
                  ]),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionTitleField() {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextFormField(
            controller: titleTextController,
            decoration: const InputDecoration(
              hintText: 'Session title',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white54), // Underline color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // Focused underline color
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Session title cannot be empty';
              } else if (value.length > 20) {
                return 'Cannot be more than 20 characters long';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _sessionSubtitleField() {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextFormField(
            maxLines: 3,
            controller: subtitleTextController,
            decoration: const InputDecoration(
              hintText: 'Session subtitle',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white54), // Underline color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // Focused underline color
              ),
            ),
            validator: (value) {
              if (value != null && value.length > 100) {
                return 'Cannot exceed 100 characters';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _newBlockForm(String blockLetter, int blockIndex) {
    List<Widget> setForms = [];
    int setsBeforeIndexed = 0;

    //Gets the amount of sets before the new block being created
    for (int i = 0; i < blockIndex; i++) {
      setsBeforeIndexed += setsPerBlock[i];
    }

    for (int i = 1; i <= setsPerBlock[blockIndex]; i++) {
      setForms.add(_newSetForm(i, setsBeforeIndexed + i - 1));
    }

    // Create controllers for each block form if its a new session, or if user requests a new block in an existing session
    if (widget.sessionNumber == null ||
        movementControllers.length < blockLetters.length) {
      for (int i = 0; i < blockLetters.length; i++) {
        movementControllers.add(TextEditingController());
        blockInstructionsTextControllers.add(TextEditingController());
        restBetweenSetsTextControllers.add(TextEditingController());
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //Can try to wrap with unconstrainedBox widget here
      Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[700],
          child: Text('Block $blockLetter',
              style:
                  const TextStyle(fontSize: 24, fontStyle: FontStyle.italic))),
      _blockMovementField(movementControllers[blockIndex]),
      const SizedBox(height: 30),
      ...setForms,
      const SizedBox(height: 30),
      setsPerBlock[blockIndex] > 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _deleteSetButton(blockIndex),
                _addSetButton(blockIndex)
              ],
            )
          : Align(
              alignment: Alignment.center, child: _addSetButton(blockIndex)),
      const SizedBox(height: 30),
      _blockRestField(restBetweenSetsTextControllers[blockIndex]),
      const SizedBox(height: 30),
      _blockInstructionsField(blockInstructionsTextControllers[blockIndex]),
      const SizedBox(height: 30),
    ]);
  }

  Widget _blockMovementField(TextEditingController movementTextController) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextFormField(
            controller: movementTextController,
            decoration: const InputDecoration(
              hintText: 'Movement(s)',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white54), // Underline color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // Focused underline color
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Block must have a movement.';
              } else if (value.length > 100) {
                return 'Cannot be more than 100 characters long.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _blockInstructionsField(
      TextEditingController blockInstructionsTextController) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextFormField(
            maxLines: 3,
            controller: blockInstructionsTextController,
            decoration: const InputDecoration(
              hintText: 'Specific instructions for this block.',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white54), // Underline color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // Focused underline color
              ),
            ),
            validator: (value) {
              if (value != null && value.length > 100) {
                return 'Cannot be more than 100 characters long.';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _newSetForm(int setNumber, int totalSetIndex) {
    // Create controllers for each new set form
    if (setNumber > numberOfSetsTextControllers.length) {
      numberOfSetsTextControllers.add(TextEditingController());
      numberOfRepsTextControllers.add(TextEditingController());
      percentageTextControllers.add(TextEditingController());
    }

    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Set #$setNumber', style: const TextStyle(fontSize: 16)),
              _numberOfSetsField(numberOfSetsTextControllers[totalSetIndex]),
              const Text('x', style: TextStyle(fontSize: 20)),
              _numberOfRepsField(numberOfRepsTextControllers[totalSetIndex]),
              _percentageField(percentageTextControllers[totalSetIndex])
            ],
          ),
        ],
      ),
    );
  }

  Widget _numberOfSetsField(TextEditingController numberOfSetsTextController) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: numberOfSetsTextController,
        decoration: const InputDecoration(
          labelText: 'Sets',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54), // Underline color
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Focused underline color
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Obligatory';
          }
          return null;
        },
      ),
    );
  }

  Widget _numberOfRepsField(TextEditingController numberOfRepsTextController) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: numberOfRepsTextController,
        decoration: const InputDecoration(
          labelText: 'Reps',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54), // Underline color
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Focused underline color
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter number of reps';
          }
          return null;
        },
      ),
    );
  }

  Widget _percentageField(TextEditingController percentageTextController) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: percentageTextController,
        decoration: const InputDecoration(
            labelText: '%',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            )),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Obligatory';
          }
          return null;
        },
      ),
    );
  }

  Widget _addSetButton(int blockIndex) {
    return GestureDetector(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Add set',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          setsPerBlock[blockIndex] += 1;
        });
      },
    );
  }

  Widget _deleteSetButton(int blockIndex) {
    return GestureDetector(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_circle_outline, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Remove set',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          numberOfSetsTextControllers
              .removeAt(numberOfSetsTextControllers.length - 1);
          numberOfRepsTextControllers
              .removeAt(numberOfRepsTextControllers.length - 1);
          percentageTextControllers
              .removeAt(percentageTextControllers.length - 1);
          setsPerBlock[blockIndex] -= 1;
        });
      },
    );
  }

  Widget _blockRestField(TextEditingController restBetweenSetsTextController) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: restBetweenSetsTextController,
            decoration: const InputDecoration(
              hintText: 'Rest (Seconds)',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white54), // Underline color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // Focused underline color
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value != null && value.length > 3) {
                return 'Maximum allowed rest is 999';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _addBlockButton() {
    return GestureDetector(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Add block',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          if (blockLetters.isEmpty) {
            blockLetters.add('A');
            setsPerBlock.add(1);
          } else {
            blockLetters
                .add(String.fromCharCode(blockLetters.last.codeUnitAt(0) + 1));
            setsPerBlock.add(1);
          }
        });
      },
    );
  }

  Widget _saveSessionButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            //Gets data from block forms and puts it into a list
            List<PostBlockDto> blocks = List.generate(
                blockLetters.length,
                (blockIndex) => PostBlockDto(
                    blockInstructions:
                        blockInstructionsTextControllers[blockIndex].text,
                    blockNumber: blockIndex + 1,
                    movement: movementControllers[blockIndex].text,
                    restBetweenSets: restBetweenSetsTextControllers[blockIndex]
                            .text
                            .isEmpty
                        ? 0
                        : int.parse(
                            restBetweenSetsTextControllers[blockIndex].text),
                    sets:
                        //Gets data from sets forms and puts it into a list
                        List.generate(
                            setsPerBlock[blockIndex],
                            (setIndex) => PostSetDto(
                                numberOfReps: int.parse(numberOfRepsTextControllers[
                                        _getSetTextControllerIndex(
                                            blockIndex, setIndex)]
                                    .text),
                                numberOfSets: int.parse(
                                    numberOfSetsTextControllers[_getSetTextControllerIndex(blockIndex, setIndex)]
                                        .text),
                                percentage: int.parse(percentageTextControllers[_getSetTextControllerIndex(blockIndex, setIndex)].text),
                                setNumber: setIndex + 1))));

            if (widget.sessionNumber != null) {
              _sessionBloc.add(SaveEditedSessionEvent(
                  PostSessionDto(
                      blocks: blocks,
                      date: selectedDayString ?? widget.week.span!.first,
                      title: titleTextController.text,
                      subtitle: subtitleTextController.text,
                      sessionNumber: widget.sessionNumber,
                      sameDaySessionNumber: getSameDaySessionNumber(
                          selectedDayString ?? widget.week.span!.first)),
                  widget.week.weekName!,
                  widget.week.weekNumber!,
                  widget.programName,
                  widget.coachUsername));
            } else {
              _sessionBloc.add(SaveNewSessionEvent(
                  PostSessionDto(
                      blocks: blocks,
                      date: selectedDayString ?? widget.week.span!.first,
                      title: titleTextController.text,
                      subtitle: subtitleTextController.text,
                      sessionNumber: getSessionNumber(),
                      sameDaySessionNumber: getSameDaySessionNumber(
                          selectedDayString ?? widget.week.span!.first)),
                  widget.week.weekName!,
                  widget.week.weekNumber!,
                  widget.programName,
                  widget.coachUsername));
            }
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            fixedSize: const Size(150, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
        child: const Text(
          "Save",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Widget _deleteSessionButton() {
    return OutlinedButton(
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Warning!',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                content:
                    const Text('Are you sure you want to delete this session?'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No',
                              style: TextStyle(color: Colors.white))),
                      TextButton(
                          onPressed: () {
                            _sessionBloc.add(DeleteSessionEvent(
                                widget.coachUsername,
                                widget.weekName,
                                widget.programName,
                                widget.weekNumber,
                                widget.sessionNumber!));
                          },
                          child: const Text('Yes',
                              style: TextStyle(color: Colors.white))),
                    ],
                  )
                ],
                backgroundColor: AppColors.errorRed,
              );
            },
          );
        });
      },
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(150, 50)),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
          side: MaterialStateProperty.all(
              const BorderSide(width: 2, color: Colors.white54))),
      child: const Text(
        "Delete",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  void _selectDay(int dayIndex) {
    setState(() {
      _selectedDayIndex = dayIndex;
      selectedDayString = widget.week.span![dayIndex];
    });
  }

  String _getDayName(int dayIndex) {
    if (widget.week.span != null && widget.week.span!.isNotEmpty) {
      DateTime date = DateTime.parse(widget.week.span![dayIndex - 1]);

      return DateFormat('EEEE').format(date);
    } else {
      switch (dayIndex) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3:
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        case 7:
          return 'Sunday';
        default:
          return '';
      }
    }
  }

  //Sums up the numbers in a list of integers, used to get total number of sets
  int getSumOfNumbers(List<int>? numbers) {
    if (numbers == null) return 0;
    return numbers.fold(
        0, (int previousValue, int element) => previousValue + element);
  }

  int getSessionNumber() {
    if (widget.week.sessions != null) {
      return widget.week.sessions!.length + 1;
    }
    return 1;
  }

  int getSameDaySessionNumber(String dateString) {
    int sameDaySessionNumber = 1;
    if (widget.week.sessions == null) {
      return sameDaySessionNumber;
    }

    for (var session in widget.week.sessions!) {
      if (session.date!.toLowerCase() == dateString.toLowerCase()) {
        sameDaySessionNumber++;
      }
    }

    if (widget.sessionNumber != null &&
        uneditedDateString != null &&
        uneditedDateString!.toLowerCase() == dateString.toLowerCase()) {
      return sameDaySessionNumber - 1;
    }
    return sameDaySessionNumber;
  }

  int _getSetTextControllerIndex(int blockIndex, int setIndex) {
    int savedSets = 0;
    for (int i = 0; i < blockIndex; i++) {
      savedSets += setsPerBlock[i];
    }
    return savedSets + setIndex;
  }
}
