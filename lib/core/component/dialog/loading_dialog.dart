import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    },
  );
}



// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'dart:math' as math;

// class showLoadingDialog extends StatefulWidget {
//   const showLoadingDialog({Key? key, required this.courseName})
//       : super(key: key);

//   final String courseName;

//   @override
//   State<showLoadingDialog> createState() => _CourseListItemPage();
// }

// class _CourseListItemPage extends State<showLoadingDialog> {
  // int downloadProgress = 0;

  // bool isDownloadStarted = false;

  // bool isDownloadFinish = false;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         title: Text(widget.courseName),
//         leading: CircleAvatar(
//           radius: 20,
//           backgroundColor:
//               Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
//                   .withOpacity(1.0),
//           child: Text(
//             widget.courseName.substring(0, 1),
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         trailing: Column(children: [
//           Visibility(
//               visible: isDownloadStarted,
//               child: CircularPercentIndicator(
//                 radius: 20.0,
//                 lineWidth: 3.0,
//                 percent: (downloadProgress / 100),
//                 center: Text(
//                   "$downloadProgress%",
//                   style: const TextStyle(fontSize: 12, color: Colors.blue),
//                 ),
//                 progressColor: Colors.blue,
//               )),
//           Visibility(
//               visible: !isDownloadStarted,
//               child: IconButton(
//                 icon: const Icon(Icons.download),
//                 color: isDownloadFinish ? Colors.green : Colors.grey,
//                 onPressed: downloadCourse,
//               ))
//         ]));
//   }

//   void downloadCourse() async {
//     isDownloadStarted = true;
//     isDownloadFinish = false;
//     downloadProgress = 0;
//     setState(() {});

//     //Download logic
//     while (downloadProgress < 100) {
//       // Get download progress
//       downloadProgress += 10;
//       setState(() {});
//       if (downloadProgress == 100) {
//         isDownloadFinish = true;
//         isDownloadStarted = false;
//         setState(() {});
//         break;
//       }
//       await Future.delayed(const Duration(milliseconds: 500));
//     }
//   }
// }
///anike anna chaiainda nee arrila salary kittitella andu chiyum anne arriela aa mothalaly vainkara kalipa annode anda nee arriela 
///eppo vicharikunu quit chataloo  nee pisha vara companile adukanam atha nee pade andavithi allapoo ethe thanaa pisha kill jan 
///quite chinilaa jamike noka athe shari