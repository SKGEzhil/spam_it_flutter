import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models.dart';

class SharedPrefs {
  SharedPreferences? _sharedPrefs;

  Future<int> checkFirstLaunch() async {
    _sharedPrefs = await SharedPreferences.getInstance();

    // Check if the 'firstLaunch' key exists
    bool firstLaunch = _sharedPrefs?.getBool('firstLaunch') ?? true;

    // Update the flag for subsequent launches
    if (firstLaunch) {
      print("first time");
      return 1;
    } else {
      print("not first time");
      return 0;
    }
  }

  Future<void> setFirstLaunch() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs?.setBool('firstLaunch', false);
  }

  Future<void> logout() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    List<String> postListString = [];
    await _sharedPrefs?.setBool('firstLaunch', true);
    await _sharedPrefs!.setString('roll_no', '');
    await _sharedPrefs!.setString('username', '');
    await _sharedPrefs!.setStringList('posts', postListString);
  }

  Future<void> init() async =>
      _sharedPrefs = await SharedPreferences.getInstance();

  Future<void> setRollNo(String roll_no) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('roll_no', roll_no);
  }

  Future<String> getRollNo() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final rollno = await _sharedPrefs!.getString('roll_no') ?? '';
    return rollno;
  }

  Future<void> setUsername(String username) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('username', username);
  }

  Future<String> getUsername() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final username = await _sharedPrefs!.getString('username') ?? '';
    return username;
  }

  Future<void> storePosts(List<Post> posts) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    List<String> postListString =
        posts.map((post) => json.encode(post.toJson())).toList();
    postListString.forEach((element) async {
      print('element: $element');
    });
    await _sharedPrefs!.setStringList('posts', postListString);
  }

  Future<List<Post>> getPosts() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    List<String> postListString = _sharedPrefs!.getStringList('posts') ?? [];
    List<Post> posts =
        postListString.map((post) => Post.fromJson(json.decode(post))).toList();
    return posts;
  }

  // set auth token
  Future<void> setAuthToken(String token) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs!.setString('auth_token', token);
  }

  // get auth token
  Future<String> getAuthToken() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    final token = await _sharedPrefs!.getString('auth_token') ?? '';
    return token;
  }

}
