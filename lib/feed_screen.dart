import 'package:flutter/material.dart';
import 'api_service.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final posts = await ApiService.getPosts();
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اینستاگرام ایرانی', style: TextStyle(fontFamily: 'Vazir')),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadPosts),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(child: Text(post['username'][0].toUpperCase())),
                          title: Text(post['username'], style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        // نمایش تصویر ارسالی از سرور ایران
                        Image.network(
                          post['image_url'],
                          fit: BoxFit.cover,
                          height: 300,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 200, color: Colors.grey[300], child: Icon(Icons.broken_image)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            post['caption'] ?? '',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
