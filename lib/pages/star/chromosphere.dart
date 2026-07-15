import 'package:flutter/material.dart';

class ChromoMain extends StatefulWidget {
  const ChromoMain({Key? key}) : super(key: key);

  @override
  State<ChromoMain> createState() => _ChromoMainState();
}

class _ChromoMainState extends State<ChromoMain> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // The console history log
  final List<String> _consoleHistory = [
    'Read-only mode.',
    'Some data may be encrypted.',
    'Welcome, ***.',
  ];

  // --- MOCK FILE SYSTEM SETUP ---
  final Map<String, dynamic> _fileSystem = {
    'diary': {
      '1.txt': """Entry #1
Finally managed to install this, it's REALLY simple but it gets the job done.
Funny how much trouble I had for such a simple system. I blame the machine.
But well, I can finally start my work.
""",
      '2.txt': """Entry #2
I've been studying more about stars and such.
They fascinate me.
My favorite is the J05233822-1403022.
It's an ultra-cool red dwarf, with a temperature of only ~2000K
For reference the sun has an effective temperature of ~6000K

I don't like the sun. It's too warm.""",
      '3.txt': "file is corrupted.",
      '4.md': """# Entry #4
I should've been using markdown more!
My editor can somewhat view it, after all.
It's more for... Syntax highlighting and such. It can't make text bigger.
But it's better than nothing.

My new project seems to be coming along great. C isn't an easy language, so I'm glad I'm being able to pull it off.
It is straining me a bit but, surely, I'll be fine.""",
      '5.md': "file is corrupted.",
      '6.md': """# Entry #6
For some reason my machine was already powered on today.
I don't remember having left it on. Maybe I just forgot.
Or something went wrong. There were some binaries on my home directory.
I didn't run them, I'm no idiot, but I did zip them, just to be sure.
What if I wanna test out some malware?""",
      '7.md': """# Entry #7
There's more of these stupid ass binaries.
I'm gonna run one of them, I'm bored.
I'll write about it later.""",
      '8': """this wasnt here
this wasnt here
this wasnt here
this wasnt here
this wasnt here
this wasnt here
it wasnt
it wasnt






                                                                                                                      tell me it wasnt


                                                                                                  ]0�     UY6[E�r��ʵAv z=\$1�X���u�w�-u��kFu�2�l�;o�t���az�@t�%��������� 	���&KUl�s(//΢7pܔA�@<�y6���E��4��?D�{��Q��L_�����`悩�T�L&͑4^�k�|_1<�\$GIRu��Z�*7D"Q\\gr}�����������f����:�R�����5N���ǉ��Ϭ���b�&�}>s�#HD���/�;H�k�N"�@��e�;S���ԑ쿪����&]]�ܭ�O���.?�?�d�����I���	�6@['��8LM��4��0Q�i�"F�����xPA��Ψ�.yAu[7�[Q'\\�YO}':2O�O�4e}:��Q�9�чNƏ�\\0�X�l�䂟<�\\��D:���%��

file corrupted. HEX code error: 6974776173""",
    },
    'dev': {},
    'documents': {
      '***.log': """Logfile 2025.11.22 12:03:43.2314
error when trying to load ***
ERROR: file "/etc/head" not found file "/etc/arm64" not found
ERROR: file "/etc/arm32" not found
ERROR: file "/etc/leg" not found
ERROR: file "/etc/body" not found
CRITICAL: kernel unloaded
CRITICAL: kernel corrupted
CRITICAL: kernel not found 
INFO: restoring #4870...
INFO: success
exiting...""",
    },
    'downloads': {},
    'pictures': {},
  };

  // --- ENCRYPTION STATE ---
  final Map<String, String> _encryptedDirs = {
    // Folder name : Password
    'documents': '2MASS',
    'dev': 'itwas',
    'pictures': 'placeholder',
  };
  final Set<String> _unlockedDirs =
      {}; // Keeps track of unlocked folders for the session

  bool _isPromptingPassword = false;
  String _passwordTargetDir = '';
  int _failedAttempts = 0;

  // Tracks current path. Empty list is root "/"
  List<String> _currentPath = [];

  // Helper: Changed return type and check to 'Map' to accept empty maps ({}) gracefully
  Map<dynamic, dynamic> _getCurrentDirectory() {
    Map<dynamic, dynamic> current = _fileSystem;
    for (String folder in _currentPath) {
      if (current[folder] is Map) {
        current = current[folder] as Map;
      }
    }
    return current;
  }

  // Helper: Format path for prompt display
  String _getPathString() {
    if (_currentPath.isEmpty) return '~';
    return '~/${_currentPath.join('/')}';
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Handle command execution logic
  void _executeCommand(String input) {
    final trimmedInput = input.trim();

    setState(() {
      // --- PASSWORD FLOW ACTIVE ---
      if (_isPromptingPassword) {
        // Echo asterisks to console instead of cleartext password
        _consoleHistory.add('Password: ${'*' * trimmedInput.length}');

        final correctPassword = _encryptedDirs[_passwordTargetDir];

        if (trimmedInput == correctPassword) {
          _unlockedDirs.add(_passwordTargetDir);
          _currentPath.add(
            _passwordTargetDir,
          ); // Successfully enter the directory

          // Reset password flow
          _isPromptingPassword = false;
          _passwordTargetDir = '';
          _failedAttempts = 0;
        } else {
          _failedAttempts++;
          if (_failedAttempts >= 3) {
            _consoleHistory.add('cd: 3 incorrect password attempts');
            // Reset password flow, user remains in current directory
            _isPromptingPassword = false;
            _passwordTargetDir = '';
            _failedAttempts = 0;
          } else {
            _consoleHistory.add('Sorry, try again.');
          }
        }
      }
      // --- STANDARD COMMAND FLOW ---
      else {
        if (trimmedInput.isEmpty) return;

        // Echo command back to the console
        _consoleHistory.add('[***@star ${_getPathString()}]\$ $trimmedInput');

        final List<String> parts = trimmedInput.split(RegExp(r'\s+'));
        final String mainCommand = parts[0].toLowerCase();
        final String argument = parts.length > 1
            ? parts.sublist(1).join(' ')
            : '';

        switch (mainCommand) {
          case 'help':
            _consoleHistory.addAll([
              'stash, version *.*.*-release (x86_64-pc-*******-***)',
              'These shell commands are defined internally.  Type `help` to see this list.',
              '  help        - show this menu',
              '  ls          - list directory contents',
              '  cd <dir>    - change directory (use "cd .." to go back)',
              '  cat <file>  - print file contents',
              '  ping        - Send ICMP ECHO_REQUEST packets to network hosts.',
              '  fetch       - print system details',
              '  clear       - clear the console screen',
            ]);
            break;

          case 'ls':
            final currentDir = _getCurrentDirectory();
            if (currentDir.isEmpty) {
              _consoleHistory.add('(directory is empty)');
            } else {
              List<String> items = [];
              currentDir.forEach((key, value) {
                if (value is Map) {
                  items.add('$key/');
                } else {
                  items.add(key.toString());
                }
              });
              _consoleHistory.add(items.join('   '));
            }
            break;

          case 'cd':
            if (argument.isEmpty) {
              _currentPath.clear();
            } else if (argument == '..') {
              if (_currentPath.isNotEmpty) {
                _currentPath.removeLast();
              }
            } else {
              final currentDir = _getCurrentDirectory();
              // Changed standard check to broad 'Map' to accept empty maps ({}) correctly
              if (currentDir.containsKey(argument) &&
                  currentDir[argument] is Map) {
                // Trigger password check if directory is encrypted and not yet unlocked
                if (_encryptedDirs.containsKey(argument) &&
                    !_unlockedDirs.contains(argument)) {
                  _isPromptingPassword = true;
                  _passwordTargetDir = argument;
                  _failedAttempts = 0;
                  _consoleHistory.add('Directory is encrypted.');
                } else {
                  // Standard navigation
                  _currentPath.add(argument);
                }
              } else if (currentDir.containsKey(argument)) {
                _consoleHistory.add('stash: cd: $argument: Not a directory');
              } else {
                _consoleHistory.add(
                  'stash: cd: $argument: No such file or directory',
                );
              }
            }
            break;

          case 'cat':
            if (argument.isEmpty) {
              _consoleHistory.add('usage: cat <filename>');
            } else {
              final currentDir = _getCurrentDirectory();
              if (currentDir.containsKey(argument)) {
                final target = currentDir[argument];
                if (target is String) {
                  _consoleHistory.add(target);
                } else {
                  _consoleHistory.add('stash: cat: $argument: Is a directory');
                }
              } else {
                _consoleHistory.add(
                  'stash: cat: $argument: No such file or directory',
                );
              }
            }
            break;

          case 'ping':
            _consoleHistory.addAll([
              'PING 127.0.0.1 (127.0.0.1): 56 data bytes',
              '64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.042 ms',
              '--- 127.0.0.1 ping statistics ---',
              '1 packets transmitted, 1 packets received, 0.0% packet loss',
            ]);
            break;

          case 'fetch':
            _consoleHistory.addAll([
              'OS: ******',
              'Host: **********',
              'Memory: why won\'t you remember?',
            ]);
            break;

          case 'clear':
            _consoleHistory.clear();
            break;

          default:
            _consoleHistory.add("stash: $mainCommand: command not found");
        }
      }
    });

    _inputController.clear();

    // Instantly snap to the bottom of the list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _focusNode.requestFocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Render history
                  ..._consoleHistory
                      .map(
                        (line) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            line,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  // 2. The dynamic Input Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _isPromptingPassword
                              ? 'Password: '
                              : '[***@star ${_getPathString()}]\$ ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            focusNode: _focusNode,
                            autofocus: true,
                            obscureText: _isPromptingPassword,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 14.0,
                              height: 1.2,
                            ),
                            cursorColor: Colors.white,
                            cursorWidth: 8,
                            cursorHeight: 14,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (value) => _executeCommand(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
