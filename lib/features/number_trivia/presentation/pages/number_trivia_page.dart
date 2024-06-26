import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20,),
              // top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if(state is Empty) {
                    return const DisplayMessage(message: 'Start Searching!',);
                  } else if(state is Loading) {
                    return const LoadingWidget();
                  } else if(state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if(state is Error) {
                    return DisplayMessage(message: state.message);
                  } else {
                    return const SizedBox.shrink();
                  }
                }
              ),

              const SizedBox(height: 20,),
          
              // bottom half
              TriviaControls()
            ]
          ),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {

  final controller = TextEditingController();
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) => dispatchConceret(),
        ),
              
        const SizedBox(height: 20,),
        Row(
          children: <Widget>[
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: dispatchConceret,
              child: const Text(
                'Search',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            )),
            const SizedBox(width: 20,),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey.shade100,
              ),
              onPressed: dispatchRandom,
              child: const Text(
                'Get Random Trivia',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            )),
          ]
        )
      ]
    );
  }

  void dispatchConceret(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(const GetTriviaForRandomNumber());
  }
}

