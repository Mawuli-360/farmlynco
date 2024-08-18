import 'dart:io';

import 'package:farmlynco/features/communication/chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmlynco/util/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<List<Map<String, dynamic>>> getInitialMessages(
      String chatRoomID) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomID)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(20) // Adjust this number based on your needs
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // print('Error getting initial messages: $e');
      return [];
    }
  }

  // Initiate or get existing chat with product owner
  Future<String> initiateChatWithProductOwner(String ownerEmail) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("No authenticated user found");

    final ownerDoc = await _firebaseFirestore
        .collection("users")
        .where("email", isEqualTo: ownerEmail)
        .get();

    if (ownerDoc.docs.isEmpty) throw Exception("Product owner not found");

    final ownerId = ownerDoc.docs.first.id;
    final List<String> ids = [currentUser.uid, ownerId];
    ids.sort();
    final String chatRoomID = ids.join('_');

    // Create chat room if it doesn't exist
    await _firebaseFirestore.collection("chat_rooms").doc(chatRoomID).set({
      'participants': [currentUser.uid, ownerId],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return chatRoomID;
  }

  Future<void> sendVoiceMessage(String chatRoomID, String audioFilePath) async {
    try {
      String audioUrl = await uploadAudioFile(
          audioFilePath); // Implement this method to upload the audio file to your storage
      await _firebaseFirestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add({
        'senderId': getCurrentUser()!.uid,
        'audioUrl': audioUrl,
        'type': 'voice',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      showToast('Error sending voice message: $e');
    }
  }

  Future<String> uploadAudioFile(String filePath) async {
    try {
      File audioFile = File(filePath);

      // Create a unique filename using a timestamp
      String fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.aac';

      // Get a reference to the location you want to upload to in Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('audio_messages/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(audioFile);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      showToast('Error uploading audio file: $e');
      throw Exception('Failed to upload audio file');
    }
  }

  // Get chat rooms for current user
  Stream<List<Map<String, dynamic>>> getChatRoomsForCurrentUser() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("No authenticated user found");

    return _firebaseFirestore
        .collection("chat_rooms")
        .where('participants', arrayContains: currentUser.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> chatRooms = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final otherUserId = (data['participants'] as List)
            .firstWhere((id) => id != currentUser.uid);
        final otherUserDoc =
            await _firebaseFirestore.collection("users").doc(otherUserId).get();
        final otherUserData = otherUserDoc.data() ?? {};

        chatRooms.add({
          'chatRoomId': doc.id,
          'otherUserName': otherUserData['fullName'] ?? 'Unknown',
          'otherUserEmail': otherUserData['email'] ?? 'Unknown',
          'lastMessage': data['lastMessage'],
          'lastMessageTime': data['lastMessageTime'],
          'isOnline': otherUserData['isOnline'] ?? false,
          'lastSeen': otherUserData['lastSeen'],
        });
      }
      return chatRooms;
    });
  }

  Future<void> updateUserStatus(bool isOnline) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("No authenticated user found");

    await _firebaseFirestore.collection("users").doc(currentUser.uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  // Send message (updated to update last message in chat room)
  Future<void> sendMessage(String chatRoomID, String message) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("No authenticated user found");

    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUser.uid,
      senderEmail: currentUser.email!,
      receiverId: '', // This will be filled by the chat room participants
      message: message,
      timestamp: timestamp,
    );

    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

    // Update last message in chat room
    await _firebaseFirestore.collection("chat_rooms").doc(chatRoomID).update({
      'lastMessage': message,
      'lastMessageTime': timestamp,
    });
  }

  // Get messages for a specific chat room
  Stream<QuerySnapshot> getMessages(String chatRoomID) {
    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }
}
