

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleTextController = TextEditingController();
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorderable List View Example'),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            // Firestore의 category 컬렉션 구독
            stream: db.collection('category').orderBy("createdAt", descending: false).snapshots(),
            builder: (context, snapshot) {
              // 데이터 로드 중 표시
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // 데이터가 없을 경우
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No items found'));
              }

              // Firestore 데이터를 ListView로 변환
              final items = snapshot.data!.docs;

              return SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final data = items[index].data() as Map<String, dynamic>;
                    final docId = items[index].id;
                    return Container(
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          print("long");
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Item change'),
                                content: TextField(
                                  controller: titleTextController,
                                  autofocus: true,
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Firestore에 데이터 업데이트
                                      final updateRef = db.collection('category').doc(docId);
                                      updateRef.update({'name': titleTextController.text}).then((value) =>
                                          print('Category updated')).
                                      catchError((error) =>
                                          print('Failed to update category: $error'));
                                      titleTextController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('edit'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final deleteRef = db.collection('category').doc(docId);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('정말 지우시겠습니까?'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  deleteRef.delete().then((value) =>
                                                      print('document deleted')).catchError((error) =>
                                                      print('Failed to delete category: $error'));

                                                  // 삭제 확인 AlertDialog 닫기
                                                  Navigator.pop(context);
                                                  // 첫 번째 AlertDialog 닫기
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('delete'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('delete'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListTile(
                          title: Text(data['name'] ?? 'Unknown'), // Firestore의 'name' 필드 사용
                          trailing: IconButton(
                            onPressed: () {
                              // 데이터 업데이트
                              print(docId);

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Item change'),
                                    content: TextField(
                                      controller: titleTextController,
                                      autofocus: true,
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Firestore에 데이터 업데이트
                                          final updateRef = db.collection('category').doc(docId);
                                          updateRef.update({'name': titleTextController.text}).then((value) =>
                                              print('Category updated')).
                                          catchError((error) =>
                                              print('Failed to update category: $error'));
                                          titleTextController.clear();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('edit'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final deleteRef = db.collection('category').doc(docId);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('정말 지우시겠습니까?'),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      deleteRef.delete().then((value) =>
                                                          print('document deleted')).catchError((error) =>
                                                          print('Failed to delete category: $error'));

                                                      // 삭제 확인 AlertDialog 닫기
                                                      Navigator.pop(context);
                                                      // 첫 번째 AlertDialog 닫기
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('delete'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('delete'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Item'),
                content: TextField(
                  controller: titleTextController,
                  autofocus: true,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      // Firestore에 데이터 추가
                      final docRef = db.collection('category');
                      docRef.add({'name': titleTextController.text, 'createdAt': FieldValue.serverTimestamp(),});
                      titleTextController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
