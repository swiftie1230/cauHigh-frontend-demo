import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'new_post_page.dart';
import 'styles/main_title_text.dart';
import 'styles/sub_title_text.dart';
import 'class_post_list.dart';
import 'models/post.dart';
import 'models/simple_class_post.dart';
import 'models/main_user.dart';
import 'models/DB.dart';

class ClassBoardPage extends StatefulWidget {
  final MainUser user;
  final int year;
  final int gradeYear;
  final int classGroup;
  const ClassBoardPage({
    Key? key,
    required this.year,
    required this.user,
    required this.gradeYear,
    required this.classGroup,
  }) : super(key: key);

  @override
  State<ClassBoardPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<ClassBoardPage> {
  List<SimpleClassPost> _postList = [];
  String boardUrl = "";
  _PostListPageState();

  void _transition(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPostPage(
            _addNewPost,
            user: widget.user,
          ),
        ),
      );

  void _addNewPost(Post newPost) async {
    _postPost(newPost);
    await _getPostList();
    setState(() {
      _postList.add(SimpleClassPost.fromPost(newPost));
    });
  }

  Future<List<SimpleClassPost>> _getPostList() async {
    boardUrl =
        '${widget.year}${widget.gradeYear}${widget.classGroup.toString().padLeft(2, '0')}';
    http.Response response = await http.get(
      Uri(
        scheme: 'http',
        host: 'ec2-44-242-141-79.us-west-2.compute.amazonaws.com',
        port: 9090,
        path: 'api/classes/$boardUrl',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': widget.user.token,
      },
    );

    var statusCode = response.statusCode;
    var responseBody = utf8.decode(response.bodyBytes);

    switch (statusCode) {
      case 200:
        var parsed = jsonDecode(responseBody) as List;
        return parsed.map((e) => SimpleClassPost.fromJson(e)).toList();
      case 204:
        return <SimpleClassPost>[];
      default:
        DB.errorCode(statusCode, context);
        throw Exception('$statusCode');
    }
  }

  void _postPost(Post newPost) async {
    var data = jsonEncode({
      'title': newPost.title,
      'description': newPost.description,
      'published': newPost.published,
      'anonymous': newPost.anonymous,
      'images': newPost.images,
    });
    http.Response response = await http.post(
        Uri(
          scheme: 'http',
          host: 'ec2-44-242-141-79.us-west-2.compute.amazonaws.com',
          port: 9090,
          path: 'api/classes/$boardUrl',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.user.token,
        },
        body: data);

    var statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        break;
      default:
        DB.errorCode(statusCode, context);
        throw Exception('$statusCode');
    }
  }

  Widget _title() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF3D5D54),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              MainTitle(
                title: "CLASS BOARD",
                theme: Color(0xFF3D5D54),
              ),
              SubTitle(
                title: "반 게시판",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header() {
    var classPhoto = Flexible(
      fit: FlexFit.tight,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(Post.defaultPhotoUrl),
            ),
          ),
        ),
      ),
    );

    var classPostsNum = Flexible(
      fit: FlexFit.tight,
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MainTitle(
                title: _postList.length.toString(),
                size: 20,
                theme: const Color(0xFF3D5D54),
              ),
              const Text("Posts"),
            ],
          ),
        ),
      ),
    );
    var classStudentsNum = Flexible(
      fit: FlexFit.tight,
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              MainTitle(
                title: "10",
                size: 20,
                theme: Color(0xFF3D5D54),
              ),
              Text("Students"),
            ],
          ),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainTitle(
            title: "${widget.gradeYear} - ${widget.classGroup}",
            theme: const Color(0xFF3D5D54),
            size: 30,
          ),
          Row(
            children: [classPhoto, classPostsNum, classStudentsNum],
          )
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Expanded(
      //height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
            future: _getPostList(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF3D5D54),
                  )),
                );
              }
              if (snapshot.data == null) {
                return const SubTitle(title: "데이터를 불러오는데 실패하였습니다.");
              }
              _postList = snapshot.data as List<SimpleClassPost>;
              return Column(
                children: [
                  _header(),
                  Expanded(
                      child: ClassPostList(
                    _postList,
                    user: widget.user,
                    boardName: "${widget.gradeYear}-${widget.classGroup}",
                    boardUrl: boardUrl,
                  )),
                ],
              );
            }),
          ),
          Positioned(
            bottom: 40,
            child: _TransitionButton(() => _transition(context)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _title(),
            _body(context),
          ],
        ),
      ),
    );
  }
}

class _TransitionButton extends StatelessWidget {
  final VoidCallback _callback;

  const _TransitionButton(this._callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(148, 34),
        backgroundColor: const Color(0xFF3D5D54),
        side: const BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      onPressed: _callback,
      child: const Text("글쓰기"),
    );
  }
}
