import 'package:flutter/material.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/FirebaseService.dart';
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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: KThemeColors.secondary,
        dividerTheme: const DividerThemeData(color: KThemeColors.secondary),
      ),
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
  late List<Record> _records;

  List<Record> _getRecords() => _records;
// range: 12-16-2023, 12-23-2023
  @override
  void initState() {
    super.initState();
    startLoading();
    // FirebaseService.deleteAllRecords();
    // FirebaseService.seedDatabaseWithRecords();
    initRecordsList();
  }

  Future<void> initRecordsList() async {
    await Future.delayed(Duration.zero);
    setState(() {
      isLoading = true;
    });
    List<Record> records = await FirebaseService.fetchAllRecords();
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

  void updateRecordList(List<Record> records) {
    startLoading();
    setState(() {
      _records = records;
    });
    stopLoading();
  }

  void onSearch(String searchText) async {
    startLoading();
    List<Record> filteredRecords = searchText == ''
        ? await FirebaseService.fetchAllRecords()
        : await FirebaseService.getData(searchText.toLowerCase());
    updateRecordList(filteredRecords);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return Scaffold(
      backgroundColor: KThemeColors.primary,
      appBar: PreferredSize(
        preferredSize: isMobile
            ? const Size.fromHeight(120.0)
            : const Size.fromHeight(80.0),
        child: Align(
          child: SizedBox(
            width: isMobile ? screenWidth : 600,
            child: AppBar(
              leadingWidth: 10,
              backgroundColor: KThemeColors.secondary,
              shadowColor: Colors.transparent,
              flexibleSpace: CustomAppBar(
                onSearch: onSearch,
                updateRecordList: updateRecordList,
                getRecords: _getRecords,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: isMobile ? screenWidth : 600,
          color: KThemeColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                              child: RecordCard(
                                  record: _records[index],
                                  updateRecordList: updateRecordList),
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
