import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/ColorUtils.dart';
import 'package:time_app/src/services/TimeUtils.dart';
import 'package:time_app/src/utils/custom_toast.dart';

class FirebaseUtils {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> seedDatabaseWithRecords() async {
    try {
      List<Record> records = Record.generateMockRecords();

      for (int i = 0; i < records.length; i++) {
        Record record = records[i];
        await _firestore.collection('Records').add({
          'title': record.title?.toLowerCase(),
          'dateTime': record.dateTime,
          'slot': record.slot?.toLowerCase(),
          'bgColor': ColorUtils.colorToString(record.bgColor!),
          'tags': record.tags?.map((tag) => tag.toLowerCase()).toList(),
        });
      }

      print('Database seeded successfully with records!');
    } catch (e) {
      print('Error seeding database: $e');
    }
  }

  static Future<List<Record>> fetchRecordsByDate(DateTime targetDate) async {
    try {
      DateTime date =
          DateTime(targetDate.year, targetDate.month, targetDate.day);
      DateTime startDate = date.subtract(const Duration(days: 1));
      DateTime endDate = date.add(const Duration(days: 1));
      QuerySnapshot querySnapshot = await _firestore
          .collection('Records')
          .where('dateTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('dateTime', isLessThan: Timestamp.fromDate(endDate))
          .orderBy('dateTime')
          .get();
      print('Number of documents found: ${querySnapshot.docs.length}');

      List<Record> records = querySnapshot.docs.map((doc) {
        Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
        return Record(
          title: record['title'] ?? '',
          dateTime: (record['dateTime'] as Timestamp).toDate(),
          slot: record['slot'] ?? '',
          bgColor: ColorUtils.stringToColor(record['bgColor']),
          tags: (record['tags'] as List<dynamic>?)
                  ?.map((tag) => tag as String)
                  .toList() ??
              [],
        );
      }).toList();
      print('Fetched all records for time $targetDate');

      records.isNotEmpty
          ? ToastManager.showSuccess('✔ Fetched records successfully!')
          : ToastManager.showWarning('⚠ No records matched your query!');
      return records;
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }
  }

  static Future<List<Record>> getData({String? searchText}) async {
    try {
      var collection = _firestore.collection('Records');
      Query query = collection;

      if (searchText != null && searchText.isNotEmpty) {
        if (searchText.contains('#')) {
          List<String> tags = searchText.replaceAll('#', '').split(',');

          print('search by tags . . . $tags');
          query = query.where('tags', arrayContainsAny: tags);
        } else {
          DateTime? parsedDate = TimeUtils.parseDate(searchText);
          if (parsedDate != null) {
            DateTime date =
                DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
            DateTime startDate = date.subtract(const Duration(days: 1));
            DateTime endDate = date.add(const Duration(days: 1));
            query = query
                .where('dateTime',
                    isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                .where('dateTime', isLessThan: Timestamp.fromDate(endDate))
                .orderBy('dateTime');
          } else {
            query = query.where('title', arrayContains: searchText.split(' '));
          }
        }
      }

      var result = await query.get();
      List<Record> records = result.docs.map((doc) {
        Map<String, dynamic> record = doc.data() as Map<String, dynamic>;
        return Record(
          docId: doc.id,
          title: record['title'] ?? '',
          dateTime: (record['dateTime'] as Timestamp).toDate(),
          slot: record['slot'] ?? '',
          bgColor: ColorUtils.stringToColor(record['bgColor']),
          tags: (record['tags'] as List<dynamic>?)
                  ?.map((tag) => tag as String)
                  .toList() ??
              [],
        );
      }).toList();

      records.map((record) =>
          print("\n${record.docId} ${record.title} ${record.tags?.length}\n"));
      records.isNotEmpty
          ? ToastManager.showSuccess('✔ Fetched records successfully!')
          : ToastManager.showWarning('⚠ No records matched your query!');

      print('During search ${records.length}');
      return records;
    } catch (e) {
      print('Error getting data: $e');
      return [];
    }
  }

  static Future<String> setData(Record record) async {
    try {
      DocumentReference documentReference =
          await _firestore.collection('Records').add({
        'title': record.title,
        'dateTime': record.dateTime,
        'slot': record.slot,
        'bgColor': ColorUtils.colorToString(record.bgColor!),
        'tags': record.tags,
      });
      print('Data set successfully');
      return documentReference.id;
    } catch (e) {
      print('Error setting data: $e');
      return '';
    }
  }

  static Future<void> deleteData(String documentId) async {
    try {
      await _firestore.collection('Records').doc(documentId).delete();
      print('Data deleted successfully');
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  static Future<void> deleteAllDocumentsInCollection(
      String collectionPath) async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collectionPath).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(doc.id)
            .delete();
      }

      print('All documents in $collectionPath deleted successfully.');
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }
}
