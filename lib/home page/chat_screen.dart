import '../pages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const apiKey = String.fromEnvironment('GEMINI_API_KEY');

  final model = GenerativeModel(
      model: const String.fromEnvironment('GEMINI_MODEL',
          defaultValue: 'gemini-pro'),
      apiKey: apiKey);

  final List<Message> _messages = [];
  bool _sending = false;

  @override
  void dispose() {
    _userInput.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = _userInput.text;
    if (message.trim().isEmpty || _sending) return;

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    if (apiKey.isEmpty) {
      setState(() => _messages.add(Message(
          isUser: false,
          message:
              'Cloud assistant is not configured. You can browse products, manage your cart, and update your address from the app.',
          date: DateTime.now())));
      _userInput.clear();
      return;
    }
    _sending = true;
    try {
      final response = await model.generateContent(
          [Content.text(message)]).timeout(const Duration(seconds: 45));
      if (!mounted) return;
      setState(() => _messages.add(Message(
          isUser: false,
          message: response.text ?? 'No response received. Please try again.',
          date: DateTime.now())));
    } catch (_) {
      if (!mounted) return;
      setState(() => _messages.add(Message(
          isUser: false,
          message:
              'The cloud assistant is unavailable. Please try again later.',
          date: DateTime.now())));
    } finally {
      _sending = false;
    }

    _userInput.clear();

    // Ensure the scroll animation is completed after the new message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'lib/images/chatlogo.png',
              height: 120,
            ),
            const SizedBox(width: 10),
            const Text(
              'AI',
              style: TextStyle(
                fontSize: 29, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.dstATop),
            image: const AssetImage(
                'lib/images/chatbackground.png'), // Update with your local image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Handling scroll events, if necessary
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Messages(
                      isUser: message.isUser,
                      message: message.message,
                      date: DateFormat('HH:mm').format(message.date),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: _userInput,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Ask Me Anything',
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.all(12),
                    iconSize: 30,
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
