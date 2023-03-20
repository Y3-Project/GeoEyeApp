
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocs(String collection, String field, dynamic equalTo) async{
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: equalTo)
        .get();
    return snap.docs;
}



Future<List<DocumentReference>> getDocRefs(String collection, String field, dynamic equalTo) async{
    List<DocumentReference> docRefs = [];
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docList = await getDocs(collection, field, equalTo);
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docList) {
        DocumentReference docRef = doc.reference;
        docRefs.add(docRef);
    }
    return docRefs;
}