import 'package:be_elite/bloc/program/program_bloc.dart';
import 'package:be_elite/bloc/week/week_bloc.dart';
import 'package:be_elite/models/Coach/coach_details.dart';
import 'package:be_elite/models/Coach/program_dto.dart';
import 'package:be_elite/models/Week/post_week_dto.dart';
import 'package:be_elite/ui/coach/coach_main_screen.dart';
import 'package:intl/intl.dart';
import 'package:be_elite/models/Week/week_dto.dart';
import 'package:be_elite/repositories/coach/coach_repository.dart';
import 'package:be_elite/repositories/coach/coach_repository_impl.dart';
import 'package:be_elite/repositories/program/program_repository.dart';
import 'package:be_elite/repositories/program/program_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/widgets/_weekDescriptionField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachAddWeekScreen extends StatefulWidget {
  final String programName;
  final WeekDto? weeksPage;
  final CoachDetails coachDetails;
  const CoachAddWeekScreen(
      {super.key,
      required this.programName,
      this.weeksPage,
      required this.coachDetails});

  @override
  State<CoachAddWeekScreen> createState() => CoachAddWeekScreenState();
}

class CoachAddWeekScreenState extends State<CoachAddWeekScreen> {
  final formKey = GlobalKey<FormState>();
  final weekNameTextController = TextEditingController();
  final weekDescriptionTextController = TextEditingController();

  DateTimeRange? _selectedDateRange;
  List<String> selectedDaysFormatted = [];
  // ignore: prefer_final_fields
  bool _dateRangeError = false;
  List<String> _suggestions = [];
  late CoachRepository coachRepository;
  late ProgramRepository programRepository;
  late WeekBloc _weekBloc;
  late ProgramBloc _programBloc;
  late String weekDescriptionValue;
  late ProgramDto programDto;

  @override
  void initState() {
    coachRepository = CoachRepositoryImpl();
    programRepository = ProgramRepositoryImpl();
    _weekBloc = WeekBloc(coachRepository);
    _programBloc = ProgramBloc(programRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider.value(value: _weekBloc),
      BlocProvider.value(value: _programBloc)
    ], child: _buildHome());
  }

  Widget _buildHome() {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.grey[800]!, Colors.grey[900]!],
          radius: 0.5,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<WeekBloc, WeekState>(
              buildWhen: (context, state) {
                return state is WeekLoadingState ||
                    state is WeekErrorState ||
                    state is WeekNamesSuccessState ||
                    state is SaveNewWeekSuccessState;
              },
              builder: (context, state) {
                if (state is WeekErrorState) {
                  return const Text(
                      'An error occured while saving the new week.');
                } else if (state is WeekLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeekSuccessState) {
                  return Container();
                } else if (state is SaveNewWeekSuccessState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Show dialog
                        return AlertDialog(
                          title: const Text('Success!',
                              style: TextStyle(color: Colors.white)),
                          content: const Text('New week has been created.',
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

                return _addWeekForm();
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ProgramBloc, ProgramState>(
              buildWhen: (context, state) {
                return state is GetProgramDtoSuccessState;
              },
              builder: (context, state) {
                if (state is GetProgramDtoSuccessState) {
                  DateTime now = DateTime.now();
                  String formattedDateTime =
                      DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

                  programDto = state.programDto;
                  _weekBloc.add(SaveNewWeekEvent(PostWeekDto(
                      createdAt: formattedDateTime,
                      weekName: weekNameTextController.text,
                      description: weekDescriptionValue,
                      program: programDto,
                      span: selectedDaysFormatted)));
                }
                return Container();
              },
            ),
          )
        ],
      ),
    ));
  }

  Widget _addWeekForm() {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Flexible(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  _weekNameField(),
                  const SizedBox(height: 30),
                  WeekDescriptionField(
                      weekNameTextController: weekNameTextController,
                      weekPage: widget.weeksPage,
                      handleWeekDescriptionChanged:
                          handleWeekDescriptionChanged),
                  const SizedBox(height: 30),
                  _weekPicker(),
                  const SizedBox(height: 30),
                  _saveButton(),
                ])),
          ],
        ));
  }

  Widget _weekNameField() {
    List<String> existingWeekNames = widget.weeksPage?.content != null
        ? List.from(extractWeekNames(widget.weeksPage!.content))
        : [];

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

  Widget _weekPicker() {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            child: const Text('Select Date Range'),
          ),
          _dateRangeError == false
              ? Container()
              : const Text('Please select a date range.',
                  style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Color(0xFFD6CD0B), blurRadius: 5)]),
      child: FilledButton(
        onPressed: () {
          if (selectedDaysFormatted.isEmpty) {
            setState(() {
              _dateRangeError = true;
            });
          }
          if (formKey.currentState!.validate() && _dateRangeError == false) {
            _programBloc.add(GetProgramDtoEvent(widget.programName));
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainYellow,
            fixedSize: const Size(200, 50),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)))),
        child: const Text(
          "Add new week",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  static Set<String> extractWeekNames(dynamic content) {
    Set<String> weekNames = {};
    if (content != null && content is List) {
      for (var item in content) {
        String? weekName = item.weekName;
        if (weekName != null) {
          weekNames.add(weekName);
        }
      }
    } else {
      return {};
    }
    return weekNames;
  }

  void handleWeekDescriptionChanged(String? weekDescription) {
    weekDescription != null
        ? weekDescriptionValue = weekDescription
        : weekDescriptionValue = "";
  }

  void _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 7)), // Initial range is 7 days
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: _selectedDateRange ?? initialDateRange,
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
        _dateRangeError = false;
      });

      // Extract individual days from the selected range
      DateTime currentDate = newDateRange.start;
      while (currentDate.isBefore(newDateRange.end) ||
          currentDate.isAtSameMomentAs(newDateRange.end)) {
        final formattedDate = DateFormat('yyyy-MM-dd')
            .format(currentDate); // Format to match Java's LocalDate format
        selectedDaysFormatted.add(formattedDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }
}
