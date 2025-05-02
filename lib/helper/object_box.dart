import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:doable_todo_list_app/entities.dart';
import 'package:doable_todo_list_app/objectbox.g.dart';

/// Provides access to the ObjectBox Store throughout the app.
class ObjectBox {
  late final Store _store;
  late final Box<TodoItem> todoBox;

  late final SyncClient? _syncClient;

  ObjectBox._create(this._store) {
    todoBox = Box<TodoItem>(_store);
    // Optional: setup sync if credentials are available
    _setupSync();
  }

  void _setupSync() {
    try {
      final ipSyncServer = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
      final syncServerUrl = "ws://$ipSyncServer:9999";

      if (syncServerUrl.isNotEmpty) {
        // Create sync client with the store
        _syncClient =
            Sync.client(_store, syncServerUrl, SyncCredentials.none());

        // Optional: Listen to connection events for debugging
        _syncClient?.connectionEvents.listen((event) {
          print('Sync connection event: $event');
        });

        // Start the sync client
        try {
          _syncClient?.start();
          print('ObjectBox Sync client started');
        } catch (e) {
          print('Error starting sync client: $e');
        }
      }
    } catch (e) {
      print('Error setting up sync: $e');
    }
  }

  void closeSync() {
    _syncClient?.stop();
    _syncClient?.close();
  }

  void dispose() {
    closeSync();
    _store.close();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> init() async {
    // Get a directory where the ObjectBox store files can be saved
    final docsDir = await getApplicationDocumentsDirectory();

    // Use a store directory inside the app's documents directory
    final storeDir = join(docsDir.path, "objectbox");

    // TEMPORARILY: delete existing store to fix schema mismatch
    // final dir = Directory(storeDir);
    // if (await dir.exists()) {
    //   print('Deleting existing ObjectBox store directory...');
    //   await dir.delete(recursive: true);
    // }

    // Create the store
    final store = await openStore(directory: storeDir);

    return ObjectBox._create(store);
  }

  // Add a TodoItem to the database
  int addTodoItem(TodoItem todoItem) {
    try {
      return todoBox.put(todoItem);
    } catch (e) {
      print('Error adding TodoItem: $e');
      return 0;
    }
  }

  // Get all TodoItems
  List<TodoItem> getAllTodoItems() {
    try {
      return todoBox.getAll();
    } catch (e) {
      print('Error getting TodoItems: $e');
      return [];
    }
  }

  // Remove a TodoItem
  bool removeTodoItem(int id) {
    try {
      return todoBox.remove(id);
    } catch (e) {
      print('Error removing TodoItem: $e');
      return false;
    }
  }

  // Update a TodoItem
  int updateTodoItem(TodoItem todoItem) {
    return todoBox.put(todoItem);
  }
}

// Make ObjectBox available throughout the app
late ObjectBox objectBox;
