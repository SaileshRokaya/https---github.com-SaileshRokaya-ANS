// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ans/fees/fees_form.dart';
import 'package:ans/leaves/leave_form.dart';
import 'package:ans/leaves/reason_leave.dart';
import 'package:ans/model/leave_model.dart';
import 'package:ans/provider/leave_service_provider.dart';
import 'package:ans/service/leave_service.dart';
import 'package:ans/views/Events_read.dart';
import 'package:ans/views/account.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LeaveList extends StatefulWidget {
  const LeaveList({Key? key}) : super(key: key);

  @override
  State<LeaveList> createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {
  // Create an empty list to store the list of event coming from the database
  List<LeaveModel>? leaveDatas;

  // Create a method reloadData to update the UI screen
  void reloadData() async {
    final postMdl = Provider.of<LeaveServiceProvider>(context, listen: false);
    leaveDatas = await LeaveService().getLeaveData();
    postMdl.updateEvent(leaveDatas!);
  }

  // Create a method user form status
  void checkStatus() {
    final postMdl = Provider.of<LeaveServiceProvider>(context, listen: false);
  }

  // Create a method getEventUser to get all the event list
  getEventUser() async {
    // All the event list will be stored in eventDatas
    leaveDatas = await LeaveService().getLeaveData();
  }

  String heading = "About fee payment date extend";

  // This method will call everytime
  @override
  void initState() {
    reloadData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<LeaveServiceProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("List Of Leaves Form"),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaveForm()));
              }),

          // The body part is here
          body: Container(
            // Check the condition whether the list is empty or not
            // if the list is empty, then it will display no data found
            // Otherwise it will display the list of events
            child: provider.leaveList.isEmpty
                ? Center(
                    child: const Text(
                    "No data found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ))
                : ListView.builder(
                    itemCount: provider.leaveList.length,
                    itemBuilder: (context, position) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        elevation: 5.0,
                        shadowColor: Colors.grey,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),

                          // It contain the title of the event coming from the database
                          // with the help of provider
                          title: Text(provider.leaveList[position].name,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 21.0)),

                          // It will contain the data and time
                          // that coming from the data and convert in string
                          subtitle: Text(
                            provider.leaveList[position].status,
                            // Text(
                            //   DateFormat("\ndd-MM-yyyy kk:mm a")
                            //       .format(date)
                            //       .toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit icon function here
                              IconButton(
                                  onPressed: () {
                                    // After pressing the edit button the page will forward to admin event update page
                                    // with two value eventGetList which is list
                                    // Other was index
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             AdminEventUpdatePage(
                                    //               eventModel: model,
                                    //             )));
                                  },
                                  icon: Icon(Icons.edit)),

                              // Delete icon function here
                              IconButton(

                                  // After pressing the delete icon the respective id will be passed through the
                                  // deleteEvent method to delete the respective event data.
                                  onPressed: () async {
                                    int data = int.parse(
                                        provider.leaveList[position].id);

                                    await LeaveService().deleteEvent(data);
                                    print("My deleteable id is: $data");

                                    //   Update event method will be called with the help of provider
                                    //   to update the UI screen of event list
                                    leaveDatas =
                                        await LeaveService().getLeaveData();
                                    provider.updateEvent(leaveDatas!);
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),

                          // By tapping the particular card, it will show the body content of event
                          // With the help of alerdialog method
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      scrollable: true,
                                      content: Text(provider
                                          .leaveList[position].reqReason),
                                    ));
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
