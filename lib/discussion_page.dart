import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class DiscussionPage extends StatefulWidget {
  final String subNoteContent;

  const DiscussionPage({super.key, required this.subNoteContent});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class ChatMessage {
  final String user;
  final String message;
  final DateTime time;

  ChatMessage({required this.user, required this.message, required this.time});
}

class _DiscussionPageState extends State<DiscussionPage> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late WebSocketChannel _channel;
  String _userName = "Unknown";
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadUserName().then((_) => _connectWebSocket());
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Unknown';
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.113:8080/ws'), // Ganti sesuai IP server
    );

    _channel.stream.listen(
      (data) {
        final parsedData = _parseMessage(data);
        if (parsedData != null) {
          setState(() {
            _messages.add(parsedData);
            _isConnected = true;
          });
        }
      },
      onDone: () {
        setState(() {
          _isConnected = false;
        });
        print("🔴 WebSocket connection closed");
      },
      onError: (error) {
        setState(() {
          _isConnected = false;
        });
        print("❌ WebSocket error: $error");
      },
    );

    setState(() {
      _isConnected = true;
    });
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMsg = ChatMessage(
      user: _userName,
      message: text,
      time: DateTime.now(),
    );

    _channel.sink.add(_formatMessage(newMsg));

    setState(() {
      _messages.add(newMsg);
    });

    _controller.clear();
  }

  String _formatMessage(ChatMessage message) {
    return jsonEncode({
      'user': message.user,
      'message': message.message,
      'time': message.time.toIso8601String(),
    });
  }

  ChatMessage? _parseMessage(String data) {
    try {
      final json = jsonDecode(data);
      return ChatMessage(
        user: json['user'],
        message: json['message'],
        time: DateTime.parse(json['time']),
      );
    } catch (e) {
      print("❌ Error parsing message: $e");
      return null;
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diskusi Study Notes"),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  _isConnected ? Icons.circle : Icons.circle_outlined,
                  size: 12,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(_isConnected ? 'Online' : 'Offline'),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Diskusi untuk: ${widget.subNoteContent}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.user == _userName;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.user,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(msg.message, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(msg.time),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ketik pesan...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
