class Product {
  String? id;
  String? url;
  String? title;
  String? price;
  Product({this.id, this.url, this.price, this.title});
  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['price'] = this.price;
    return data;
  }

  Product.toProduct(Map product) {
    id = product['id'];
    title = product['title'];
    url = product['thumbnail'];
    price = product['price'];
  }

  // static Product toProduct(Map product) {
  //   // print(product['id']);
  //   // print(product['title']);
  //   // print(product['thumbnail']);
  //   // print(product['price']);
  //   Product prod = Product(
  //     id: product['id'],
  //     title: product['title'],
  //     url: product['thumbnail'],
  //     price: product['price'],
  //   );
  //   print(prod.id);
  //   print(prod.title);
  //   print(prod.url);
  //   print(prod.price);
  //   return prod;
  // }
}
