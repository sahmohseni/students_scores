import 'package:flutter/material.dart';
import 'package:students_scores/data.dart';

void main() {
  getStudents();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _downScrollController = ScrollController();
  void scrollDown() {
    _downScrollController.animateTo(
        _downScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
              elevation: 0,
              onPressed: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddNewStuedent()));
                setState(() {});
              },
              label: Row(
                children: [
                  Icon(Icons.add),
                  const SizedBox(
                    width: 6,
                  ),
                  Text('Add Student')
                ],
              )),
          const SizedBox(
            width: 8,
          ),
          FloatingActionButton.extended(
              onPressed: () => scrollDown(), label: Icon(Icons.arrow_downward)),
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text('Students Scores'),
      ),
      body: FutureBuilder<List<StudentData>>(
          future: getStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  controller: _downScrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _Student(
                      data: snapshot.data![index],
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                ),
              );
            }
          }),
    );
  }
}

class _Student extends StatelessWidget {
  final StudentData data;

  const _Student({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(6), boxShadow: [
        BoxShadow(
            blurStyle: BlurStyle.solid,
            offset: Offset.zero,
            blurRadius: 0.2,
            color: Colors.grey.withOpacity(0.12))
      ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.11),
                      blurRadius: 0.2,
                    )
                  ]),
              child: Center(
                child: Text(
                  data.firstName.characters.first,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.firstName + " " + data.lastName,
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 0.1,
                          color: Colors.black.withOpacity(0.07))
                    ]),
                    child: Text(
                      data.course,
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  color: Colors.grey.withOpacity(0.8),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(data.score.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddNewStuedent extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          onPressed: () {
            final newStudent = postStudent(
                _firstNameController.text,
                _lastNameController.text,
                _courseController.text,
                int.parse(_scoreController.text));
            Navigator.pop(context, newStudent);
          },
          label: Row(
            children: [
              Icon(Icons.check),
              const SizedBox(
                width: 4,
              ),
              Text('Save')
            ],
          )),
      appBar: AppBar(
        title: Text('Add New Student'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(label: Text('First Name')),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(label: Text('Last Name')),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(label: Text('Course')),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _scoreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(label: Text('Score')),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
