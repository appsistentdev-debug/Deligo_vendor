import 'package:delivoo_store/Components/custom_appbar.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  bool chatOpen = false;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(144.0),
          child: CustomAppBar(
            leading: IconButton(
              icon: Hero(
                tag: 'arrow',
                child: Icon(Icons.keyboard_arrow_down),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Hero(
                tag: 'Delivery Boy',
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 22.0,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    title: Text(
                      'George Anderson',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context)!.deliveryPartner,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    trailing: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              icon: Icon(
                                chatOpen ? null : Icons.message,
                                color: kMainColor,
                                size: 18.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  chatOpen = !chatOpen;
                                });
                                if (chatOpen) {}
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: orderBlackLight, width: 1)),
                            child: IconButton(
                              icon: Icon(
                                Icons.phone,
                                color: kMainColor,
                                size: 18.0,
                              ),
                              onPressed: () {
                                /*.......*/
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
      body: chatOpen
          ? Stack(
              children: [
                Opacity(
                  opacity: 0.08,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'assets/map1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // MessageStream(),
                    Container(
                      color: kWhiteColor,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: EntryField(
                        controller: _messageController,
                        hint: AppLocalizations.of(context)!.enterMessage,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: kMainColor,
                          ),
                          onPressed: () {
                            _messageController.clear();
                          },
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/map1.png',
                fit: BoxFit.fill,
              ),
            ),
    );
  }
}
