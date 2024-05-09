



import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {

   HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _refreshNotes();
    // TODO: implement initState
    super.initState();
  }

  String _name = "";
  List<Map<String,dynamic>>  _notesListss = [];
  final _noteslist = Hive.box('noteslist');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titeController = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        title: Text("Notes",style: TextStyle(color: Colors.white ),),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
             TextField(

               controller: _nameController,

               decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide(width: 3,color: Colors.white)
                 ),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(15),
                       borderSide: BorderSide(width: 3,color: Colors.white)
                   ),
                 border: OutlineInputBorder(

                   borderRadius: BorderRadius.circular(15),
                   borderSide: BorderSide(width: 3,color: Colors.white)

                 ),
                 hintText: 'Enter Name',
                 hintStyle: TextStyle(color: Colors.white)
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
              Text(''+_name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _notesListss.length,
                itemBuilder: (context, index) {
                  if(_notesListss.isNotEmpty)
                    {
                      return Card(
                        color: Colors.blue,
                        elevation: 5,

                        child: ListTile(
                          title: Text(_notesListss[index]['title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          subtitle: Text(_notesListss[index]['description'],style: TextStyle(color: Colors.white)),
                          trailing:Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: (){
                                // var update = {'title':"maruf",'description':"hello"};
                                //_noteslist.put(_notesListss[index]['key'], update);
                                _showForm(context, _notesListss[index]['key'].toInt());
                                // _noteslist.put(_notesListss[index]['key']["title"], "Asif");
                                // _noteslist.put(_notesListss[index]['key']["description"], "who are you?");
                                // _refreshNotes();
                                // setState(() {
                                //
                                // });
                              }, icon: Icon(Icons.edit,color: Colors.yellowAccent,)),
                              IconButton(icon:Icon(Icons.delete,color: Colors.white,),
                                onPressed: (){
                                  _noteslist.delete(_notesListss[index]["key"]);
                                  _refreshNotes();
                                  setState(() {

                                  });
                                },),
                            ],
                          )
                        ),
                      );
                    }
                  else
                    return Text("Nothing");

              },)

            ],
          ),
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

    if(itemKey!=null)
      {
        final existingNote = _notesListss.firstWhere((element) => element['key']==itemKey);
        _titeController.text=existingNote['title'];
        _description.text=existingNote['description'];
      }
    showModalBottomSheet(context: cntxt,
      backgroundColor: Colors.white,

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
               decoration: InputDecoration(
                 enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide(width: 3,color: Colors.white)
                 ),
                 focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide(width: 3,color: Colors.white)
                 ),
                 border: OutlineInputBorder(

                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide(width: 3,color: Colors.white)

                 ),
                   hintText: 'Title',
                 ),
             ),
            SizedBox(height: 10,),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 3,color: Colors.white)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 3,color: Colors.white)
                ),
                border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(width: 3,color: Colors.white)

                ),
                hintText: 'Description',
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              
              if(itemKey==null)
                {

                  _createNote({
                    'title': _titeController.text.toString(),
                    'description': _description.text.toString()

                  });
                }
              if(itemKey!=null)
                {
                  _updateNote(itemKey, {'title':_titeController.text.trim(),'description':_description.text.trim()});
                }
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

    print("notes amount :"+_noteslist.length.toString());
    _refreshNotes();
    print("list length: "+_notesListss.length.toString());
  }
  void _refreshNotes(){
    final data = _noteslist.keys.map((key) {
      final noteItem = _noteslist.get(key);
      return {"key":key,"title":noteItem["title"],"description":noteItem["description"]};
    }).toList();
    _notesListss = data.reversed.toList();
    setState(() {

    });
}

Future<void> _updateNote(int? Itemkey,Map<String,dynamic> noteItem)
async {
    await _noteslist.put(Itemkey, noteItem);
    _refreshNotes();
    setState(() {

    });

}


}
