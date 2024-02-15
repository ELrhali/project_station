import 'package:flutter/material.dart';
import 'package:maps_marker/screens/Widget/inputdecoration.dart';
import 'package:maps_marker/screens/gazole_input.dart';
// import 'package:maps_marker/screens/gazole_input.dart';
import 'package:maps_marker/services/services_station.dart';
// import 'package:maps_marker/services/gazole_station.dart';

class InputDetails extends StatefulWidget {
  final String stationId;
  final String nameId;

  const InputDetails({Key? key, required this.stationId, required this.nameId})
      : super(key: key);

  @override
  State<InputDetails> createState() => _InputDetailsState();
}

class _InputDetailsState extends State<InputDetails> {
  String selectedService = '';
  final ServiceStaionGazole serviceStation = ServiceStaionGazole();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  TextEditingController stationIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeServiceController = TextEditingController();

  List<Service> createdServices = [];
  List<Service> stationServices = [];
  int? selectedIndex;
  int? selectedServiceId;
  bool isLoading = true; // Ajout d'un indicateur de chargement
  List<String> serviceTypes = ['Playground', 'Restaurant', 'Washing'];
  String selectedServiceType = 'Restaurant';
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    stationIdController.text = widget.stationId;

    loadStationServices();
    _pageController = PageController(initialPage: 0);
  }

  void loadStationServices() {
    serviceStation.getServices(stationId: widget.stationId).then((services) {
      setState(() {
        stationServices = services;
        isLoading = false; // Indiquer que le chargement est terminé
      });
    }).catchError((error) {
      print('Error loading station services: $error');
      isLoading =
          false; // Indiquer que le chargement est terminé même en cas d'erreur
    });
  }

  bool showServiceDetails = true; // Default to ServiceStationDetails

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // Create the Text widget outside of the AppBar title property
    Text appBarTitle = Text(
      ' ${widget.nameId}',
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
      body: PageView(
        controller: _pageController,
        children: [
          ServiceStationDetails(
            stationId: widget.stationId,
            nameId: widget.nameId,
          ),
          GazoleListScreen(stationId: widget.stationId),
        ],
      ),
      bottomNavigationBar: SingleChildScrollView(
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the buttons horizontally

          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _pageController.animateToPage(0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Set the background color to orange
              ),
              child: const Text(
                'Service',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Set the background color to orange
              ),
              child: const Text(
                'Gazole',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// child: const Text(
//                       'Delete',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//Service Details StatefulWidget
class ServiceStationDetails extends StatefulWidget {
  final String stationId;
  final String nameId;

  const ServiceStationDetails(
      {Key? key, required this.stationId, required this.nameId})
      : super(key: key);

  @override
  State<ServiceStationDetails> createState() => _ServiceStationDetailsState();
}

class _ServiceStationDetailsState extends State<ServiceStationDetails> {
  String selectedService = '';
  final ServiceStaionGazole serviceStation = ServiceStaionGazole();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  TextEditingController stationIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeServiceController = TextEditingController();

  List<Service> createdServices = [];
  List<Service> stationServices = [];
  int? selectedIndex;
  int? selectedServiceId;
  bool isLoading = true; // Ajout d'un indicateur de chargement
  List<String> serviceTypes = ['Playground', 'Restaurant', 'Washing'];
  String selectedServiceType = 'Restaurant';
  @override
  void initState() {
    super.initState();
    stationIdController.text = widget.stationId;

    loadStationServices();
  }

  void loadStationServices() {
    serviceStation.getServices(stationId: widget.stationId).then((services) {
      setState(() {
        stationServices = services;
        isLoading = false; // Indiquer que le chargement est terminé
      });
    }).catchError((error) {
      print('Error loading station services: $error');
      isLoading =
          false; // Indiquer que le chargement est terminé même en cas d'erreur
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedServiceType,
                items: serviceTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedServiceType = value!;
                    typeServiceController.text = value;
                  });
                  print("valeu type *$typeServiceController");
                },
                decoration: const InputDecoration(
                  labelText: 'Type of Service',
                  icon: Icon(Icons.confirmation_number_outlined),
                ),
              ),
              SizedBox(height: 10.0),

              TextFormField(
                style: simpleTextStyle(),
                controller: nameController,
                decoration: textFieldInputDecoration(
                  'Name',
                  const Icon(Icons.account_circle_outlined),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: simpleTextStyle(),
                decoration: textFieldInputDecoration(
                  'Price',
                  Icon(Icons.perm_identity_outlined),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: descriptionController,
                style: simpleTextStyle(),
                decoration: textFieldInputDecoration(
                  'Description',
                  const Icon(Icons.confirmation_number_outlined),
                ),
              ),

              const SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        elevation: 8.0,
                        backgroundColor: Colors.green,
                        shape: raisedButtonBorder(),
                      ),
                      onPressed: () {
                        if (stationIdController.text.isNotEmpty) {
                          try {
                            // Validate the format of priceController.text
                            if (RegExp(r'^\d+(\.\d+)?$')
                                .hasMatch(priceController.text)) {
                              Service newService = Service(
                                id: 0,
                                name: nameController.text,
                                price: double.parse(priceController.text),
                                stationId: stationIdController.text,
                                description: descriptionController.text,
                                typeService: typeServiceController.text,
                              );

                              serviceStation
                                  .createService(newService)
                                  .then((createdService) {
                                print('Service created successfully');

                                // Clear the text controllers
                                nameController.clear();
                                priceController.clear();
                                descriptionController.clear();
                                typeServiceController.clear();

                                // Show a snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Service created successfully'),
                                  ),
                                );

                                // Trigger a rebuild of the widget tree
                                setState(() {
                                  loadStationServices();
                                });
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Error creating service: $error'),
                                  ),
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please enter a valid price'),
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error creating service: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Invalid price format. Please enter a valid number.'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a station ID'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        backgroundColor: Colors.red,
                        elevation: 8.0,
                        shape: raisedButtonBorder(),
                      ),
                      onPressed: () {
                        if (selectedIndex != null) {
                          deleteService(selectedServiceId!);
                          selectedIndex =
                              null; // Clear the selected index after deletion
                          selectedServiceId =
                              null; // Clear the selected ID after deletion
                        } else {
                          // Show a message indicating that no service is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please select a service to delete'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(thickness: 1.0, height: 25.0, color: Colors.green),
              // En-tête du tableau

              // Inside your Column widget
              DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Price',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: stationServices.map((service) {
                  return DataRow(
                    selected: selectedIndex == stationServices.indexOf(service),
                    onSelectChanged: (bool? selected) {
                      setState(() {
                        selectedIndex =
                            selected! ? stationServices.indexOf(service) : null;
                        selectedServiceId = selected! ? service.id : null;
                      });
                    },
                    cells: [
                      DataCell(
                        Text(service.name ?? ''),
                      ),
                      DataCell(
                        Text(service.price.toString() ?? ''),
                      ),
                      DataCell(
                        Text(service.typeService ?? ''),
                      ),
                    ],
                  );
                }).toList(),
              )
              // Message si aucun service n'est disponible
            ],
          )),
    );
  }

  void deleteService(int serviceId) async {
    try {
      await serviceStation.deleteService(serviceId);

      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service deleted successfully'),
        ),
      );

      // Trigger a rebuild of the widget tree
      setState(() {
        loadStationServices();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting service: $error'),
        ),
      );
    }
  }
}
