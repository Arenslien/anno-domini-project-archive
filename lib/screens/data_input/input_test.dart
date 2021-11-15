// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class InputScreen extends StatefulWidget {
//   const InputScreen({Key? key}) : super(key: key);

//   @override
//   _InputScreenState createState() => _InputScreenState();
// }

// class _InputScreenState extends State<InputScreen> {
//   TextEditingController searchTextEditingController = TextEditingController();

//   late Future<QuerySnapshot> futureSearchResults;

//   controlSearching(str) {
//     print(str);
//     // Future<QuerySnapshot> allUsers =
//     //     useReference.where('profileName', isGreaterThanOrEqualTo: str).get();
//     // setState(() {
//     //   futureSearchResults = allUsers;
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: searchPageHeader(),
//       body: futureSearchResults == null
//           ? displayNoSearchResultScreen()
//           : displayUsersFoundScreen(),
//     );
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     title: Text('아동 관리'),
//     //   ),
//     //   body: Padding(
//     //     padding: const EdgeInsets.all(8.0),
//     //     child: Column(
//     //       children: [
//     //         TextField(
//     //           decoration: InputDecoration(
//     //             border: OutlineInputBorder(),
//     //             labelText: '아동 검색',
//     //           ),
//     //           onChanged: (String str) {
//     //             setState(() => a = str);
//     //           },
//     //         ),
//     //         SizedBox(
//     //           height: 10,
//     //         ),
//     //         Text(a),
//     //         // ListView(
//     //         //   children: [
//     //         //     Container(
//     //         //       child: Text(a),
//     //         //     ),
//     //         //   ],
//     //         // ),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }

//   AppBar searchPageHeader() {
//     return AppBar(
//       title: TextFormField(
//         controller: searchTextEditingController,
//         decoration: InputDecoration(
//           hintText: 'Search here...',
//           hintStyle: TextStyle(color: Colors.grey),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           filled: true,
//           prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30),
//           suffixIcon: IconButton(
//             icon: Icon(Icons.clear, color: Colors.white),
//             onPressed: () {
//               searchTextEditingController.clear();
//             },
//           ),
//         ),
//         style: TextStyle(fontSize: 18, color: Colors.white),
//         onFieldSubmitted: controlSearching,
//       ),
//     );
//   }

//   displayNoSearchResultScreen() {
//     final Orientation orientation = MediaQuery.of(context).orientation;
//     return Container(
//       child: Center(
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//             Icon(
//               Icons.group,
//               color: Colors.grey,
//               size: 150,
//             ),
//             Text(
//               'Search Users',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 40),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   displayUsersFoundScreen() {
//     // return FutureBuilder(
//     //   future: futureSearchResults,
//     //   builder: (context, snapshot) {
//     //     if (!snapshot.hasData) {
//     //       return circularProgress();
//     //     }

//     //     List<UserResult> searchUserResult = [];
//     //     snapshot.data.documents.forEach((document) {
//     //       User users = User.fromDocument(document);
//     //       UserResult userResult = UserResult(users);
//     //       searchUserResult.add(userResult);
//     //     });

//     //     return ListView(children: searchUserResult);
//     //   },
//     // );
//   }
// }

// // class UserResultState extends StatelessWidget {
// //   late final User eachUser;
// //   UserResult(this.eachUser);
  
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.all(3),
// //       child: Container(
// //         color: Colors.white54,
// //         child: Column(
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 print('tapped');
// //               },
// //               child: ListTile(
// //                 leading: CircleAvatar(
// //                   backgroundColor: Colors.black,
// //                   backgroundImage: eachUser.url == null 
// //                   ? circularProgress() 
// //                   : CachedNetworkImageProvider(eachUser.url),
// //                 ),
// //                 title: Text(eachUser.por),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
