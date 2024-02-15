import 'package:flutter/material.dart';
import 'package:maps_marker/screens/Widget/bezierContainer.dart';
import 'package:maps_marker/services/gazole_station.dart';
import 'package:maps_marker/services/services_station.dart';

class DetailsStation extends StatefulWidget {
  final String stationId;
  final String nameId;

  const DetailsStation(
      {Key? key, required this.stationId, required this.nameId})
      : super(key: key);

  @override
  State<DetailsStation> createState() => _DetailsStationState();
}

class _DetailsStationState extends State<DetailsStation> {
  String selectedService = ''; // Garde une trace du service sélectionné
  final ServiceStaionGazole serviceStation = ServiceStaionGazole();
  final GazoleStation gazoleStation = GazoleStation();
  int? selectedServiceId;
  bool isLoading = true;
  List<Service> stationServicesWashing = [];
  List<Service> stationServicesRestaurant = [];
  List<Service> stationServicesPlayground = [];
  List<Gazole> gazoleById = [];
  @override
  void initState() {
    super.initState();
    _fetchGazoles();
    loadStationServicesRestaurant();
    loadStationServicesWashing();
    loadStationServicesPlayground();
  }

  Future<void> _fetchGazoles() async {
    try {
      List<Gazole> fetchedGazoles =
          await GazoleStation().getGazoles(stationId: widget.stationId);
      setState(() {
        gazoleById = fetchedGazoles;
      });
    } catch (e) {
      // Handle error
      print("Error fetching gazoles: $e");
    }
  }
  // void loadStationGaoles() {
  //   gazoleStation.getGazoles(stationId: widget.stationId).then((gazoles) {
  //     setState(() {
  //       gazoleList = gazoles;
  //       print(gazoleList);
  //       isLoading = false; // Indiquer que le chargement est terminé
  //     });
  //   }).catchError((error) {
  //     print('Error loading gazoles : $error');
  //     isLoading =
  //         false; // Indiquer que le chargement est terminé même en cas d'erreur
  //   });
  // }

  void loadStationServicesWashing() {
    serviceStation
        .getServicesByType(stationId: widget.stationId, typeService: "Washing")
        .then((services) {
      setState(() {
        stationServicesWashing = services;
        isLoading = false; // Indiquer que le chargement est terminé
      });
    }).catchError((error) {
      print('Error loading station services Washing : $error');
      isLoading =
          false; // Indiquer que le chargement est terminé même en cas d'erreur
    });
  }

  void loadStationServicesRestaurant() {
    serviceStation
        .getServicesByType(
            stationId: widget.stationId, typeService: "Restaurant")
        .then((services) {
      setState(() {
        stationServicesRestaurant = services;
        isLoading = false; // Indiquer que le chargement est terminé
      });
    }).catchError((error) {
      print('Error loading station services Restaurant: $error');
      isLoading =
          false; // Indiquer que le chargement est terminé même en cas d'erreur
    });
  }

  void loadStationServicesPlayground() {
    serviceStation
        .getServicesByType(
            stationId: widget.stationId, typeService: "Playground")
        .then((services) {
      setState(() {
        stationServicesPlayground = services;
        isLoading = false; // Indiquer que le chargement est terminé
      });
    }).catchError((error) {
      print('Error loading station services Playground: $error');
      isLoading =
          false; // Indiquer que le chargement est terminé même en cas d'erreur
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // Create the Text widget outside of the AppBar title property
    Text appBarTitle = Text(
      widget.nameId,
      style: TextStyle(
        color: Colors.white, // Set text color to white
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle, // Use the created Text widget here

        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffe46b10),
                Color(0xfffbb448),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              right: -MediaQuery.of(context).size.width * 0.7,
              left: MediaQuery.of(context).size.height * 0.2,
              // width: -MediaQuery.of(context).size.width * 0.7,
              child: const BezierContainer(),
            ),
            ListView.builder(
              itemCount: gazoleById.length,
              itemBuilder: (context, index) {
                Gazole gazole = gazoleById[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      // En-tête de la page
                      IntrinsicHeight(
                        child: Row(
                          children: <Widget>[
                            // Première moitié de la première rangée - Image de la station
                            Expanded(
                              flex: 1,
                              child: Container(
                                // Mettez ici votre image de station
                                child: Image.asset(
                                  'assets/ecoe_station_maroc_gazole.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Deuxième moitié de la première rangée - Colonne des prix
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  // Première rangée de la colonne - Prix de l'essence
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Diesel: ${gazole.dissel ?? 0}'),
                                    ],
                                  ),
                                  // Deuxième rangée de la colonne - Prix du diesel
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Essence: ${gazole.ese ?? 0}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Premium: ${gazole.premium ?? 0}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Milieu de la page - Menu des services
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: <Widget>[
                            // Menu horizontal
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  buildServiceMenuItem('Restaurant'),
                                  buildServiceMenuItem('Washing'),
                                  buildServiceMenuItem('Playground'),
                                  // Ajoutez d'autres services au besoin
                                ],
                              ),
                            ),

                            // Détails du service sélectionné
                            selectedService.isNotEmpty
                                ? buildServiceDetailsTable(selectedService)
                                : buildServiceDetailsTable(
                                    "Washing"), // Affiche uniquement si un service est sélectionné
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildServiceMenuItem(String serviceName) {
    return ElevatedButton(
      onPressed: () {
        try {
          // Mettez à jour le service sélectionné
          setState(() {
            selectedService = serviceName;
          });
        } catch (e) {
          print('Error updating selected service: $e');
        }
      },
      child: Text(serviceName),
    );
  }

  Widget buildServiceDetailsTable(String serviceName) {
    List<Service> stationServicesByType = [];

    if (serviceName == 'Washing') {
      stationServicesByType = stationServicesWashing;
    } else if (serviceName == 'Restaurant') {
      stationServicesByType = stationServicesRestaurant;
    } else if (serviceName == 'Playground') {
      stationServicesByType = stationServicesPlayground;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Désactiver le défilement du GridView
              itemCount: stationServicesByType.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                try {
                  var service = stationServicesByType[index];

                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image en haut à droite
                          Align(
                            alignment: Alignment.topRight,
                            child: Image.asset(
                              'assets/ecoe_station_maroc_gazole.png',
                              width: 24.0,
                              height: 24.0,
                            ),
                          ),
                          // Espace entre l'image et le texte
                          SizedBox(height: 8.0),
                          // Texte
                          Text(service.name ?? ''),
                          // Prix
                          Text(service.price.toString() ?? ''),
                        ],
                      ),
                    ),
                  );
                } catch (e) {
                  print('Error building card: $e');
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

//   Widget buildServiceCardsWashing() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20.0),
//       child: ListView.builder(
//         itemCount: stationServicesWashing.length,
//         itemBuilder: (BuildContext context, int index) {
//           try {
//             var service = stationServicesWashing[index];

//             return Card(
//               elevation: 3.0,
//               margin: EdgeInsets.all(8.0),
//               child: Padding(
//                 padding: EdgeInsets.all(12.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Add your service name, price, and typeService here
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(service.name ?? ''),
//                         Text(service.price.toString() ?? ''),
//                         Text(service.typeService ?? ''),
//                       ],
//                     ),

//                     // Add your service icons here
//                     const Row(
//                       children: [
//                         // Example of an icon (replace it with your actual icons)
//                         Icon(Icons.star),
//                         Icon(Icons.favorite),
//                         // Add more icons as needed
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } catch (e) {
//             print('Error building Washing card: $e');
//             return Container();
//           }
//         },
//       ),
//     );
//   }

//   Widget buildServiceCardsPlayground() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20.0),
//       child: ListView.builder(
//         itemCount: stationServicesPlayground.length,
//         itemBuilder: (BuildContext context, int index) {
//           try {
//             // Your existing code for building cards
//           } catch (e, stackTrace) {
//             print('Error building Playground card: $e');
//             print('Stack Trace: $stackTrace');
//             return Container(); // You can also return an error message widget here
//           }
//         },
//       ),
//     );
//   }
// }
}
