import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:smarth_save/models/open_ia_bot.dart';
import 'package:smarth_save/models/message_history.dart';
import 'package:smarth_save/services/api_fine_tune_service.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;
  late OpenIABot _bot;

  @override
  void initState() {
    super.initState();
    _bot = OpenIABot();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await MessageHistory.loadMessages();
    _messages.clear();
    for (final msg in history) {
      _messages.add(_ChatMessage(
        text: msg['content'] ?? '',
        isBot: (msg['role'] ?? '') != 'user',
      ));
    }
    // Si l'historique est vide, on récupère la fine-tune AVANT le setState
    if (_messages.isEmpty) {
      final fineTuneService = ApiFineTuneService();
      final fineTune = await fineTuneService.getFineTuneSentence();
      if (fineTune != null && fineTune.isNotEmpty) {
        _messages.add(_ChatMessage(text: fineTune, isBot: false));
        await MessageHistory.addMessage({"role": "user", "content": fineTune});
        final history = await MessageHistory.loadMessages();
        final botReply = await _bot.sendMessageWithHistory(history);
        _messages.add(_ChatMessage(text: botReply, isBot: true));
        await MessageHistory.addMessage(
            {"role": "assistant", "content": botReply /*  */});
      }
    }
    setState(() {});
  }

  Future<void> _handleSend(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isBot: false));
      _isLoading = true;
    });
    _controller.clear();
    await MessageHistory.addMessage({"role": "user", "content": text});
    try {
      // Charge l'historique complet pour le contexte
      final history = await MessageHistory.loadMessages();
      final botReply = await _bot.sendMessageWithHistory(history);
      setState(() {
        _messages.add(_ChatMessage(text: botReply, isBot: true));
        _isLoading = false;
      });
      await MessageHistory.addMessage(
          {"role": "assistant", "content": botReply /*  */});
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(text: 'Erreur: $e', isBot: true));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.teal),
            tooltip: "Exporter l'historique",
            onPressed: () async {
              await MessageHistory.exportHistory();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Historique exporté dans Téléchargements')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload, color: Colors.teal),
            tooltip: "Importer un historique",
            onPressed: () async {
              await MessageHistory.importHistory();
              await _loadHistory();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Historique importé')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: 'Supprimer l\'historique',
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await MessageHistory.clearHistory();
              await _loadHistory();
              setState(() {
                _isLoading = false;
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Historique supprimé'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          )
        ],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun message',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: false,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isLoading && index == _messages.length) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[350],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset("assets/images/loading.gif"),
                            ),
                          ),
                        );
                      }
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isBot
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: msg.isBot ? Colors.grey[350] : Colors.teal,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(msg.isBot ? 0 : 18),
                              bottomRight: Radius.circular(msg.isBot ? 18 : 0),
                            ),
                          ),
                          child: msg.isBot
                              ? Markdown(data: msg.text)
                              : Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: msg.isBot
                                        ? Colors.black87
                                        : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Demande moi quelque chose.....',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                    ),
                    onSubmitted: _handleSend,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _handleSend(_controller.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;
  _ChatMessage({required this.text, required this.isBot});
}
