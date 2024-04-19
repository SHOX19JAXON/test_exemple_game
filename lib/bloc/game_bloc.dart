import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../data/models/game_models.dart';
import '../model/model.dart';
import '../screens/game/game_screen.dart';
import '../screens/lottie/lottie_screen.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc()
      : super(
          GameState(
            currentQuestionIndex: 0,
            allQuestions: questions,
            trueCount: 0,
            enteredAnswer: "",
            letterList: const [],
            isStartAnimation: false,
          ),
        ) {
    on<LoadQuestionsEvent>(onInit);
    on<NextQuestionsEvent>(onNext);
    on<CollectEnteredLetterEvent>(onCollect);
    on<RemoveEvent>(onRemove);
  }

  onInit(LoadQuestionsEvent event, emit) {
    String answerText = questions[state.currentQuestionIndex].trueAnswer;

    emit(
      state.copyWith(
        allQuestions: questions,
        letterList: getOptionLetters(answerText),
      ),
    );
  }

  onRemove(RemoveEvent event, emit) {
    emit(
      state.copyWith(
        enteredAnswer: state.enteredAnswer.replaceAll(event.alphabet, ""),
      ),
    );
  }

  onNext(NextQuestionsEvent event, emit) {
    if (state.currentQuestionIndex < questions.length - 1) {
      int newQuestionIndex = state.currentQuestionIndex + 1;
      getOptionLetters(
          state.allQuestions[state.currentQuestionIndex].trueAnswer);
      emit(state.copyWith(currentQuestionIndex: newQuestionIndex));
      emit(
        state.copyWith(
          enteredAnswer: "",
          letterList:
              getOptionLetters(state.allQuestions[newQuestionIndex].trueAnswer),
        ),
      );
    } else {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => const LottieScreen(),
        ),
      );
    }
  }

  onCollect(CollectEnteredLetterEvent event, emit) async {
    String text = state.enteredAnswer;
    text += event.letter;
    emit(state.copyWith(enteredAnswer: text));
    if (state.enteredAnswer ==
        state.allQuestions[state.currentQuestionIndex].trueAnswer) {
      add(NextQuestionsEvent(event.context));
    } else if (state.enteredAnswer.length ==
        state.allQuestions[state.currentQuestionIndex].trueAnswer.length) {
      if (isStartAnimation) {
        globalAnimationController.reverse();
        emit(
          state.copyWith(isStartAnimation: false),
        );
      } else {
        globalAnimationController.forward();
        emit(state.copyWith(isStartAnimation: true));
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isStartAnimation: false));
      }
      emit(
        state.copyWith(
          enteredAnswer: "",
        ),
      );
    }
  }
}

String alphabet = "qwertyuiopasdfghjklzxcvbnm";

List<String> getOptionLetters(String answerText) {
  int len = answerText.length;

  for (int i = 0; i < (12 - len); i++) {
    Random random = Random();
    int index = random.nextInt(26);
    answerText += alphabet[index];
  }
  List<String> letterList = answerText.split('');
  letterList.shuffle();
  return letterList;
}


