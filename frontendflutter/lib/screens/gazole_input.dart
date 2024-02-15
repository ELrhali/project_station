import 'package:flutter/material.dart';
import 'package:maps_marker/services/gazole_station.dart';

class GazoleListScreen extends StatefulWidget {
  final String stationId;

  const GazoleListScreen({Key? key, required this.stationId}) : super(key: key);

  @override
  _GazoleListScreenState createState() => _GazoleListScreenState();
}

class _GazoleListScreenState extends State<GazoleListScreen> {
  List<Gazole> gazoles = [];

  @override
  void initState() {
    super.initState();
    _fetchGazoles();
  }

  Future<void> _fetchGazoles() async {
    try {
      List<Gazole> fetchedGazoles =
          await GazoleStation().getGazoles(stationId: widget.stationId);
      setState(() {
        gazoles = fetchedGazoles;
      });
    } catch (e) {
      // Handle error
      print("Error fetching gazoles: $e");
    }
  }

  Future<void> _createOrUpdateGazole(Gazole gazole) async {
    try {
      if (gazole.id != 0) {
        // Update existing gazole
        await GazoleStation().updateGazole(gazole);
      } else {
        // Check if gazole with the same stationId already exists
        bool gazoleExists = gazoles.any(
            (existingGazole) => existingGazole.stationId == widget.stationId);
        if (!gazoleExists) {
          // Create new gazole
          await GazoleStation().createGazole(gazole);
        } else {
          // Display a message that gazole already exists
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Gazole with stationId ${widget.stationId} already exists.'),
          ));
        }
      }
      // Refresh the list after create/update
      await _fetchGazoles();
    } catch (e) {
      // Handle error
      print("Error creating/updating gazole: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gazole List'),
      ),
      body: ListView.builder(
        itemCount: gazoles.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('ID: ${gazoles[index].id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_gas_station),
                      Text(' Essence: ${gazoles[index].ese ?? 0}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Text(' Premium: ${gazoles[index].premium ?? 0}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.local_gas_station),
                      Text(' Diesel: ${gazoles[index].dissel ?? 0}'),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // Navigate to the update screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateGazoleScreen(
                      stationId: widget.stationId,
                      onUpdate: _createOrUpdateGazole,
                      gazole: gazoles[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the create screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateGazoleScreen(
                stationId: widget.stationId,
                onCreate: _createOrUpdateGazole,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CreateGazoleScreen extends StatefulWidget {
  final String stationId;
  final Function(Gazole) onCreate;

  const CreateGazoleScreen(
      {Key? key, required this.stationId, required this.onCreate})
      : super(key: key);

  @override
  _CreateGazoleScreenState createState() => _CreateGazoleScreenState();
}

class _CreateGazoleScreenState extends State<CreateGazoleScreen> {
  double? ese;
  double? premium;
  double? dissel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Gazole'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Essence'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  ese = double.tryParse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Premium'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  premium = double.tryParse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Diesel'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  dissel = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Create a new Gazole instance with the entered values
                Gazole newGazole = Gazole(
                  id: 0,
                  ese: ese,
                  premium: premium,
                  dissel: dissel,
                  stationId: widget.stationId,
                );
                // Call the onCreate callback to handle the creation
                widget.onCreate(newGazole);
                // Navigate back to the list screen
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateGazoleScreen extends StatefulWidget {
  final String stationId;
  final Function(Gazole) onUpdate;
  final Gazole gazole;

  const UpdateGazoleScreen({
    Key? key,
    required this.stationId,
    required this.onUpdate,
    required this.gazole,
  }) : super(key: key);

  @override
  _UpdateGazoleScreenState createState() => _UpdateGazoleScreenState();
}

class _UpdateGazoleScreenState extends State<UpdateGazoleScreen> {
  double? ese;
  double? premium;
  double? dissel;

  @override
  void initState() {
    super.initState();
    // Initialize the state with existing values from the selected gazole
    ese = widget.gazole.ese;
    premium = widget.gazole.premium;
    dissel = widget.gazole.dissel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Gazole'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Essence'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              initialValue: ese?.toString() ?? '',
              onChanged: (value) {
                setState(() {
                  ese = double.tryParse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Premium'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              initialValue: premium?.toString() ?? '',
              onChanged: (value) {
                setState(() {
                  premium = double.tryParse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Diesel'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              initialValue: dissel?.toString() ?? '',
              onChanged: (value) {
                setState(() {
                  dissel = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Create a new Gazole instance with the updated values
                Gazole updatedGazole = Gazole(
                  id: widget.gazole.id,
                  ese: ese,
                  premium: premium,
                  dissel: dissel,
                  stationId: widget.stationId,
                );
                // Call the onUpdate callback to handle the update
                widget.onUpdate(updatedGazole);
                // Navigate back to the list screen
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
