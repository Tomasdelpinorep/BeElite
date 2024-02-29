// import 'package:be_elite/models/auth/login_response.dart';
// import 'package:be_elite/widgets/beElite_logo.dart';
// import 'package:be_elite/widgets/circular_avatar.dart';
// import 'package:flutter/material.dart';

// class ProgramsScreen extends StatefulWidget {
//   final CoachDetails coachDetails;
//   const ProgramsScreen({super.key, required this.userLogin});

//   @override
//   State<ProgramsScreen> createState() => _ProgramsScreenState();
// }

// class _ProgramsScreenState extends State<ProgramsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           height: 50,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround, 
//             children: [
//             CircularProfileAvatar(
//                 imageUrl: widget.userLogin.profilePicUrl ??
//                     'https://i.imgur.com/jNNT4LE.png'),
//             _programSelectorWidget(),
//             const BeEliteLogo()
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget _programSelectorWidget() {
//     return const Text('In progress');
//   }
// }
