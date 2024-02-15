// import 'package:flutter/material.dart';
// import 'package:maps_marker/services/gazole_station.dart';

// class GazoleUpdateScreen extends StatefulWidget {
//   final Gazole gazole;

//   GazoleUpdateScreen({required this.gazole});

//   @override
//   _GazoleUpdateScreenState createState() => _GazoleUpdateScreenState();
// }

// class _GazoleUpdateScreenState extends State<GazoleUpdateScreen> {
//   TextEditingController essanceController = TextEditingController();
//   TextEditingController premiumController = TextEditingController();
//   TextEditingController disselController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     essanceController.text = widget.gazole.essance?.toString() ?? "";
//     premiumController.text = widget.gazole.premium?.toString() ?? "";
//     disselController.text = widget.gazole.dissel?.toString() ?? "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Update Gazole - ID: ${widget.gazole.id}"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: essanceController,
//               decoration: InputDecoration(labelText: "Essence"),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: premiumController,
//               decoration: InputDecoration(labelText: "Premium"),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: disselController,
//               decoration: InputDecoration(labelText: "Diesel"),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _updateOrCreateGazole();
//               },
//               child: Text("Update or Create Gazole"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateOrCreateGazole() async {
//     try {
//       double? updatedEssence = double.tryParse(essanceController.text);
//       double? updatedPremium = double.tryParse(premiumController.text);
//       double? updatedDiesel = double.tryParse(disselController.text);

//       Gazole updatedGazole = Gazole(
//         id: widget.gazole.id,
//         essance: updatedEssence,
//         premium: updatedPremium,
//         dissel: updatedDiesel,
//         stationId: widget.gazole.stationId,
//       );

//       if (updatedEssence != null ||
//           updatedPremium != null ||
//           updatedDiesel != null) {
//         // Only update if any of the values are non-null
//         await GazoleStation().updateGazole(updatedGazole);
//       } else {
//         // If all values are null, create a new gazole
//         await GazoleStation().createGazole(updatedGazole);
//       }

//       Navigator.pop(context); // Close the update screen after updating
//     } catch (e) {
//       print("Error updating/creating gazole: $e");
//     }
//   }
// }
