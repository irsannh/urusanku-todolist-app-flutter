/* eslint-disable indent */
/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyTaskCompletion = functions.database
  .ref("/UsersData/{userId}/tasks/{taskId}/isDone")
  .onUpdate(async (change, context) => {
    const before = change.before.val();
    const after = change.after.val();

    if (!before && after) {
      const userId = context.params.userId;
      const taskId = context.params.taskId;

      const userSnapshot = await admin
        .database()
        .ref(`/UsersData/${userId}`)
        .once("value");
      const userData = userSnapshot.val();

      // Periksa apakah userData dan fcmToken ada
      if (!userData || !userData.fcmToken) {
        console.error("FCM Token tidak ditemukan untuk user:", userId);
        return null;
      }

      // Periksa apakah task ada
      const task = userData.tasks ? userData.tasks[taskId] : null;
      if (!task) {
        console.error("Task tidak ditemukan untuk taskId:", taskId);
        return null;
      }

      const fcmToken = userData.fcmToken;
      const notificationTitle = "Satu Urusan Anda Selesai";
      const notificationMessage = `Urusan ${task.taskName} telah anda selesaikan`;

      const currentDate = new Date();
      const day = currentDate.getDate();
      const monthNames = [
        "Januari",
        "Februari",
        "Maret",
        "April",
        "Mei",
        "Juni",
        "Juli",
        "Agustus",
        "September",
        "Oktober",
        "November",
        "Desember",
      ];

      const month = monthNames[currentDate.getMonth()];
      const year = currentDate.getFullYear();
      const hours = currentDate.getHours();
      const minutes = currentDate.getMinutes().toString().padStart(2, "0");
      const formattedDateTime = `${day} ${month} ${year} - ${hours}.${minutes}`;

      const message = {
        notification: {
          title: notificationTitle,
          body: notificationMessage,
        },
        token: fcmToken,
      };

      await admin.messaging().send(message);

      const notificationData = {
        title: notificationTitle,
        message: notificationMessage,
        notificationTime: formattedDateTime,
      };

      return admin
        .database()
        .ref(`/UsersData/${userId}/notifications/${Date.now()}`)
        .set(notificationData);
    }

    return null;
  });
