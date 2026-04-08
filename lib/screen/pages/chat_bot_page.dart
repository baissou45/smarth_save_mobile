import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:smarth_save/models/message_history.dart';
import 'package:smarth_save/services/api_chat_service.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiChatService _chatService = ApiChatService();

  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitializing = false;

  // Typing indicator animation
  late AnimationController _typingAnimController;

  @override
  void initState() {
    super.initState();
    _typingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _loadHistory();
  }

  @override
  void dispose() {
    _typingAnimController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isInitializing = true);
    final history = await MessageHistory.loadMessages();

    _messages.clear();
    for (final msg in history) {
      _messages.add(_ChatMessage(
        text: msg['content'] ?? '',
        isBot: msg['role'] == 'assistant',
        timestamp: DateTime.now(),
      ));
    }

    setState(() => _isInitializing = false);
    _scrollToBottom();
  }

  Future<void> _handleSend(String text) async {
    text = text.trim();
    if (text.isEmpty || _isLoading) return;

    _inputController.clear();
    final userMsg = _ChatMessage(
      text: text,
      isBot: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
    });
    _scrollToBottom();

    await MessageHistory.addMessage({'role': 'user', 'content': text});

    try {
      final history = await MessageHistory.loadMessages();
      // Send only the last 20 messages as context
      final context = history.length > 20
          ? history.sublist(history.length - 20)
          : history;

      final answer = await _chatService.send(
        message: text,
        history: context
            .map((m) => {'role': m['role']!, 'content': m['content']!})
            .toList(),
      );

      final botMsg = _ChatMessage(
        text: answer,
        isBot: true,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(botMsg);
        _isLoading = false;
      });

      await MessageHistory.addMessage({'role': 'assistant', 'content': answer});
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(
          text:
              'Désolé, je suis temporairement indisponible. Vérifiez votre connexion.',
          isBot: true,
          isError: true,
          timestamp: DateTime.now(),
        ),);
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Effacer la conversation'),
        content:
            const Text('Cette action supprimera tout l\'historique. Continuer ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await MessageHistory.clearHistory();
    setState(() => _messages.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _isInitializing
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF009688),
                    ),
                  )
                : _buildMessageList(),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF131557), Color(0xFF009688)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 4),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SmartBot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      _isLoading ? 'En train d\'écrire...' : 'Assistant financier',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (value) async {
                  final messenger = ScaffoldMessenger.of(context);
                  switch (value) {
                    case 'export':
                      await MessageHistory.exportHistory();
                      if (mounted) {
                        messenger.showSnackBar(
                          _snackBar('Historique exporté dans Téléchargements'),
                        );
                      }
                      break;
                    case 'import':
                      await MessageHistory.importHistory();
                      await _loadHistory();
                      if (mounted) {
                        messenger.showSnackBar(
                          _snackBar('Historique importé'),
                        );
                      }
                      break;
                    case 'clear':
                      await _clearHistory();
                      break;
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        Icon(Icons.download_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Exporter'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'import',
                    child: Row(
                      children: [
                        Icon(Icons.upload_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Importer'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Effacer', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoading && index == _messages.length) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF009688).withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: Color(0xFF009688),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bonjour ! Je suis SmartBot.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF131557),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Posez-moi une question sur vos finances.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _suggestionChip('Mes dépenses ce mois'),
              _suggestionChip('Mes projets d\'épargne'),
              _suggestionChip('Mon budget par catégorie'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(String label) {
    return GestureDetector(
      onTap: () => _handleSend(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF009688).withValues(alpha:0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF009688),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    final isBot = msg.isBot;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isBot) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                color: msg.isError
                    ? Colors.red.withValues(alpha:0.15)
                    : const Color(0xFF009688).withValues(alpha:0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                msg.isError ? Icons.error_outline : Icons.auto_awesome,
                size: 16,
                color: msg.isError ? Colors.red : const Color(0xFF009688),
              ),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isBot ? Colors.white : const Color(0xFF009688),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isBot ? 4 : 20),
                  bottomRight: Radius.circular(isBot ? 20 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isBot
                  ? MarkdownBody(
                      data: msg.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                          height: 1.5,
                        ),
                        strong: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF131557),
                        ),
                        h3: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF131557),
                        ),
                        listBullet: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF009688),
                        ),
                        code: TextStyle(
                          fontSize: 13,
                          backgroundColor: const Color(0xFFF0F2F8),
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  : Text(
                      msg.text,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.45,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8, bottom: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF009688).withValues(alpha:0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Color(0xFF009688),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _buildDot(i)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _typingAnimController,
      builder: (_, __) {
        final offset = ((_typingAnimController.value + index / 3) % 1.0);
        final dy = offset < 0.5
            ? -4.0 * (offset * 2)
            : -4.0 * (1 - (offset - 0.5) * 2);
        return Transform.translate(
          offset: Offset(0, dy),
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              color: Color(0xFF009688),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F8),
                borderRadius: BorderRadius.circular(26),
              ),
              child: TextField(
                controller: _inputController,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Posez votre question...',
                  hintStyle: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onSubmitted: _handleSend,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _handleSend(_inputController.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isLoading
                    ? Colors.grey[300]
                    : const Color(0xFFFF6B35),
                shape: BoxShape.circle,
                boxShadow: _isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withValues(alpha:0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Icon(
                Icons.arrow_upward_rounded,
                color: _isLoading ? Colors.grey[500] : Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SnackBar _snackBar(String text) {
    return SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;
  final bool isError;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
    this.isError = false,
  });
}
