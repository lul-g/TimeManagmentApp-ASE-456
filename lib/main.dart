import 'package:flutter/material.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/screens/page1.dart';
import 'package:time_app/src/screens/page2.dart';
import 'package:time_app/src/services/FirebaseUtils.dart';
import 'package:time_app/src/utils/constants.dart';
import 'package:time_app/src/widgets/app_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_app/src/widgets/record_card.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: KThemeColors.secondary),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  String _searchParam = '';
  late List<Record> _records;

  @override
  void initState() {
    super.initState();
    startLoading();
    // FirebaseUtils.deleteAllDocumentsInCollection('Records');
    // FirebaseUtils.seedDatabaseWithRecords();
    initRecordsList();
    // getData();
  }

  Future<void> initRecordsList() async {
    await Future.delayed(Duration.zero);
    setState(() {
      isLoading = true;
    });
    List<Record> records =
        await FirebaseUtils.fetchRecordsByDate(DateTime.now());
    updateRecordList(records);
    setState(() {
      isLoading = false;
    });
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
    // Future.delayed(const Duration(seconds: 2), () {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void updateSearchParam(String val) {
    setState(() {
      _searchParam = val;
    });
  }

  void updateRecordList(List<Record> records) {
    startLoading();
    setState(() {
      _records = records;
    });
    stopLoading();
  }

  void onSearch(String searchText) async {
    startLoading();
    List<Record> records =
        await FirebaseUtils.getData(searchText: searchText.toLowerCase());
    updateRecordList(records);
    setState(() {
      _searchParam = searchText;
    });
  }

  void searchTask() async {
    setState(() {
      isLoading = true;
    });
  }

  void navigateToPage1() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page1()),
    );
  }

  void navigateToPage2() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page2()),
    );
  }

  void navigateToEditPage() {
    print('Navigate to edit page');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: CustomAppBar(
          onSearch: onSearch,
          updateRecordList: updateRecordList,
          initRecordsList: initRecordsList,
        ),
      ),
      body: Center(
        child: Container(
          width: isMobile ? MediaQuery.of(context).size.width : 600,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Text(
                  'Tasks',
                  style: TextStyle(
                    color: KThemeColors.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _records.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.only(top: 100),
                            child: const Center(
                              child: Text(
                                'No Records Found!',
                                style: TextStyle(
                                  color: KThemeColors.primary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: RecordCard(record: _records[index]),
                            ),
                            childCount: _records.length,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
