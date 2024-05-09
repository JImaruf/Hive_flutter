

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {

   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = "";
  List<Map<String,dynamic>>  _notesListss = [];
  final _noteslist = Hive.box('noteslist');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titeController = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
           TextField(
             controller: _nameController,
             decoration: InputDecoration(
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(15)

               ),
               hintText: 'Enter Name'
             ),
           ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () async {
              var box = await Hive.openBox('Name');
              box.put('name', _nameController.text.toString());


            }, child: Text("Add Name")),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () async {
              var box = await Hive.openBox('Name');
             // box.put('name', _nameController.text.toString());
             _name = box.get('name').toString();
             setState(() {

             });


            }, child: Text("Show Name")),
            SizedBox(height: 20,),
            Text(''+_name),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // var box = await Hive.openBox('Maruf');
        // box.put('name', "Jahidul Islam Maruf ");
        _showForm(context, null);
      },
        child: Icon(Icons.add),

      ),
    );
  }

  void _showForm(BuildContext cntxt ,int? itemKey)
  {
    showModalBottomSheet(context: cntxt,
      elevation: 5,
      isScrollControlled: true,

      builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(cntxt).viewInsets.bottom ,//**,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,//*******
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             TextField(
               controller: _titeController,
                 decoration: const InputDecoration(
                   hintText: 'Title',
                 ),
             ),
            SizedBox(height: 10,),
            TextField(
              controller: _description,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              _createNote({
                'name': _titeController.text.toString(),
                'description': _description.text.toString()

              });
              _titeController.text='';
              _description.text='';
              Navigator.of(context).pop();
            },
                child: Text("Add")),
            const SizedBox(height: 20,),

          ],
        ),
      );

    },);


  }
  Future<void> _createNote(Map<String,dynamic> newItem)async {
    await _noteslist.add(newItem);

    print(_noteslist.length);
  }
}
