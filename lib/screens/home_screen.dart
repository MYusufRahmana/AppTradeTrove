import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradetrove/models/product.dart';
import 'package:tradetrove/screens/detail_sellProduct.dart';
import 'package:tradetrove/services/product.dart';
import 'package:tradetrove/services/registration_service.dart';
import 'package:tradetrove/services/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RegistrationService getUser = RegistrationService();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    String? userName = await RegistrationService.getCurrentUserName();
    setState(() {
      _currentUserName = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TradeTrove'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey[800]
                    : const Color.fromRGBO(222, 205, 249, 1),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: ProductList(searchText: _searchText, currentUserName: _currentUserName),
    );
  }
}

class ProductList extends StatelessWidget {
  final String searchText;
  final String? currentUserName;

  const ProductList({Key? key, required this.searchText, required this.currentUserName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<List<Product>>(
      stream: ProductService.getProductList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No products found'),
              );
            }
            var filteredProducts = snapshot.data!.where((document) {
              var lowerCaseMerk = document.merk.toLowerCase();
              return lowerCaseMerk.contains(searchText);
            }).toList();

            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: filteredProducts.map<Widget>((document) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  child: InkWell(
                    onTap: () {
                      _navigateToProductDetail(context, document);
                    },
                    child: Column(
                      children: [
                        if (document.urlImage != null && Uri.parse(document.urlImage!).isAbsolute)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              document.urlImage!,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 150,
                            ),
                          ),
                        ListTile(
                          title: Text(
                            document.merk,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rp.${document.harga}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                document.tahun,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white70 : Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${document.userName}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white70 : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (document.lat != null && document.lng != null)
                                    InkWell(
                                      onTap: () {
                                        openMap(document.lat, document.lng);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Icon(Icons.maps_home_work_outlined),
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Icon(
                                        Icons.maps_home_work_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  if (document.userName == currentUserName)
                                    InkWell(
                                      onTap: () {
                                        showAlertDialog(context, document);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Icon(Icons.delete),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }

  Future<void> openMap(String? lat, String? lng) async {
    Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  showAlertDialog(BuildContext context, Product document) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Yes"),
      onPressed: () {
        ProductService.deleteProduct(document).whenComplete(() {
          Navigator.of(context).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Note"),
      content: const Text("Are you sure to delete Note?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}