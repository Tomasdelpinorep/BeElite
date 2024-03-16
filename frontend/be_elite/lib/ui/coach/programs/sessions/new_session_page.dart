import 'package:be_elite/bloc/session/session_bloc.dart';
import 'package:be_elite/models/Week/content.dart';
import 'package:be_elite/repositories/session/session_repository.dart';
import 'package:be_elite/repositories/session/session_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachNewSessionScreen extends StatefulWidget {
  final WeekContent week;
  const CoachNewSessionScreen({super.key, required this.week});

  @override
  State<CoachNewSessionScreen> createState() => _CoachNewSessionScreenState();
}

class _CoachNewSessionScreenState extends State<CoachNewSessionScreen> {
  final formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  final subtitleTextController = TextEditingController();
  final movementTextController = TextEditingController();
  final blockInstructionsTextController = TextEditingController();
  final restBetweenSetsTextController = TextEditingController();
  final setNumberTextController = TextEditingController();
  final numberOfSetsTextController = TextEditingController();
  final numberOfRepsTextController = TextEditingController();
  final percentageTextController = TextEditingController();

  List<String> blockLetters = ['A'];
  List<int> setsPerBlock = [1];

  late SessionBloc _sessionBloc;
  late SessionRepository sessionRepository;

  @override
  void initState() {
    sessionRepository = SessionRepositoryImpl();
    _sessionBloc = SessionBloc(sessionRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.grey[800]!, Colors.grey[900]!],
              radius: 0.5,
            ),
          ),
          child: BlocProvider.value(
              value: _sessionBloc,
              child: BlocBuilder<SessionBloc, SessionState>(
                buildWhen: (context, state) {
                  return state is SessionErrorState ||
                      state is SessionLoadingState ||
                      state is SaveNewSessionSuccessState;
                },
                builder: (context, state) {
                  if (state is SessionErrorState) {
                    return const Text('There was an error saving the session.');
                  } else if (state is SessionLoadingState) {
                    return const CircularProgressIndicator();
                  } else if (state is SaveNewSessionSuccessState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success!',
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                                'New program has been successfully created.',
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
                  }
                  return SingleChildScrollView(child: _newSessionForm());
                },
              ))),
    );
  }

  Widget _newSessionForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(left: 50, right: 50),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Session inputs
              const Text('New Session',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontStyle: FontStyle.italic)),
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
              _saveSessionButton(),
              const SizedBox(height: 30),
            ]),
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
    for (int i = 1; i <= setsPerBlock[blockIndex]; i++) {
      setForms.add(_newSetForm(i));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //Can try to wrap with unconstrainedBox widget here
      Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[700],
          child: Text('Block $blockLetter',
              style:
                  const TextStyle(fontSize: 24, fontStyle: FontStyle.italic))),
      _blockMovementField(),
      const SizedBox(height: 30),
      ...setForms,
      const SizedBox(height: 30),
      _addSetButton(blockIndex),
      const SizedBox(height: 30),
      _blockRestField(),
      const SizedBox(height: 30),
      _blockInstructionsField(),
      const SizedBox(height: 30),
    ]);
  }

  Widget _blockMovementField() {
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

  Widget _blockInstructionsField() {
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

  Widget _newSetForm(int setNumber) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Set #$setNumber', style: const TextStyle(fontSize: 16)),
              _numberOfSetsField(),
              const Text('x', style: TextStyle(fontSize: 20)),
              _numberOfRepsField(),
              _percentageField()
            ],
          ),
        ],
      ),
    );
  }

  Widget _numberOfSetsField() {
    return SizedBox(
      width: 50,
      child: TextFormField(
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

  Widget _numberOfRepsField() {
    return SizedBox(
      width: 50,
      child: TextFormField(
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

  Widget _percentageField() {
    return SizedBox(
      width: 50,
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: '%',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            )),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

  Widget _blockRestField() {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: titleTextController,
            decoration: const InputDecoration(
              hintText: 'Rest',
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
          blockLetters
              .add(String.fromCharCode(blockLetters.last.codeUnitAt(0) + 1));
          setsPerBlock.add(1);
        });
      },
    );
  }

  Widget _saveSessionButton() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
        child: FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              //save logic
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainYellow,
              fixedSize: const Size(200, 50),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
          child: const Text(
            "Save Session",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
