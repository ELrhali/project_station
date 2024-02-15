import 'package:flutter/material.dart';
import 'package:maps_marker/services/services_station.dart';

class StationServiceInput extends StatefulWidget {
  @override
  _StationServiceInputState createState() => _StationServiceInputState();
}

class _StationServiceInputState extends State<StationServiceInput> {
  final ServiceStaionGazole serviceStation = ServiceStaionGazole();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stationIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeServiceController = TextEditingController();

  List<Service> createdServices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stationIdController,
              decoration: InputDecoration(labelText: 'Station ID'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: typeServiceController,
              decoration: InputDecoration(labelText: 'Type of Service'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Service newService = Service(
                  id: 0,
                  name: nameController.text,
                  price: double.parse(priceController.text),
                  stationId: stationIdController.text,
                  description: descriptionController.text,
                  typeService: typeServiceController.text,
                );

                serviceStation.createService(newService).then((createdService) {
                  setState(() {
                    createdServices.add(createdService);
                  });

                  nameController.clear();
                  priceController.clear();
                  stationIdController.clear();
                  descriptionController.clear();
                  typeServiceController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Service created successfully'),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating service: $error'),
                    ),
                  );
                });
              },
              child: Text('Create Service'),
            ),
            SizedBox(height: 20),
            Text('Created Services:'),
            Expanded(
              child: ListView.builder(
                itemCount: createdServices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(createdServices[index].name.toString()),
                    subtitle: Text('Price: ${createdServices[index].price}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
