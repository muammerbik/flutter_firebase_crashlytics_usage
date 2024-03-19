import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/model/user_model.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/konusma_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/all_user_viewmodel.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // List<UserModel>? _allUserList = null;
  bool _isLoading = false; //intarnetten veri geliyormuyu kontrol etsin.
  bool _hasMore = true; // daha fazla veri akışı olacak mı?
  int _getirilecekElemanSayisi = 12;
  UserModel? _ensonGetirilenUser;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    //scrollController ın veriler geldikçe başta mı sonda mı olduğunu öğrendiğim yer.
    /*   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //daha context olusmadan verilerimi almaya çalıstığım için veriler gelmiyordu. çünkü build işlemii daha bitmeden verileri çağırdığım için. init state içindeki yapı context olustuktan hemen sonra verilerimi getiriyor.
    
    }); */
    super.initState();

    //minScrollExtent listenin en sonuna geldiğimizde oluşur.
    //maxSrollExtent listenin en üstüne geldiğimizde oluşur.
    scrollController.addListener(
      () {
        listeScrollListener();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users "),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: () => model.refreshIndicator(),
              child: ListView.builder(
                controller: scrollController,
                itemCount: model.hasMoreLoading
                    ? model.tumKullanicilerListesi.length + 1
                    : model.tumKullanicilerListesi.length,
                itemBuilder: (context, index) {
                  if (model.tumKullanicilerListesi == 1) {
                    return kulliciYokUI();
                  } else if (model.hasMoreLoading &&
                      index == model.tumKullanicilerListesi.length) {
                    return yeniElemanlarYukleniyorIndicator();
                  } else {
                    return userListesiElemanlariOlustur(index);
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),

      /*  _allUserList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : kullaniciListesiniOlustur(), */
    );
  }

/* 
  getUser() async {
    //       PAGİNATİON KULLANIMIDIR    .FİREBASE'DEN  KULLANICILARIN HEPSİNİ  BİRDEN GETİRMEK YERİNE BELLİ BİR KURALARA GÖRE GETİRMEMİZİ SAĞLIYOR.

    UserViewmodel _userModel =
        Provider.of<UserViewmodel>(context, listen: false);

    if (!_hasMore) {
      print("Firebase artık rahatsız edeilmeyeecccceeekkekk");

      return;
    }
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    List<UserModel> userss = await _userModel.getUserWithPagination(
        _ensonGetirilenUser, _getirilecekElemanSayisi);

    if (_ensonGetirilenUser == null) {
      _allUserList = [];
      _allUserList!.addAll(userss);
    } else {
      _allUserList!.addAll(userss);
    }

    if (userss.length < _getirilecekElemanSayisi) {
      _hasMore = false;
    }

    _ensonGetirilenUser = _allUserList!.last;
    print(" Enn soon getirilien user name " + _ensonGetirilenUser!.userName!);

    setState(
      () {
        _isLoading = false;
      },
    );
  }
 */
  /* kullaniciListesiniOlustur() {
    if (_allUserList!.length > 1) {
      return RefreshIndicator(
        onRefresh: () {
          return kullanicilarListesiReflesh();
        },
        child: ListView.builder(
          controller: scrollController,
          itemCount: _allUserList!.length + 1,
          itemBuilder: (context, index) {
            if (index == _allUserList!.length) {
              return yeniElemanlarYukleniyorIndicator();
            }
            return userListesiElemanlariOlustur(index);
          },
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          return kullanicilarListesiReflesh();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - 150,
            child: Center(
              child: Text(
                "Kayıtlı kullanıcı bulunamadı!",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      );
    }
  }
 */

  Widget kulliciYokUI() {
    AllUserViewModel tumKullanicilerViewmodel =
        Provider.of<AllUserViewModel>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () async {
        return tumKullanicilerViewmodel.refreshIndicator();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 150,
          child: Center(
            child: Text(
              "Kayıtlı kullanıcı bulunamadı!",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
/* 
  Future<Null> kullanicilarListesiReflesh() async {
    _hasMore = true;
    _ensonGetirilenUser = null;
 
  } */

  userListesiElemanlariOlustur(index) {
    UserViewmodel _userModel =
        Provider.of<UserViewmodel>(context, listen: false);
    AllUserViewModel tumKullanicilerViewmodel =
        Provider.of<AllUserViewModel>(context, listen: false);
    var oankiUser = tumKullanicilerViewmodel.tumKullanicilerListesi[index];
    if (oankiUser.userId == _userModel.userModel!.userId) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => KonusmaPage(
                currentUser: _userModel.userModel!,
                sohbetEdilenUser: oankiUser),
          ),
        );
      },
      child: Card(
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: Text(
              oankiUser.userName!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(oankiUser.email),
            leading: CircleAvatar(
                backgroundColor: Colors.grey.withAlpha(20),
                backgroundImage: NetworkImage(oankiUser.profilUrl!)),
          ),
        ),
      ),
    );
  }

  void dahaFazlaKullaniciGetir() async {
    if (_isLoading == false) {
      _isLoading == true;
      final AllUserViewModel tumKullanicilerViewmodel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await tumKullanicilerViewmodel.dahaFazlaGetir();
      _isLoading == false;
    }
  }

  void listeScrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      dahaFazlaKullaniciGetir();
    }
  }
}


 
    
   


/* 
FutureBuilder kullanarak çağırdığım getAllUser methodu tüm kullanıcıların hepsini bir anda getiriyor.eğer benim 300bin kullanıcım olsaydı hepsini birden getirseydi firebase okumasında ciddi maliyete sebep olacatı. bu nedenle verilerin hepsini birden çağırmak yerine kullanılacağı kadar çağırmak : örneğin 15er ya da 10 ar çağırmak uygulamayı daha dinamik ve sürdürülebilir kılacaktır. Bu isteğimizi ((pagination ))ile gerçekleştireceğimmm.



import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/pages/konusma_page.dart';
import 'package:flutter_firebase_crashlytics_usage/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    UserViewmodel _userModel = Provider.of<UserViewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("KULLANICILAR SAYAFASI"),
      ),
      body: FutureBuilder(
        future: _userModel.getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var tumKullanicilar = snapshot.data!;
            if (tumKullanicilar.length - 1 > 0) {
              return RefreshIndicator(
                onRefresh: () {
                  return refleshPerson();
                },
                child: ListView.builder(
                  itemCount: tumKullanicilar.length,
                  itemBuilder: (context, index) {
                    var oankiKullanici = snapshot.data![index];
                    // fireStordaki tüm kullanıcılar geldi, tüm kullanıclar arasında kullanıcı kendiyle konuşamayacağı
                    //için kullanıcının kendisini gelen tüm kullanıcılar arasından çıkarttım.
                    if (oankiKullanici.userId != _userModel.userModel!.userId) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => KonusmaPage(
                                  sohbetEdilenUser: oankiKullanici,
                                  currentUser: _userModel.userModel!),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(oankiKullanici.userName!),
                          subtitle: Text(oankiKullanici.email),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.withAlpha(20),
                              backgroundImage:
                                  NetworkImage(oankiKullanici.profilUrl!)),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  refleshPerson();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Center(
                      child: Text(
                        "Kayıtlı kullanıcı bulunamadı!",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<Null> refleshPerson() async {
    // uygulama kullanırken yeni kullanıcı eklemesş ya da mesajın gelip gelmemdiğini kontrol etmek için refleshIndıcator kullandım. setState kullanmamın amacı buildi tekrar tetiklemesidir.
    setState(
      () {
        Future.delayed(
          Duration(seconds: 1),
        );
      },
    );
    return null;
  }
}
 */
