import 'package:be_elite/bloc/athlete/athlete_bloc.dart';
import 'package:be_elite/misc/Method_Classes/profile_screen_methods.dart';
import 'package:be_elite/models/Athlete/athlete_details_dto/athlete_details_dto.dart';
import 'package:be_elite/models/Program/invite_dto.dart';
import 'package:be_elite/repositories/athlete/athlete_repository.dart';
import 'package:be_elite/repositories/athlete/athlete_repository_impl.dart';
import 'package:be_elite/styles/app_colors.dart';
import 'package:be_elite/ui/athlete/profile/athlete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthleteInvitesScreen extends StatefulWidget {
  final AthleteDetailsDto athleteDetails;
  const AthleteInvitesScreen({super.key, required this.athleteDetails});

  @override
  State<AthleteInvitesScreen> createState() => _AthleteInvitesScreenState();
}

class _AthleteInvitesScreenState extends State<AthleteInvitesScreen> {
  late AthleteBloc _athleteBloc;
  late AthleteRepository athleteRepository;

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
    return Column(children: [
      BlocConsumer<AthleteBloc, AthleteState>(
        listener: (context, state) {
          if (state is ManageInvitationSuccessState &&
              widget.athleteDetails.invites != null &&
              widget.athleteDetails.invites!.isNotEmpty) {
            for (int i = 0; i < widget.athleteDetails.invites!.length; i++) {
              if (widget.athleteDetails.invites![i].inviteId ==
                  state.invite.inviteId) {
                setState(() {
                  widget.athleteDetails.invites![i] = state.invite;
                });
              }
            }
          }
        },
        builder: (context, state) {
          return _buildPendingInvitesPage();
        },
      )
    ]);
  }

  Widget _buildPendingInvitesPage() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16, // Adjust spacing between columns if necessary
              columns: const [
                DataColumn(label: Text('Program')),
                DataColumn(label: Text('Coach')),
                DataColumn(label: Text('Invitation Status'))
              ],
              rows: widget.athleteDetails.invites!.isEmpty
                  ? [
                      const DataRow(cells: [
                        DataCell(Text("")),
                        DataCell(Text('Nothing here, yet!')),
                        DataCell(Text(""))
                      ])
                    ]
                  : widget.athleteDetails.invites!.map((invite) {
                      return DataRow(cells: [
                        DataCell(Text(invite.programName!)),
                        DataCell(Text(invite.coachName!)),
                        DataCell(invite.status == 'PENDING'
                            ? Row(
                                children: [
                                  _button('Accept', "ACCEPTED",
                                      AppColors.mainYellow, invite),
                                  _button('Reject', "REJECTED",
                                      AppColors.errorRed, invite),
                                ],
                              )
                            : Text(invite.status!)),
                      ]);
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, String status, Color? color, InviteDto invite) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(
        onPressed: () {
          if (widget.athleteDetails.program != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Show dialog
                  return AlertDialog(
                    title: const Text('Error',
                        style: TextStyle(color: Colors.white)),
                    content: const Text(
                        'Cannot join since you are already in a prorgam.',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: AppColors.errorRed,
                  );
                },
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AthleteProfileScreen(athleteDetails: widget.athleteDetails)),
                );
              });
            });
          }else{
            invite.status = status;
          _athleteBloc.add(ManageInviteEvent(invite));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          fixedSize: const Size(75, 25),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          maxLines: 1,
        ),
      ),
    );
  }
}
