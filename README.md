# Toko Kita - TUGAS 9 PERTEMUAN 11

## 📱 Screenshots UI & Proses Step-by-Step

### 1. Proses Login

#### a. Form Login & Input Data
![Login Form](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Login+Form)

**Proses:**
- User membuka aplikasi dan melihat form login
- User menginputkan email dan password yang telah terdaftar

**Kode Form Login:**
```dart
Widget _emailTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Email"),
    keyboardType: TextInputType.emailAddress,
    controller: _emailTextboxController,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Email harus diisi';
      }
      return null;
    },
  );
}

Widget _passwordTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Password"),
    keyboardType: TextInputType.text,
    obscureText: true,
    controller: _passwordTextboxController,
    validator: (value) {
      if (value!.isEmpty) {
        return "Password harus diisi";
      }
      return null;
    },
  );
}
```

#### b. Validasi & Hasil Login

**Login Berhasil:**
![Login Success](https://via.placeholder.com/300x600/4CAF50/FFFFFF?text=Login+Success)

**Proses Login Berhasil:**
- Sistem memvalidasi email dan password dengan data tersimpan
- User diarahkan ke halaman List Produk

**Kode Proses Login:**
```dart
void _performLocalLogin() async {
  try {
    final userInfo = UserInfo();
    String? storedEmail = await userInfo.getEmail();
    String? storedPassword = await userInfo.getPassword();
    
    String inputEmail = _emailTextboxController.text;
    String inputPassword = _passwordTextboxController.text;
    
    if (storedEmail == inputEmail && storedPassword == inputPassword) {
      await userInfo.setToken("dummy_token");
      await userInfo.setUserID(1);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProdukPage()),
      );
    } else {
      // Login failed - show error dialog
    }
  } catch (error) {
    // Handle error
  }
}
```

**Login Gagal:**
![Login Failed](https://via.placeholder.com/300x600/F44336/FFFFFF?text=Login+Failed)

**Proses Login Gagal:**
- Sistem menampilkan dialog error "Login gagal, silahkan coba lagi"
- User dapat mencoba login kembali

**Kode Error Dialog:**
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (BuildContext context) => const WarningDialog(
    description: "Login gagal, silahkan coba lagi",
  ),
);
```

### 2. Proses Registrasi

#### a. Form Registrasi & Input Data
![Registration Form](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Registration+Form)

**Proses:**
- User mengklik link "Registrasi" dari halaman login
- User mengisi form dengan nama, email, password, dan konfirmasi password

**Kode Form Registrasi:**
```dart
Widget _namaTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Nama"),
    keyboardType: TextInputType.text,
    controller: _namaTextboxController,
    validator: (value) {
      if (value!.length < 3) {
        return "Nama harus diisi minimal 3 karakter";
      }
      return null;
    },
  );
}

Widget _passwordKonfirmasiTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Konfirmasi Password"),
    keyboardType: TextInputType.text,
    obscureText: true,
    validator: (value) {
      if (value != _passwordTextboxController.text) {
        return "Konfirmasi Password tidak sama";
      }
      return null;
    },
  );
}
```

#### b. Hasil Registrasi

**Registrasi Berhasil:**
![Registration Success](https://via.placeholder.com/300x600/4CAF50/FFFFFF?text=Registration+Success)

**Proses:**
- Sistem menyimpan kredensial user secara lokal
- Menampilkan dialog sukses dengan pesan "Registrasi berhasil, silahkan login"

**Kode Proses Registrasi:**
```dart
void _performLocalRegistration() async {
  try {
    final userInfo = UserInfo();
    await userInfo.setEmail(_emailTextboxController.text);
    await userInfo.setPassword(_passwordTextboxController.text);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SuccessDialog(
        description: "Registrasi berhasil, silahkan login",
        okClick: () {
          Navigator.pop(context);
        },
      ),
    );
  } catch (error) {
    // Handle registration error
  }
}
```

### 3. Halaman List Produk

#### a. Tampilan Daftar Produk
![Product List](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Product+List)

**Fitur:**
- AppBar biru dengan hamburger menu dan tombol tambah (+)
- Daftar produk dalam bentuk Card
- Drawer menu dengan opsi logout

**Kode List Produk:**
```dart
body: FutureBuilder<List>(
  future: ProdukBloc.getProduks(),
  builder: (context, snapshot) {
    if (snapshot.hasError) print(snapshot.error);
    return snapshot.hasData
        ? ListProduk(list: snapshot.data)
        : const Center(child: CircularProgressIndicator());
  },
)

class ItemProduk extends StatelessWidget {
  final Produk produk;
  const ItemProduk({Key? key, required this.produk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk!),
          subtitle: Text(produk.hargaProduk.toString()),
        ),
      ),
    );
  }
}
```

### 4. Proses Tambah Data Produk

#### a. Form Tambah Produk
![Add Product Form](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Add+Product+Form)

**Proses:**
- User mengklik tombol (+) di AppBar
- Sistem menampilkan form "TAMBAH PRODUK"
- User mengisi kode produk, nama produk, dan harga

**Kode Form Tambah:**
```dart
Widget _kodeProdukTextField() {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Kode Produk"),
    keyboardType: TextInputType.text,
    controller: _kodeProdukTextboxController,
    validator: (value) {
      if (value!.isEmpty) {
        return "Kode Produk harus diisi";
      }
      return null;
    },
  );
}

Widget _buttonSubmit() {
  return OutlinedButton(
    child: Text(tombolSubmit),
    onPressed: () {
      var validate = _formKey.currentState!.validate();
      if (validate) {
        if (!_isLoading) {
          if (widget.produk != null) {
            ubah(); // Update product
          } else {
            simpan(); // Create new product
          }
        }
      }
    },
  );
}
```

#### b. Proses Simpan Data

**Simpan Berhasil:**
![Save Success](https://via.placeholder.com/300x600/4CAF50/FFFFFF?text=Save+Success)

**Proses:**
- Sistem memvalidasi input form
- Data produk baru disimpan
- User diarahkan kembali ke halaman list produk

**Kode Simpan Data:**
```dart
simpan() {
  setState(() {
    _isLoading = true;
  });
  Produk createProduk = Produk(id: null);
  createProduk.kodeProduk = _kodeProdukTextboxController.text;
  createProduk.namaProduk = _namaProdukTextboxController.text;
  createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  
  ProdukBloc.addProduk(produk: createProduk).then(
    (value) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => const ProdukPage()),
      );
    },
    onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    },
  );
  setState(() {
    _isLoading = false;
  });
}
```

### 5. Proses Lihat Detail Produk

#### a. Halaman Detail Produk
![Product Detail](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Product+Detail)

**Proses:**
- User mengklik salah satu item produk dari list
- Sistem menampilkan detail produk (kode, nama, harga)
- Tersedia tombol EDIT dan DELETE

**Kode Detail Produk:**
```dart
body: Center(
  child: Column(
    children: [
      Text(
        "Kode : ${widget.produk!.kodeProduk}",
        style: const TextStyle(fontSize: 20.0),
      ),
      Text(
        "Nama : ${widget.produk!.namaProduk}",
        style: const TextStyle(fontSize: 18.0),
      ),
      Text(
        "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
        style: const TextStyle(fontSize: 18.0),
      ),
      _tombolHapusEdit(),
    ],
  ),
)
```

### 6. Proses Edit Data Produk

#### a. Form Edit Produk
![Edit Product Form](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Edit+Product+Form)

**Proses:**
- User mengklik tombol "EDIT" dari detail produk
- Form ditampilkan dengan data yang sudah terisi
- Judul berubah menjadi "UBAH PRODUK"

**Kode Inisialisasi Edit:**
```dart
isUpdate() {
  if (widget.produk != null) {
    setState(() {
      judul = "UBAH PRODUK";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
      _namaProdukTextboxController.text = widget.produk!.namaProduk!;
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk.toString();
    });
  } else {
    judul = "TAMBAH PRODUK";
    tombolSubmit = "SIMPAN";
  }
}
```

#### b. Proses Update Data

**Update Berhasil:**
![Update Success](https://via.placeholder.com/300x600/4CAF50/FFFFFF?text=Update+Success)

**Kode Update Data:**
```dart
ubah() {
  setState(() {
    _isLoading = true;
  });
  Produk updateProduk = Produk(id: widget.produk!.id!);
  updateProduk.kodeProduk = _kodeProdukTextboxController.text;
  updateProduk.namaProduk = _namaProdukTextboxController.text;
  updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  
  ProdukBloc.updateProduk(produk: updateProduk).then(
    (value) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => const ProdukPage()),
      );
    },
    onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    },
  );
  setState(() {
    _isLoading = false;
  });
}
```

### 7. Proses Hapus Data Produk

#### a. Konfirmasi Hapus
![Delete Confirmation](https://via.placeholder.com/300x600/FF9800/FFFFFF?text=Delete+Confirmation)

**Proses:**
- User mengklik tombol "DELETE" dari detail produk
- Sistem menampilkan dialog konfirmasi
- User memilih "Ya" atau "Batal"

**Kode Konfirmasi Hapus:**
```dart
void confirmHapus() {
  AlertDialog alertDialog = AlertDialog(
    content: const Text("Yakin ingin menghapus data ini?"),
    actions: [
      OutlinedButton(
        child: const Text("Ya"),
        onPressed: () {
          ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
            (value) => {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProdukPage()),
              ),
            },
            onError: (error) {
              showDialog(
                context: context,
                builder: (BuildContext context) => const WarningDialog(
                  description: "Hapus gagal, silahkan coba lagi",
                ),
              );
            },
          );
        },
      ),
      OutlinedButton(
        child: const Text("Batal"),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
  showDialog(builder: (context) => alertDialog, context: context);
}
```

#### b. Hasil Hapus Data

**Hapus Berhasil:**
![Delete Success](https://via.placeholder.com/300x600/4CAF50/FFFFFF?text=Delete+Success)

**Proses:**
- Data produk dihapus dari sistem
- User diarahkan kembali ke halaman list produk
- Produk yang dihapus tidak lagi muncul di list

### 8. Proses Logout

#### a. Menu Logout
![Logout Menu](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Logout+Menu)

**Proses:**
- User mengklik hamburger menu di AppBar
- User memilih opsi "Logout"

**Kode Logout:**
```dart
ListTile(
  title: const Text('Logout'),
  trailing: const Icon(Icons.logout),
  onTap: () async {
    await LogoutBloc.logout().then(
      (value) => {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        ),
      },
    );
  },
)
```

## 🏗️ Arsitektur Aplikasi

### Model Data
- **Produk**: Model dengan properti id, kodeProduk, namaProduk, hargaProduk
- **Login**: Model untuk response login
- **Registrasi**: Model untuk response registrasi

### BLoC Pattern
- **LoginBloc**: Menangani proses autentikasi
- **RegistrasiBloc**: Menangani proses registrasi
- **ProdukBloc**: Menangani CRUD operasi produk
- **LogoutBloc**: Menangani proses logout

### Helper Classes
- **UserInfo**: Mengelola penyimpanan data user (SharedPreferences)
- **Api**: Helper untuk HTTP requests
- **ApiUrl**: Konstanta URL endpoint API

### Widget Custom
- **WarningDialog**: Dialog untuk menampilkan pesan error
- **SuccessDialog**: Dialog untuk menampilkan pesan sukses