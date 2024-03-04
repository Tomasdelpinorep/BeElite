import 'package:be_elite/bloc/week/week_bloc.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachAddWeekScreen extends StatefulWidget {
  final String programName;
  const CoachAddWeekScreen({super.key, required this.programName});

  @override
  State<CoachAddWeekScreen> createState() => _CoachAddWeekScreenState();
}

class _CoachAddWeekScreenState extends State<CoachAddWeekScreen> {
  final formKey = GlobalKey<FormState>();
  final weekNameTextController = TextEditingController();
  final weekDescriptionTextController = TextEditingController();
  late List<String> existingWeekNames = ['Week 1', 'Week 2', 'Week 3'];
  List<String> _suggestions = [];

  late CoachRepository coachRepository;
  late WeekBloc _weekBloc;

  @override
  void initState() {
    coachRepository = CoachRepositoryImpl();
    _weekBloc = WeekBloc(coachRepository);
    existingWeekNames = coachRepository.getWeekNames(widget.programName);
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
                return state is WeekLoadingState || state is WeekErrorState;
              },
              builder: (context, state) {
                if (state is WeekErrorState) {
                  return const Text(
                      'An error occured while saving the new week.');
                } else if (state is WeekLoadingState) {
                  return const Center(child: CircularProgressIndicator());
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
                  _weekDescriptionField(),
                  const SizedBox(height: 30),
                  // _saveButton(),
                ])),
          ],
        ));
  }

  Widget _weekNameField() {
    _suggestions == existingWeekNames;

    return SizedBox(
      width: 400,
      child: Column(
        children: [
          TextField(
            controller: weekNameTextController,
            onChanged: (weekName) {
              setState(() {
                _suggestions = existingWeekNames
                    .where((existingWeekName) =>
                        existingWeekName.toLowerCase().contains(weekName.toLowerCase()))
                    .toList();
              });
            },
            decoration: const InputDecoration(labelText: 'Week Name'),
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
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: weekDescriptionTextController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: "Username",
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54), // Underline color
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Focused underline color
            ),
            prefixIcon: const Icon(Icons.person),
            prefixIconColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.focused)
                    ? Colors.white
                    : Colors.white54)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username cannot be empty.';
          }
          return null;
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
}
