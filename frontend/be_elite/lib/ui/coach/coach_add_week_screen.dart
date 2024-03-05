import 'package:be_elite/bloc/week/week_bloc.dart';
import 'package:be_elite/models/Week/content.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
import 'package:be_elite/widgets/_weekDescriptionField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachAddWeekScreen extends StatefulWidget {
  final String programName;
  final WeekDto weeksPage;
  const CoachAddWeekScreen(
      {super.key, required this.programName, required this.weeksPage});

  @override
  State<CoachAddWeekScreen> createState() => _CoachAddWeekScreenState();
}

class _CoachAddWeekScreenState extends State<CoachAddWeekScreen> {
  final formKey = GlobalKey<FormState>();
  final weekNameTextController = TextEditingController();
  final weekDescriptionTextController = TextEditingController();

  List<String> _suggestions = [];
  late CoachRepository coachRepository;
  late WeekBloc _weekBloc;

  @override
  void initState() {
    coachRepository = CoachRepositoryImpl();
    _weekBloc = WeekBloc(coachRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.grey[900]!, Colors.black],
              radius: 0.5,
            ),
          ),
          child: BlocProvider.value(
            value: _weekBloc,
            child: BlocConsumer<WeekBloc, WeekState>(
              buildWhen: (context, state) {
                return state is WeekLoadingState ||
                    state is WeekErrorState ||
                    state is WeekNamesSuccessState;
              },
              builder: (context, state) {
                if (state is WeekErrorState) {
                  return const Text(
                      'An error occured while saving the new week.');
                } else if (state is WeekLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeekSuccessState) {
                  return const Placeholder();
                }

                return _addWeekForm();
              },
              listenWhen: (context, state) {
                return state is WeekSuccessState;
              },
              listener: (context, state) {
                if (state is WeekSuccessState) {
                  //Navigate back to programs page
                }
              },
            ),
          )),
    );
  }

  Widget _addWeekForm() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  _weekNameField(),
                  const SizedBox(height: 30),
                  WeekDescriptionField(weekNameTextController: weekNameTextController, weekPage: widget.weeksPage),
                  const SizedBox(height: 30),
                  // _saveButton(),
                ])),
          ],
        ));
  }

  Widget _weekNameField() {
    List<String> existingWeekNames =
        List.from(extractWeekNames(widget.weeksPage.content!));

    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextField(
            controller: weekNameTextController,
            onTap: () {
              if (weekNameTextController.value.text.isEmpty) {
                setState(() {
                  _suggestions = existingWeekNames;
                });
              }
            },
            onChanged: (weekName) {
              setState(() {
                _suggestions = existingWeekNames
                    .where((existingWeekName) => existingWeekName
                        .toLowerCase()
                        .contains(weekName.toLowerCase()))
                    .toList();
              });
            },
            decoration: const InputDecoration(
              hintText: "Week Name",
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
          ),
          const SizedBox(height: 10),
          _suggestions.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestions[index]),
                      onTap: () {
                        weekNameTextController.text = _suggestions[index];
                        setState(() {
                          _suggestions.clear();
                        });
                      },
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _weekDescriptionField() {
    String? weekDescription;
    weekNameTextController.addListener(() {
      String currentWeekName = weekNameTextController.text;

      Content? matchingWeek = widget.weeksPage.content?.firstWhere(
        (week) => week.weekName == currentWeekName,
      );
        weekDescription = matchingWeek?.description;
        print(weekDescription);
    });

    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: weekDescriptionTextController,
        initialValue: weekDescription,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText:
              weekDescription == null ? 'Week Description' : weekDescription!,
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Week description cannot be empty.';
          }
          return null;
        },
        onChanged: (value) {
          // Handle onChanged if needed
        },
      ),
    );
  }

  // Widget _saveButton() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //         boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
  //     child: FilledButton(
  //       onPressed: () {
  //         if (formKey.currentState!.validate()) {
  //           _loginBloc.add(DoLoginEvent(
  //               password: passwordTextController.text,
  //               username: usernameTextController.text));
  //         }
  //       },
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: AppColors.mainYellow,
  //           fixedSize: const Size(150, 50),
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
  //       child: const Text(
  //         "Login",
  //         style: TextStyle(
  //             color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
  //       ),
  //     ),
  //   );
  // }

  Set<String> extractWeekNames(dynamic content) {
    Set<String> weekNames = {};
    if (content != null && content is List) {
      for (var item in content) {
        String? weekName = item.weekName;
        if (weekName != null) {
          weekNames.add(weekName);
        }
      }
    }
    return weekNames;
  }
}
