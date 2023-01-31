// // Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_player_iframe_example/video_list_page.dart';

// import 'widgets/meta_data_section.dart';
// import 'widgets/play_pause_button_bar.dart';
// import 'widgets/player_state_section.dart';
// import 'widgets/source_input_section.dart';

// const List<String> _videoIds = [
//   'tcodrIK2P_I',
//   'H5v3kku4y6Q',
//   'nPt8bK2gbaU',
//   'K18cpp_-gP8',
//   'iLnmTe5Q2Qw',
//   '_WoCV4c6XOE',
//   'KmzdUe0RSJo',
//   '6jZDSSZZxjQ',
//   'p2lYr3vM_1w',
//   '7QUtEmBT_-w',
//   '34_PXCzGw1M'
// ];

// Future<void> main() async {
//   runApp(YoutubeApp());
// }

// ///
// class YoutubeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Youtube Player IFrame Demo',
//       theme: ThemeData.from(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: YoutubeAppDemo(),
//     );
//   }
// }

// ///
// class YoutubeAppDemo extends StatefulWidget {
//   @override
//   _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
// }

// class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       params: const YoutubePlayerParams(
//         showControls: true,
//         mute: false,
//         showFullscreenButton: true,
//         loop: false,
//       ),
//     );

//     _controller.setFullScreenListener(
//       (isFullScreen) {
//         log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
//       },
//     );

//     _controller.loadPlaylist(
//       list: _videoIds,
//       listType: ListType.playlist,
//       startSeconds: 136,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerScaffold(
//       controller: _controller,
//       builder: (context, player) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Youtube Player IFrame Demo'),
//             actions: const [VideoPlaylistIconButton()],
//           ),
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               if (kIsWeb && constraints.maxWidth > 750) {
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Column(
//                         children: [
//                           player,
//                           const VideoPositionIndicator(),
//                         ],
//                       ),
//                     ),
//                     const Expanded(
//                       flex: 2,
//                       child: SingleChildScrollView(
//                         child: Controls(),
//                       ),
//                     ),
//                   ],
//                 );
//               }

//               return ListView(
//                 children: [
//                   player,
//                   const VideoPositionIndicator(),
//                   const Controls(),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.close();
//     super.dispose();
//   }
// }

// ///
// class Controls extends StatelessWidget {
//   ///
//   const Controls();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MetaDataSection(),
//           _space,
//           SourceInputSection(),
//           _space,
//           PlayPauseButtonBar(),
//           _space,
//           const VideoPositionSeeker(),
//           _space,
//           PlayerStateSection(),
//         ],
//       ),
//     );
//   }

//   Widget get _space => const SizedBox(height: 10);
// }

// ///
// class VideoPlaylistIconButton extends StatelessWidget {
//   ///
//   const VideoPlaylistIconButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.ytController;

//     return IconButton(
//       onPressed: () async {
//         controller.pauseVideo();
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const VideoListPage(),
//           ),
//         );
//         controller.playVideo();
//       },
//       icon: const Icon(Icons.playlist_play_sharp),
//     );
//   }
// }

// ///
// class VideoPositionIndicator extends StatelessWidget {
//   ///
//   const VideoPositionIndicator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.ytController;

//     return StreamBuilder<YoutubeVideoState>(
//       stream: controller.videoStateStream,
//       initialData: const YoutubeVideoState(),
//       builder: (context, snapshot) {
//         final position = snapshot.data?.position.inMilliseconds ?? 0;
//         final duration = controller.metadata.duration.inMilliseconds;

//         return LinearProgressIndicator(
//           value: duration == 0 ? 0 : position / duration,
//           minHeight: 1,
//         );
//       },
//     );
//   }
// }

// ///
// class VideoPositionSeeker extends StatelessWidget {
//   ///
//   const VideoPositionSeeker({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var value = 0.0;

//     return Row(
//       children: [
//         const Text(
//           'Seek',
//           style: TextStyle(fontWeight: FontWeight.w300),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: StreamBuilder<YoutubeVideoState>(
//             stream: context.ytController.videoStateStream,
//             initialData: const YoutubeVideoState(),
//             builder: (context, snapshot) {
//               final position = snapshot.data?.position.inSeconds ?? 0;
//               final duration = context.ytController.metadata.duration.inSeconds;

//               value = position == 0 || duration == 0 ? 0 : position / duration;

//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return Slider(
//                     value: value,
//                     onChanged: (positionFraction) {
//                       value = positionFraction;
//                       setState(() {});

//                       context.ytController.seekTo(
//                         seconds: (value * duration).toDouble(),
//                         allowSeekAhead: true,
//                       );
//                     },
//                     min: 0,
//                     max: 1,
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'video_argument.dart';
import 'youtube_player_detail.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DemoApp(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _DemoAppState.generateRoute,
    );
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  static String key = "AIzaSyCYe-UdxucmI9tuu0i33_kwef_ZyAeQ7S0";
  static const String YOUTUBE_PLAYER_DETAIL = 'youtube_player_detail';

  YoutubeAPI youtube = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];
  final TextEditingController _searchActionController = TextEditingController();

  Future<void> callAPI() async {
    videoResult = await youtube.nextPage();
    var regionCode = 'VN';
    videoResult = await youtube.getTrends(regionCode: regionCode);
    print("aaaa");
    setState(() {});
  }

  Future<void> callAPISearch() async {
    var query = _searchActionController.text;
    videoResult = await youtube.search(
      query,
      order: 'relevance',
      videoDuration: 'any',
    );
    print("bbbb");
    setState(() {});
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case YOUTUBE_PLAYER_DETAIL:
        return MaterialPageRoute(
          builder: (_) => YoutubePlayerDetail(
            args: settings.arguments as VideoArgument,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    callAPI();
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            Row(
              children: [
                // Image.asset("assets/icons/ic_logo_youtube.png", width: 100),
                const Icon(Icons.play_arrow, size: 100),
                const SizedBox(width: 20),
              ],
            ),
            Expanded(
              flex: 10,
              child: TextField(
                onSubmitted: (_) => callAPISearch(),
                controller: _searchActionController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Tìm kiếm',
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: callAPISearch,
                icon: const Icon(Icons.search),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[800],
      ),
      body: ListView(
        children: videoResult.map<Widget>(listItem).toList(),
      ),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return InkWell(
      onTap: () {
        // launchUrl(Uri.parse(video.url));
        final argument = VideoArgument(id: video.id!, url: video.url);
        Navigator.pushNamed(
          context,
          YOUTUBE_PLAYER_DETAIL,
          arguments: argument,
        );
      },
      child: Container(
        color: Colors.black,
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.network(
                video.thumbnail.small.url ?? '',
                width: 120.0,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    video.title,
                    softWrap: true,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                      video.channelTitle,
                      softWrap: true,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    video.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

