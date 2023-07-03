// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:english_words/english_words.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This file has a number of platform-agnostic non-Widget utility functions.

const _myListOfRandomColors = [
  Colors.red,
  Colors.blue,
  Colors.teal,
  Colors.yellow,
  Colors.amber,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.lime,
  Colors.pink,
  Colors.orange,
];

final _random = Random();

// Avoid customizing the word generator, which can be slow.
// https://github.com/filiph/english_words/issues/9
final wordPairIterator = generateWordPairs();

String generateRandomHeadline() {
  final artist = capitalizePair(wordPairIterator.first);

  return switch (_random.nextInt(10)) {
    0 => '$artist says ${nouns[_random.nextInt(nouns.length)]}',
    1 => '$artist arrested due to ${wordPairIterator.first.join(' ')}',
    2 => '$artist releases ${capitalizePair(wordPairIterator.first)}',
    3 => '$artist talks about his ${nouns[_random.nextInt(nouns.length)]}',
    4 => '$artist talks about her ${nouns[_random.nextInt(nouns.length)]}',
    5 => '$artist talks about their ${nouns[_random.nextInt(nouns.length)]}',
    6 =>
      '$artist says their music is inspired by ${wordPairIterator.first.join(' ')}',
    7 =>
      '$artist says the world needs more ${nouns[_random.nextInt(nouns.length)]}',
    8 =>
      '$artist calls their band ${adjectives[_random.nextInt(adjectives.length)]}',
    9 =>
      '$artist finally ready to talk about ${nouns[_random.nextInt(nouns.length)]}',
    _ => 'Failed to generate news headline',
  };
}

List<MaterialColor> getRandomColors(int amount) {
  return List<MaterialColor>.generate(amount, (index) {
    return _myListOfRandomColors[_random.nextInt(_myListOfRandomColors.length)];
  });
}

List<String> getRandomNames(int amount) {
  return wordPairIterator
      .take(amount)
      .map((pair) => capitalizePair(pair))
      .toList();
}

String capitalize(String word) {
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}

String capitalizePair(WordPair pair) {
  return '${capitalize(pair.first)} ${capitalize(pair.second)}';
}

const List<MaterialColor> colorsList = [
  Colors.blueGrey,
  Colors.brown,
  Colors.indigo,
];

const List<String> taskTypeList = ["长期习惯", "本周任务", "每日任务"];

List<String> taskContentList = ["看电影", "看话剧", "逛超市"];

List<bool> taskStateList = [false, false, false];

bool animationActive = true;

Future<void> saveTask(int taskIndex) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // 任务内容
  await prefs.setString("taskContext$taskIndex", taskContentList[taskIndex]);
  // 任务完成状态
  await prefs.setBool("task$taskIndex", taskStateList[taskIndex]);
  // 任务完成时间
  DateTime now = DateTime.now();
  await prefs.setInt("time$taskIndex", now.day);
}

Future<void> getTask(int taskIndex) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString("taskContext$taskIndex") != null) {
    taskContentList[taskIndex] = prefs.getString("taskContext$taskIndex")!;
  }
  if (prefs.getBool("task$taskIndex") != null) {
    taskStateList[taskIndex] = prefs.getBool("task$taskIndex")!;
  }
  if (prefs.getInt("time$taskIndex") != null) {
    int finishedDay = prefs.getInt("time$taskIndex")!;
    int nowDay = DateTime.now().day;
    if ((nowDay > finishedDay) && (taskIndex == 0)) {
      taskStateList[taskIndex] = false;
    }
    if ((nowDay > finishedDay) &&
        (DateTime.now().weekday == 1) &&
        (taskIndex == 1)) {
      taskStateList[taskIndex] = false;
    }
  }
}
