import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/stores/store_category.dart';
import 'package:task_manager/stores/task_store.dart';

class DocumentReferenceMock extends Mock implements DocumentReference {}

class FirestoreMock extends Mock implements FirebaseFirestore {}

class TaskMock extends Mock implements Task {}

class TaskStoreMock extends Mock implements TaskStore {}

class CategoryStoreMock extends Mock implements CategoryStore {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class FirebaseServiceMock extends Mock {
  static final FirebaseServiceMock _singleton = FirebaseServiceMock._internal();
  MockFirestoreInstance instance = MockFirestoreInstance();

  factory FirebaseServiceMock() {
    return _singleton;
  }

  FirebaseServiceMock._internal();
}

void main() {
  group("CRUD Tests", () {
    FirebaseServiceMock firebaseServiceMock;
    TaskStore taskStore;

    setUp(() async => {
          firebaseServiceMock = FirebaseServiceMock(),
          await firebaseServiceMock.instance.collection('task').add({
            'description': 'Hello world!',
            'done': false,
            'important': true
          }),
          taskStore = TaskStore.testConstructor(firebaseServiceMock.instance)
        });

    test('Should add Task', () async {
      final DocumentReferenceMock mockDocumentRef = DocumentReferenceMock();
      Task task = Task();
      task.id = mockDocumentRef;
      task.description = 'Pickup product in store';
      task.done = true;
      task.important = false;

      taskStore.add(task);

      final snapshot =
          await firebaseServiceMock.instance.collection('task').get();

      expect(snapshot.docs.toList()[1].data()['description'],
          'Pickup product in store');
      expect(snapshot.docs.toList()[1].data()['done'], true);
      expect(snapshot.docs.toList()[1].data()['important'], false);
    });
  });
}
