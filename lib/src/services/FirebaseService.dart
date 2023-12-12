import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/TimeService.dart';
import 'package:time_app/src/services/ToastService.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'Records';

  static Future<DocumentReference> addRecord(Record record) async {
    print(record.titleArr);
    if (record.titleArr[0] == '') {
      // print(record);
      print(record);
      ToastService.showError('Title can not be empty.');
      throw ArgumentError('TitleArr must not be null or empty.');
    }
    return await _firestore.collection(_collectionPath).add({
      'titleArr':
          record.titleArr.map((title) => title..trim().toLowerCase()).toList(),
      'description': record.description?.toLowerCase() ?? '',
      'date': record.date,
      'from': record.from,
      'to': record.to,
      'priority': Record.assignPriority(record.from, record.to),
      'tags':
          record.tags?.map((tag) => tag.trim().toLowerCase()).toList() ?? [],
    });
  }

  static Future<void> seedDatabaseWithRecords() async {
    try {
      List<Record> records = Record.generateMockRecords();

      for (int i = 0; i < records.length; i++) {
        Record record = records[i];
        await addRecord(record);
      }

      ToastService.showSuccess('Database Seeded Successfully With Records!');
    } catch (e) {
      ToastService.showError('Error Seeding Database: $e');
    }
  }

  static Future<List<Record>> fetchAllRecords() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionPath)
          .orderBy('date', descending: true)
          .get();
      print('Number of documents found: ${querySnapshot.docs.length}');

      List<Record> records = querySnapshot.docs
          .map((doc) => Record.fromDocumentSnapshot(doc))
          .toList();

      records.isNotEmpty
          ? ToastService.showSuccess('✔ Fetched Records Successfully!')
          : ToastService.showWarning('⚠ No Records Matched Your Query!');
      return records;
    } catch (e) {
      ToastService.showError('Error Fetching Records: $e');
      return [];
    }
  }

  static Future<void> deleteAllRecords() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(_collectionPath).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection(_collectionPath)
            .doc(doc.id)
            .delete();
      }

      ToastService.showSuccess(
          'All Documents In $_collectionPath Deleted Successfully.');
    } catch (e) {
      ToastService.showError('Error Deleting Documents: $e');
    }
  }

  static Future<List<Record>> getData(String? searchText) async {
    try {
      var collection = _firestore.collection(_collectionPath);
      Query query = collection;

      if (searchText == null || searchText.isEmpty) {
        return [];
      }
      searchText = searchText.toLowerCase();
      if (searchText.startsWith('#')) {
        return await searchByTags(query, searchText);
      } else if (searchText.startsWith('key:')) {
        return await searchByTitle(query, searchText);
      } else if (searchText.startsWith('date:')) {
        return await searchByDate(query, searchText);
      } else if (searchText.startsWith('range:')) {
        return await searchByDateRange(query, searchText);
      } else {
        return await searchByTitle(query, searchText);
      }
    } catch (e) {
      ToastService.showError('❌ Some Error When Fetching Records');
      print('Error Getting Data: $e');
      return [];
    }
  }

  static Future<void> setData(Record record) async {
    try {
      await addRecord(record);
      ToastService.showSuccess('✔ Record Added Successfully');
    } catch (e) {
      ToastService.showError('❌Some Error Occured');
      // ToastService.showError('Error setting data: $e');
    }
  }

  static Future<void> deleteRecord(String documentId) async {
    try {
      await _firestore.collection(_collectionPath).doc(documentId).delete();
      ToastService.showSuccess('Data Deleted Successfully');
    } catch (e) {
      ToastService.showError('Error Deleting Data: $e');
    }
  }

  static Future<List<Record>> executeQuery(Query query) async {
    var result = await query.get();
    List<Record> records =
        result.docs.map((doc) => Record.fromDocumentSnapshot(doc)).toList();

    records.isNotEmpty
        ? ToastService.showSuccess('✔ Fetched Records Successfully!')
        : ToastService.showWarning('⚠ No Records Matched Your Query!');

    print('Number of documents found: ${records.length}');
    return records;
  }

  static Future<List<Record>> searchByDateRange(
      Query query, String searchText) async {
    List<String> dateArr = searchText.replaceAll('range:', '').split(',');
    DateTime? parsedStart = TimeService.dateParser(dateArr[0]);
    DateTime? parsedEnd = TimeService.dateParser(dateArr[1]);
    if (parsedStart == null && parsedEnd == null) {
      ToastService.showError(
          '❌ Please Format The Date-Range Properly. Use , To Divide The Dates.');
      return await fetchAllRecords();
    }
    DateTime startDate =
        DateTime(parsedStart!.year, parsedStart.month, parsedStart.day);
    DateTime endDate =
        DateTime(parsedEnd!.year, parsedEnd.month, parsedEnd.day);
    try {
      query = query
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date',
              isLessThanOrEqualTo:
                  Timestamp.fromDate(endDate.add(const Duration(days: 1))))
          .orderBy('date', descending: true);

      ToastService.showSuccess(
          'Fetched All Records For Time $startDate - $endDate');
      return await executeQuery(query);
    } catch (e) {
      ToastService.showError('Error Fetching Records: $e');
      return [];
    }
  }

  static Future<List<Record>> searchByTags(
      Query query, String searchText) async {
    List<String> tags = searchText.replaceAll('#', '').split(',');
    print('search by tags . . . $tags');
    query = query.where('tags', arrayContainsAny: tags);
    return await executeQuery(query);
  }

  static Future<List<Record>> searchByDate(
      Query query, String searchText) async {
    searchText = searchText.replaceAll('date:', '');
    // date: 12/28/2023
    print("searchtxt: $searchText");
    DateTime? parsedDate = TimeService.dateParser(searchText);
    if (parsedDate != null) {
      print("parsedDate $parsedDate");
      DateTime startDate =
          DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      DateTime endDate = startDate.add(const Duration(days: 1));
      query = query
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThan: Timestamp.fromDate(endDate))
          .orderBy('date');
      return await executeQuery(query);
    }
    return [];
  }

  static Future<List<Record>> searchByTitle(
      Query query, String searchText) async {
    List<String> strArr =
        searchText.replaceAll('key:', '').trim().toLowerCase().split(' ');
    print('searchBYtitle: $strArr');
    query = query.where('titleArr', arrayContainsAny: strArr);
    return await executeQuery(query);
  }
}
