import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/analysis.dart';
import 'package:lecture_tracker/screens/backupAndrestore.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:http/http.dart' as http;

class AiChat extends ConsumerStatefulWidget {
  const AiChat({super.key});

  @override
  ConsumerState<AiChat> createState() => _AiChatState();
}

class _AiChatState extends ConsumerState<AiChat> {
  ScrollController scrollControllerForWelcomeText = ScrollController();
  bool navBarActive = false;
  late String userTextToSend;
  bool awaiting = false;
  bool removeLogo = false;
  bool cancelSending = false;
  final ScrollController _autoGoDownForListview = ScrollController();
  // to be able to change when the send icon is active for sending message or not
  final TextEditingController _userInput = TextEditingController();
  String hintText =
      'Type your message...'; //for holding the hinttext and change later if user did not type anything
  void rm() async {
    router.pop();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_autoGoDownForListview.hasClients) {
        _autoGoDownForListview.animateTo(
          _autoGoDownForListview.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
        );
      }
    });
  }

  Future<void> send() async {
    //for first adding the arrears from analysis page
    if ((ref.read(userAITempChatHolder)["user"] as List).length == 0) {
      ref.read(userAITempChatHolder.notifier).update((state) {
        return {
          'user': [...?state['AI'], "My Last Prompt"],
          'AI': [...?state['user'], ref.read(oneTimeAiAnalysis)],
        };
      });
    }

    //begining of send i used in my main project sharpbrain
    scrollToBottom();
    userTextToSend = _userInput.text;
    if (userTextToSend.trim().isEmpty) {
      setState(() {
        hintText = "Can't send empty message...";
      });
    } else {
      setState(() {
        removeLogo = true;
        awaiting = true;
        cancelSending = false;
      });
      _userInput.clear();
      if (cancelSending == false) {
        ref.invalidate(
          aiChatResponse,
        ); //to invalidate the previous response so that it can fetch a new response when the user sends a new message, this is important because if we dont invalidate it, it will return the previous response instead of fetching a new one, and that is not what we want, we want to fetch a new response every time the user sends a new message, so we need to invalidate it to make sure it fetches a new response.

        if (cancelSending || !mounted) return;
        final List toAdd = await ref
            .refresh(aiChatResponse({'message': userTextToSend}).future)
            .timeout(
              Duration(seconds: 10),
              onTimeout: () {
                return [
                  404,
                  {"message": "Network Timeout"},
                ];
              },
            );
        // a
        if (cancelSending || !mounted) return;

        String a = toAdd[1]["message"];
        if (cancelSending || !mounted) return;
        setState(() {
          awaiting = false;
        });
        if (cancelSending || !mounted) return;
        ref.read(userAITempChatHolder.notifier).update((state) {
          return {
            'user': [...?state['user'], userTextToSend],
            'AI': [...?state['AI'], a],
          };
        });
        if (toAdd[0] == 429) {
          _userInput.text = userTextToSend;
        }

        //to make sure the listview scroll to the very bottom
        scrollToBottom();
      }
    }
  }
  //to make suere the number of of user text and ai is the same
  //i am commenting it out cos i am so sure the number of user text and ai response will always be the same, if there is a case where it is not the same, then it should be handled in the backend and not here, so i am commenting this out for now, if there is a need for it in the future, then i will just uncomment it and make necessary changes to it
  // int refreshPage() {
  //   if (userTextLenght > aiTextLenght) {
  //     setState(() {
  //       int missing = userTextLenght - aiTextLenght;
  //       for (int i = 0; i < missing; i++) {
  //         holder['AI']!.add('added$i');
  //       }
  //     });
  //   }

  //   return 0;
  // }

  Widget onpressedIcon({
    required double shortestSize,
    required IconData iconData,
    required VoidCallback onTap,
    Color? color,
    bool? isactive = true,
  }) {
    return InkWell(
      onTap: isactive == null ? null : onTap,
      child: Container(
        width: shortestSize * 0.1,
        height: shortestSize * 0.1,
        decoration: BoxDecoration(
          color: color ?? ref.watch(foreGroundColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(iconData, color: ref.watch(backgroundColor), size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // refreshPage();
    double navBarMaxWidth = (0.4 * ref.watch(deviceSizeX)).w < 136
        ? (0.4 * ref.watch(deviceSizeX)).w
        : 136;
    final _shortestSize = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      backgroundColor: ref.watch(backgroundColor),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(backgroundColor),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          router.pop();
        },
        child: Stack(
          children: [
            Container(
              height: ref.watch(deviceSizeY).h,
              width: ref.watch(deviceSizeY).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 0.98 * ref.watch(deviceSizeY).w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          onpressedIcon(
                            iconData: Icons.navigate_before,
                            onTap: () => rm(),
                            color: Colors.red,
                            shortestSize: _shortestSize,
                          ),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            ref.watch(username),
                            style: TextStyle(
                              color: ref.watch(foreGroundColor),
                              fontSize: _shortestSize * 0.066,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Switch(
                            trackOutlineColor: WidgetStatePropertyAll(
                              ref.watch(foreGroundColor),
                            ),
                            thumbColor: WidgetStateProperty.all(
                              ref.watch(lightMode)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            trackColor: WidgetStateProperty.all(
                              ref.watch(foreGroundColor),
                            ),

                            value: ref.watch(lightMode),
                            onChanged: (v) {
                              ref.read(lightMode.notifier).state = v;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child:
                        removeLogo == false &&
                            ref.watch(userAITempChatHolder)['user']!.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: SvgPicture.string(
                                  """
                <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'>
                  <defs>
                    <linearGradient id='g' x1='0' x2='1'>
                      <stop offset='0' stop-color='#4e54c8'/>
                      <stop offset='1' stop-color='#e0e0e0'/>
                    </linearGradient>
                  </defs>
                  <circle cx='50' cy='50' r='40' fill='url(#g)' opacity='1'/>
                  <text x='50%' y='58%' text-anchor='middle' fill='white' font-family='Arial' font-weight='700'>
                    <tspan font-size='32' dx = '-8'>LT</tspan>
                    <tspan font-size='14' dy='-2' dx='-12'>aI</tspan>
                    <tspan font-size='5' dy='19' dx = '-32'>Customized For You</tspan>
                  </text>
                </svg>
              """,
                                  width: ref.watch(deviceSizeX).w * 0.5,
                                  height: ref.watch(deviceSizeX).w * 0.5,
                                ),
                              ),
                              Container(
                                height: 200.h,
                                margin: EdgeInsets.symmetric(
                                  horizontal: ref.watch(deviceSizeX).h * 0.2,
                                ),

                                decoration: BoxDecoration(
                                  color: ref.watch(lightMode)
                                      ? Colors.grey[100]
                                      : Colors.black26,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(color: Colors.transparent),
                                ),
                                child: Center(
                                  // borderRadius: BorderRadius.circular(14.r),
                                  child: Scrollbar(
                                    controller: scrollControllerForWelcomeText,
                                    thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller:
                                          scrollControllerForWelcomeText,
                                      padding: EdgeInsets.all(16.r),
                                      physics: BouncingScrollPhysics(),
                                      child: Text(
                                        ref.read(oneTimeAiAnalysis),
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: ref.watch(foreGroundColor),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: _autoGoDownForListview,
                            itemCount:
                                ref.watch(userAITempChatHolder)['user']!.isEmpty
                                ? 1
                                : ref
                                          .watch(userAITempChatHolder)['user']
                                          ?.length ??
                                      0,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: ref.watch(deviceSizeY).w,
                                child: Column(
                                  children: [
                                    ref
                                            .watch(
                                              userAITempChatHolder,
                                            )['user']!
                                            .isEmpty
                                        ? SizedBox()
                                        : Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                colors: ref.watch(lightMode)
                                                    ? [
                                                        ref.watch(
                                                          backgroundColor,
                                                        ),
                                                        Color.fromARGB(
                                                          255,
                                                          191,
                                                          194,
                                                          250,
                                                        ),

                                                        ref.watch(
                                                          foreGroundColor,
                                                        ),
                                                      ]
                                                    : [
                                                        ref.watch(
                                                          backgroundColor,
                                                        ),
                                                        const Color.fromARGB(
                                                          255,
                                                          29,
                                                          64,
                                                          82,
                                                        ),
                                                        const Color.fromARGB(
                                                          255,
                                                          33,
                                                          75,
                                                          34,
                                                        ),
                                                      ],
                                              ),
                                            ),
                                            width:
                                                0.95 * ref.watch(deviceSizeY).w,
                                            child: SelectableText(
                                              ref.watch(
                                                userAITempChatHolder,
                                              )['user']![index],
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: ref.watch(lightMode)
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),

                                    ref
                                            .watch(
                                              userAITempChatHolder,
                                            )['user']!
                                            .isEmpty
                                        ? SizedBox()
                                        : Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                colors: ref.watch(lightMode)
                                                    ? [
                                                        ref.watch(
                                                          foreGroundColor,
                                                        ),

                                                        Color.fromARGB(
                                                          255,
                                                          191,
                                                          194,
                                                          250,
                                                        ),
                                                        ref.watch(
                                                          backgroundColor,
                                                        ),
                                                      ]
                                                    : [
                                                        const Color.fromARGB(
                                                          255,
                                                          33,
                                                          75,
                                                          34,
                                                        ),
                                                        const Color.fromARGB(
                                                          255,
                                                          29,
                                                          64,
                                                          82,
                                                        ),
                                                        ref.watch(
                                                          backgroundColor,
                                                        ),
                                                      ],
                                              ),
                                            ),
                                            width:
                                                0.95 * ref.watch(deviceSizeY).w,
                                            child: SelectableText(
                                              ref.watch(
                                                userAITempChatHolder,
                                              )['AI']![index],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: ref.watch(lightMode)
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                    (awaiting &&
                                                ref
                                                            .watch(
                                                              userAITempChatHolder,
                                                            )['user']!
                                                            .length -
                                                        1 ==
                                                    index) ||
                                            ref
                                                .watch(
                                                  userAITempChatHolder,
                                                )['user']!
                                                .isEmpty
                                        ? Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                colors: ref.watch(lightMode)
                                                    ? [
                                                        ref.watch(
                                                          backgroundColor,
                                                        ),
                                                        Color.fromARGB(
                                                          255,
                                                          191,
                                                          194,
                                                          250,
                                                        ),

                                                        ref.watch(
                                                          foreGroundColor,
                                                        ),
                                                      ]
                                                    : [
                                                        ref.watch(
                                                          backgroundColor,
                                                        ),
                                                        const Color.fromARGB(
                                                          255,
                                                          29,
                                                          64,
                                                          82,
                                                        ),
                                                        const Color.fromARGB(
                                                          255,
                                                          33,
                                                          75,
                                                          34,
                                                        ),
                                                      ],
                                              ),
                                            ),
                                            width:
                                                0.95 * ref.watch(deviceSizeY).w,
                                            child: SelectableText(
                                              userTextToSend,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ref.watch(lightMode)
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    (awaiting &&
                                                ref
                                                            .watch(
                                                              userAITempChatHolder,
                                                            )['user']!
                                                            .length -
                                                        1 ==
                                                    index) ||
                                            ref
                                                .watch(
                                                  userAITempChatHolder,
                                                )['user']!
                                                .isEmpty
                                        ? Container(
                                            color: Colors.transparent,
                                            width: ref.read(deviceSizeY),
                                            height:
                                                0.04 * ref.read(deviceSizeY),
                                            child: BouncingDots(),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: ref.watch(deviceSizeY) * 0.4.w,
                        // height: 100,
                        child: TextFormField(
                          style: TextStyle(
                            color: ref.watch(lightMode)
                                ? Colors.black
                                : Colors.white,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          controller: _userInput,
                          minLines: 1,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: hintText,
                            fillColor: ref.watch(backgroundColor),
                            hoverColor: ref.watch(backgroundColor),
                            focusColor: ref.watch(backgroundColor),
                            filled: true,
                          ),
                        ),
                      ),
                      onpressedIcon(
                        shortestSize: _shortestSize,
                        color: awaiting
                            ? Colors.grey
                            : ref.watch(foreGroundColor),
                        iconData: awaiting ? Icons.stop : Icons.send,
                        onTap: () {
                          if (awaiting) {
                            scrollToBottom();
                            cancelSending = true;
                            ref.read(userAITempChatHolder.notifier).update((
                              state,
                            ) {
                              return {
                                'user': [...?state['user'], userTextToSend],
                                'AI': [
                                  ...?state['AI'],
                                  'You Stopped the response',
                                ],
                              };
                            });
                            awaiting = false;
                            scrollToBottom();
                          } else {
                            cancelSending = false;
                            send();
                          }
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      'AI may be inaccurate\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _shortestSize * 0.040 < 16.45 ? 13 : 15,
                        color: ref.watch(foreGroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0.01 * ref.watch(deviceSizeY),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
                // margin: EdgeInsets.all(10),
                width: navBarActive ? navBarMaxWidth : 0,
                height: navBarActive
                    ? (0.25 * ref.watch(deviceSizeY)).h
                    : 0, //,
                decoration: BoxDecoration(
                  color: ref.watch(foreGroundColor),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        ref.read(aiNavBarContent).length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              ref.read(aiNavBarContent)[index][1]();
                              setState(() {
                                awaiting = false;
                                removeLogo = false;
                                if (index == 0) {
                                  navBarActive = false;
                                  _userInput.text = '';
                                  userTextToSend = '';
                                }
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: navBarActive
                                  ? (0.4 * ref.read(deviceSizeY)).w
                                  : 0,
                              height: navBarActive
                                  ? (0.25 *
                                            ref.watch(deviceSizeY) /
                                            (ref.watch(aiNavBarContent).length *
                                                2))
                                        .h
                                  : 0,
                              child: Center(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  ref.watch(aiNavBarContent)[index][0],
                                  style: TextStyle(
                                    color: ref.watch(backgroundColor),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//AI GENERATED Bouncing Dots Widget, used in AiChat when the bot is "typing" a response. It creates a simple animation of three dots bouncing up and down to indicate that the bot is processing the user's input and generating a response. The animation is achieved using Flutter's AnimationController and Tween classes, with a staggered start for each dot to create a more dynamic effect.
//COME BACK TP UNDERSTAND THIS BETTER, I DONT FULLY GET IT YET, BUT IT WORKS AND LOOKS GOOD SO IM NOT TOO WORRIED ABOUT IT. I THINK I GET THE GENERAL IDEA OF HOW IT WORKS THOUGH, ITS JUST THE DETAILS OF THE ANIMATION THAT I DONT FULLY UNDERSTAND YET. I THINK IT HAS TO DO WITH THE CURVE AND THE TWEEN, BUT IM NOT 100% SURE HOW THEY WORK TOGETHER TO CREATE THE BOUNCING EFFECT. ILL HAVE TO PLAY AROUND WITH IT MORE TO FULLY UNDERSTAND IT.
class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key});

  @override
  _BouncingDotsState createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(
        reverse: true,
      ); //the .. mean performing a request istead of returning void, it gives back the return on the data itself ; like mylist.add() returns void but mylist..add() returns the list itself after adding the element
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -10).animate(
        CurvedAnimation(
          parent: controller,
          // Curves.easeInOut makes the transition at the top and bottom
          // feel smooth and "springy" instead of a hard robotic stop.
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Stagger the start of each dot
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].repeat();
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

final aiChatResponse = FutureProvider.family((ref, Map dataToUse) async {
  final email = lookForSettingBox().get("backupEmail");
  final password = lookForSettingBox().get("backupPassword");
  final _username = ref.read(username);
  final url = Uri.parse(
    "${ref.read(domain)}ai/?email=${email}&password=${password}&username=${_username}",
  );
  final request = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "history": ref.read(userAITempChatHolder),
      "message": dataToUse["message"],
    }),
  );
  final decoded = await jsonDecode(request.body);

  return [request.statusCode, decoded];
});
final userAITempChatHolder = StateProvider<Map>((ref) {
  return {"user": [], "AI": []};
});
final aiNavBarContent = StateProvider<List>((ref) {
  return [];
});
