// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_iframe_example/video_argument.dart';

///
class SourceInputSection extends StatefulWidget {
  final VideoArgument args;
  const SourceInputSection({required this.args});
  @override
  _SourceInputSectionState createState() => _SourceInputSectionState();
}

class _SourceInputSectionState extends State<SourceInputSection> {
  late TextEditingController _textController;
  ListType? _playlistType;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.text = widget.args.url;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlaylistTypeDropDown(
          onChanged: (type) {
            _playlistType = type;
            setState(() {});
          },
        ),
        const SizedBox(height: 10),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _hint,
              helperText: _helperText,
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              filled: true,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w300,
                  ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _textController.clear(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: [
            _Button(
              action: 'Load',
              onTap: () {
                context.ytController.loadVideoById(
                  videoId: _cleanId(_textController.text) ?? '',
                );
              },
            ),
            _Button(
              action: 'Cue',
              onTap: () {
                context.ytController.cueVideoById(
                  videoId: _cleanId(_textController.text) ?? '',
                );
              },
            ),
            _Button(
              action: 'Load Playlist',
              onTap: _playlistType == null
                  ? null
                  : () {
                      context.ytController.loadPlaylist(
                        list: [_textController.text],
                        listType: _playlistType!,
                      );
                    },
            ),
            _Button(
              action: 'Cue Playlist',
              onTap: _playlistType == null
                  ? null
                  : () {
                      context.ytController.cuePlaylist(
                        list: [_textController.text],
                        listType: _playlistType!,
                      );
                    },
            ),
          ],
        ),
      ],
    );
  }

  String? get _helperText {
    switch (_playlistType) {
      case ListType.playlist:
        return '"PLj0L3ZL0ijTdhFSueRKK-mLFAtDuvzdje", ...';
      case ListType.userUploads:
        return '"pewdiepie", "tseries"';
      default:
        return null;
    }
  }

  String get _hint {
    switch (_playlistType) {
      case ListType.playlist:
        return 'Enter playlist id';
      case ListType.userUploads:
        return 'Enter channel name';
      default:
        return r'Enter youtube <video id> or <link>';
    }
  }

  String? _cleanId(String source) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return YoutubePlayerController.convertUrlToId(source);
    } else if (source.length != 11) {
      _showSnackBar('Invalid Source');
    }
    return source;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _PlaylistTypeDropDown extends StatefulWidget {
  const _PlaylistTypeDropDown({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<ListType?> onChanged;

  @override
  _PlaylistTypeDropDownState createState() => _PlaylistTypeDropDownState();
}

class _PlaylistTypeDropDownState extends State<_PlaylistTypeDropDown> {
  ListType? _playlistType;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ListType>(
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        filled: true,
      ),
      isExpanded: true,
      value: _playlistType,
      items: [
        DropdownMenuItem(
          child: Text(
            'Select playlist type',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w300,
                ),
          ),
        ),
        ...ListType.values.map(
          (type) => DropdownMenuItem(child: Text(type.value), value: type),
        ),
      ],
      onChanged: (value) {
        _playlistType = value;
        setState(() {});
        widget.onChanged(value);
      },
    );
  }
}

class _Button extends StatelessWidget {
  final VoidCallback? onTap;
  final String action;

  const _Button({
    Key? key,
    required this.onTap,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap == null
          ? null
          : () {
              onTap?.call();
              FocusScope.of(context).unfocus();
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(action),
      ),
    );
  }
}
