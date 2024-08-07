import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradetrove/models/comment.dart';
import 'package:tradetrove/models/product.dart';
import 'package:tradetrove/models/favorite.dart';
import 'package:tradetrove/services/product.dart';
import 'package:tradetrove/services/registration_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _currentUserName;
  String? _currentUserId;
  final TextEditingController _commentController = TextEditingController();
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _checkIfFavoritedFromPrefs();
  }

  Future<void> _loadCurrentUser() async {
    String? userName = await RegistrationService.getCurrentUserName();
    String? userId = AuthService.currentUserId;
    setState(() {
      _currentUserName = userName;
      _currentUserId = userId;
    });
  }

  Future<void> _checkIfFavoritedFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFavorited = prefs.getBool('favorite_${widget.product.id}');
    if (isFavorited != null) {
      setState(() {
        _isFavorited = isFavorited!;
      });
    } else {
      _checkIfFavorited();
    }
  }

  Future<void> _checkIfFavorited() async {
    if (_currentUserId != null) {
      bool isFavorited = await ProductService.isProductFavoritedByUser(
          widget.product.id!, _currentUserId!);
      setState(() {
        _isFavorited = isFavorited;
      });
    }
  }

  void _toggleFavorite() async {
    if (_currentUserId == null) {
      return;
    }

    try {
      setState(() {
        _isFavorited = !_isFavorited;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('favorite_${widget.product.id}', _isFavorited);

      if (_isFavorited) {
        await ProductService.addFavorite(
            Favorite(productId: widget.product.id!, userId: _currentUserId!));
      } else {
        await ProductService.removeFavorite(
            widget.product.id!, _currentUserId!);
      }
    } catch (error) {
      print('Error toggling favorite: $error');
      setState(() {
        _isFavorited = !_isFavorited;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty ||
        _currentUserId == null ||
        _currentUserName == null) {
      return;
    }
    Comment newComment = Comment(
      productId: widget.product.id!,
      userId: _currentUserId!,
      userName: _currentUserName!,
      text: _commentController.text,
      createdAt: Timestamp.now(),
    );
    await ProductService.addComment(newComment);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.product.urlImage != null &&
                Uri.parse(widget.product.urlImage!).isAbsolute)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  widget.product.urlImage!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ListTile(
              title: Text(
                widget.product.merk,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp${widget.product.harga}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Tahun: ${widget.product.tahun}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/bahanBakar.png',
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${widget.product.bahanBakar}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 20),
                      Image.asset(
                        'assets/images/jarakTempuh.png',
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${widget.product.jarakTempuh}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          _openMap(widget.product.lat, widget.product.lng);
                        },
                        icon: Image.asset(
                          'assets/images/lokasi.png',
                          width: 50,
                          height: 50,
                        ),
                        tooltip: 'Open Location',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: _isFavorited
                              ? Colors.red
                              : theme.iconTheme.color,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (widget.product.userName == _currentUserName)
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: const Text('Delete Product'),
              ),
            SizedBox(height: 20),
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            StreamBuilder<List<Comment>>(
              stream: ProductService.getProductComments(widget.product),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No comments yet.',
                      style: TextStyle(color: textColor));
                }
                List<Comment> comments = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    Comment comment = comments[index];
                    return ListTile(
                      title: Text(comment.userName, style: TextStyle(color: textColor)),
                      subtitle: Text(comment.text, style: TextStyle(color: textColor)),
                      trailing: comment.userId == _currentUserId
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteComment(comment.id!);
                              },
                            )
                          : null,
                    );
                  },
                );
              },
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment',
                labelStyle: TextStyle(color: textColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: textColor),
                  onPressed: _addComment,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap(String? lat, String? lng) async {
    final Uri uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (!await canLaunch(uri.toString())) {
      throw 'Could not launch $uri';
    }
    await launch(uri.toString());
  }

  void _showConfirmationDialog(BuildContext context) {
    final Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("No"),
    );
    final Widget continueButton = ElevatedButton(
      onPressed: () {
        ProductService.deleteProduct(widget.product).whenComplete(() {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      },
      child: const Text("Yes"),
    );

    final AlertDialog alert = AlertDialog(
      title: const Text("Delete Product"),
      content: const Text("Are you sure you want to delete this product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _deleteComment(String commentId) async {
    await ProductService.deleteComment(commentId);
  }
}